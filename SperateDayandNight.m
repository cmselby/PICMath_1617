function [day_rngmap,night_rngmap]=SperateDayandNight(d)
%function [day_rngmap,night_rngmap]=SperateDayandNight(d)

d='ROF_CODAR_20160502_4350_ch0.mat';
load(d);
time=min(find(rngmap(size(rngmap,1),:)< mean(rngmap(size(rngmap,1),:))));%The number of column when night starts
day_rngmap=rngmap(1:size(rngmap,1),1:time);
night_rngmap=rngmap(1:size(rngmap,1),time:size(rngmap,2));

figure;
set(0,'DefaultFigureColormap',feval('gray'));
imagesc(day_rngmap);
title('Day Map');
set(gca,'YDir','norm');  

figure;
set(0,'DefaultFigureColormap',feval('gray'));
imagesc(night_rngmap);
title('Night Map');
set(gca,'YDir','norm');  

sobelGradient = imgradient(day_rngmap);
figure
imshow(sobelGradient,[])
title('Sobel Gradient Magnitude')
set(gca,'YDir','norm');  

hy = -fspecial('sobel')
hx = hy'

sigma = 2;
smoothImage = imgaussfilt(day_rngmap,sigma);
smoothGradient = imgradient(smoothImage,'CentralDifference');

figure
imshow(smoothGradient,[])
title('Smoothed Gradient Magnitude')
set(gca,'YDir','norm');  

B = 1/10*ones(10,1);
out = filter(B,1,smoothGradient);
figure 
imagesc(out);
set(gca,'YDir','norm');  
