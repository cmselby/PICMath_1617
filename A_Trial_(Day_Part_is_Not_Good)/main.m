clear;
clc;
close all;
%Initialize variables
mintime = 15; %minimum time last for a track (unit:minutes)
d='ROF_CODAR_20160502_4350_ch0.mat';
time1 = 620;%When evening starts
time2 = 1380;%When morning starts
nightcof = 0.8; %Use for threshold, please see "TrackExtraction.m"
daycof = 0.9; %Use for threshold, please see "TrackExtraction.m"

load(d);
k = zeros(size(rngmap));
[gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap,day_rngmap,night_rngmap,dawn_rngmap]=SperateDayandNight(0,time1,time2,d);

%Day
[k_day]=TrackExtraction(0,1,d,time1,time2,nightcof,daycof);
%Night
[k_night]=TrackExtraction(0,2,d,time1,time2,nightcof,daycof);
%Dawn
[k_dawn]=TrackExtraction(0,3,d,time1,time2,nightcof,daycof);

%Combining three parts together
k = zeros(size(rngmap));
k(:,1:time1) = k_day;
k(:,time1+1:time1 + size(k_night,2)) = k_night;
k(:,time2+1:end) = k_dawn;

[table,picture] = TrackOutput(k,rngmap,mintime);

save('TrackExtraction.mat','picture','table','t','rngmap');

%Display input data and final results
figure;
imagesc(t,range(rangeix),rngmap); 
set(gca,'YDir','norm'); 
title('Data')

figure;
imshow(picture);
set(gca,'YDir','norm'); 
title('Result');
