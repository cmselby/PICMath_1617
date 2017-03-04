function [k]=TrackExtraction(displayoption,extractionoption,data,dusktime,dawntime)
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

close all
clc

if display == 1;
    showInitialData = extractionoption;
else
    showInitialData = 0;
end

%Load the Image
[gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap]=SperateDayandNight(showInitialData,time1,time2,d);

%Initialize variables
if extraction == 0;
    map = gra_rngmap;
elseif extraction == 1;
        map = gray_day_rngmap;
elseif extraction == 2;
    map = gray_night_rngmap;
elseif extraction == 3;
    map = gray_dawn_rngmap;
end

k = zeros(size(map));

if extraction == 2
    coeff = 0.8;
else
    coeff = 0.9;
end

%Find the thresholding value
denomap = map;
A=denomap.';
[value,pos] = max(var(A));
thresholding = mean(mean(A(:,pos-2:pos+2)));

%Thresholding
for i = 1: size(map,1);
    for j = 1: size(map,2);
        if map(i,j)>thresholding*coeff;
            k(i,j)=1;
        end
    end
end

if display == 1
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    title('Simple Filtering')
end

%Use connectivity,erodion and dialation to delete small noise
CC = bwconncomp(k);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = find(numPixels<3);
for in=1:size(idx,2)
    k(CC.PixelIdxList{idx(in)}) = 0;
end

if display == 1
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    title('Deleting Small Noise by connectivity')
end


% SE = strel('line',3,0);
% k = imerode(k,SE);
% k = imdilate(k,SE);
% 
% if display == 1
%     figure;
%     imshow(k);
%     set(gca,'YDir','norm'); 
%     title('Deleting Small Noise horizantally')
% end
% 
% 
% SE = strel('rectangle',[2 2]);
% k = imerode(k,SE);
% k = imdilate(k,SE);
% 
% if display == 1
%     figure;
%     imshow(k);
%     set(gca,'YDir','norm'); 
%     title('Deleting Small Noise vertically')
% end


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

if display == 1
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
    title('Deleting Vertical Noise')
end

%Do erodsion and dialation again
SE1 = strel('rectangle',[2 2]);
SE2 = strel('line',2,0);
SE3 = strel('line',2,90);
SE4 = strel('line',3,45);
SE5 = strel('line',3,325);

if extraction == 2
    k = imerode(k,SE1);
    k = imdilate(k,SE1);
    k = imerode(k,SE2);
    k = imdilate(k,SE2);
else
    k = imerode(k,SE1);
    k = imdilate(k,SE1);
end
k = imdilate(k,SE2);
CC = bwconncomp(k);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = find(numPixels<7);
for in=1:size(idx,2)
    k(CC.PixelIdxList{idx(in)}) = 0;
end

if display == 1
    figure;
    imshow(k);
    set(gca,'YDir','norm'); 
	title('Clean Image');
end

end