d='ROF_CODAR_20160502_4350_ch0.mat';
time1 = 620;
time2 = 1380;
display = 1;

close all
clc
%Load the Image
[gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap]=SperateDayandNight(1,time1,time2,d);

%Initialize variables
map = gray_day_rngmap;
k = zeros(size(map));
coeff = 0.9;

%Find the thresholding value
A=map.';
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

k = imerode(k,SE1);
k = imdilate(k,SE1);
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