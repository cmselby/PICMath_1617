function [k]=TrackExtraction(displayoption,extractionoption,data,dusktime,dawntime,nightcof,daycof,gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap)
%function [k]=TrackExtraction(displayoption,data,dusktime,dawntime,extractionoption)
%Extract tracks in the given data and ouput a binary image to demonstrate
%time and height of tracks
%Inputs
%displayoption - 0 for not showing the process, 1 for showing the process, default:0
%dusktime - Time when night starts(number of minutes from 0:00),default:620
%dawntime - Time when a new dawn starts(number of minutes from 0:00),default :1380
%data - default is 'ROF_CODAR_20160502_4350_ch0.mat'
%extractionoption - 0 for the whole data, 1 for day part, 2 for night part,
% and 3 for dawn part,default:2
%nightcof - a coffecient from 0 to 1 that thresholds night part image
%daycof - a coffecient from 0 to 1 that thresholds day part image
%Ouput
%k - a binary image to demonstrate time and height of tracks

if ~exist('displayoption')
    display = 0;
else
    display = displayoption;
end

if ~exist('extractionoption')
    extraction = 2;
else
    extraction = extractionoption;
end

if ~exist('data')
    d='ROF_CODAR_20160502_4350_ch0.mat';
else
    d=data;
end
    
if ~exist('dusktime')
    time1 = 620;
else
    time1 = dusktime;
end

if ~exist('dawntime')
    time2 = 1380;
else
    time2 = dawntime;
end

if ~exist('nightcof')
    nightcof = 0.8;
end

if ~exist('daycof')
    daycof = 0.9;
end

if display == 1;
    showInitialData = extractionoption;
else
    showInitialData = 0;
end

%Initialize variables
if extraction == 0;
    map = gra_rngmap;
end
if extraction == 1;
   map = gray_day_rngmap;
end
if extraction == 2;
    map = gray_night_rngmap;
end
if extraction == 3;
    map = gray_dawn_rngmap;
end

k = zeros(size(map));

if extraction == 2
    coeff = nightcof;
else
    coeff = daycof;
end

%Find the thresholding value(Find the location of "Surface Wave")
A=map.';
[value,pos] = max(mean(A));
thresholding = mean(mean(A(:,pos-2:pos+2)));

%Thresholding
for i = 1: size(map,1);
    for j = 1: size(map,2);
        if map(i,j)>thresholding*coeff;
            k(i,j)=1;
        end
    end
end

if display ~=0
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    if extraction == 1
        title('Day Part Result After Thresholding');
    elseif extraction ==2
        title('Night Part Result After Thresholding');
    end
end

%Use connectivity,erodion and dialation to delete small noise
CC = bwconncomp(k);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = find(numPixels<10);
for in=1:size(idx,2)
    k(CC.PixelIdxList{idx(in)}) = 0;
end

if display ~=0
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    title('Deleting Small Noise by connectivity')
end

%Delete large vertical noise
for c = 1: size(k,2);
    count = 0;
    for r = 1: size(k,1);
        if k(r,c)>0;
            count = count + 1;
        end
    end
    if count >= size(k,1)*0.1
        k(:,c) = 0;
    end
end

if display ~=0
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    if extraction == 1
        title('Day Part Result After Deleting Vertical Noise');
    elseif extraction ==2
        title('Night Part Result After Deleting Vertical Noise');
    end
    %title('Day Part Result After Deleting Vertical Noise')
end

%Do erodsion and dialation again
SE1 = strel('rectangle',[2 2]);
SE2 = strel('line',2,0);
SE6 = strel('line',10,0);
SE3 = strel('line',2,90);
SE4 = strel('line',3,45);
SE5 = strel('line',3,325);

k = imdilate(k,SE1);
k = imerode(k,SE1);
k = imerode(k,SE2);
k = imdilate(k,SE5);

CC = bwconncomp(k);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = find(numPixels<8);
for in=1:size(idx,2)
    k(CC.PixelIdxList{idx(in)}) = 0;
end

if display ~=0
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    if extraction == 1
        title('Day Part Result After Erosion and Dilation');
    elseif extraction ==2
        title('Night Part Result After Erosion and Dilation');
    end
	%title('Clean Image');
end

end