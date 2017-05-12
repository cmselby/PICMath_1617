function [k]=ImageDenoising(rngmap,displayoption,extractionoption,sunrisetime,sunsettime,coeff)
%function [k]=ImageDenoising(displayoption,data,sunrisetime,sunsettime,extractionoption)
%Extract tracks in the given data and ouput a binary image to demonstrate
%time and height of tracks
%Inputs
%rngmap - the data
%displayoption - 0 for not showing the process, 1 for showing the process, default:0
%sunrisetime - Time when sun sets(number of minutes from 0:00),default:620
%sunsettime - Time when sun rises(number of minutes from 0:00),default :1380
%extractionoption - 0 for the whole data, 1 for dayI part, 2 for night part,
%                   and 3 for dayII part,default:2
%coeff- a coeffecient from 0 to 1 that thresholds data
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
    
if ~exist('sunrisetime')
    time1 = 620;
else
    time1 = sunrisetime;
end

if ~exist('sunsettime')
    time2 = 1380;
else
    time2 = sunsettime;
end

if ~exist('cof')
    nightcof = 0.625;
end

if display == 1;
    showInitialData = extractionoption;
else
    showInitialData = 0;
end

%Initialize variables
map = rngmap;
k = zeros(size(map));

%Do erodsion and dialation again
SE1 = strel('rectangle',[2 2]);
SE2 = strel('line',2,0);
SE6 = strel('line',10,0);
SE3 = strel('line',2,90);
SE4 = strel('line',3,45);
SE5 = strel('line',3,325);

map = imdilate(map,SE1);
map = imerode(map,SE1);
map = imerode(map,SE2);
map = imdilate(map,SE5);

if display ~=0
    figure;
    imshow(map);
    set(gca,'YDir','norm'); 
    if extraction == 1
        title('dayItime I');
    elseif extraction ==2
        title('Nighttime');
    elseif extraction ==3
        title('dayItime II');
    end
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
        title('dayItime I');
    elseif extraction ==2
        title('Nighttime');
    elseif extraction ==3
        title('dayItime II');
    end
end

%Use connectivity to delete small noise
CC = bwconncomp(k);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = find(numPixels<10);
for in=1:size(idx,2)
    k(CC.PixelIdxList{idx(in)}) = 0;
end

%Delete large vertical noise
for c = 1: size(k,2);
    count = 0;
    for r = 1: size(k,1);
        if k(r,c)>0;
            count = count + 1;
        end
    end
    if count >= size(k,1)*0.4
        k(:,c) = 0;
    end
end

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
        title('dayItime I');
    elseif extraction ==2
        title('Nighttime');
    elseif extraction ==3
        title('dayItime II');
    end
end

end