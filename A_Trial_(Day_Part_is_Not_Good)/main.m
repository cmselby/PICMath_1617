clc;close all;clear;
%Initialize variables
mintime = 15; %minimum time last for a track (unit:minutes)
d='ROF_CODAR_20160502_4350_ch0.mat';
time1 = 620; %When evening starts
time2 = 1380; %When morning starts
nightcof = 0.8; %Use for threshold, please see "TrackExtraction.m"
daycof = 0.9; %Use for threshold, please see "TrackExtraction.m"

load(d);
k = zeros(size(rngmap));
day_rngmap=rngmap(:,1:time1);
night_rngmap=rngmap(:,time1+1:time2);
dawn_rngmap=rngmap(:,time2+1:end);

gray_rngmap=mat2gray(rngmap);
gray_day_rngmap=mat2gray(day_rngmap);
gray_night_rngmap=mat2gray(night_rngmap);
gray_dawn_rngmap=mat2gray(dawn_rngmap);

%Day
[k_day]=TrackExtraction(0,1,d,time1,time2,nightcof,daycof,gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap);
%Night
[k_night]=TrackExtraction(0,2,d,time1,time2,nightcof,daycof,gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap);
%Dawn
[k_dawn]=TrackExtraction(0,3,d,time1,time2,nightcof,daycof,gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap);

%Combining three parts together
k = zeros(size(rngmap));
k(:,1:time1) = k_day;
k(:,time1+1:time1 + size(k_night,2)) = k_night;
k(:,time2+1:end) = k_dawn;

[table,picture] = TrackOutput(k,rngmap,mintime);

half_max = zeros(size(picture));
for row = 1:(size(table,1)/3)
    col = 1;
    p = 3*row - 2;
    while (col<= size(table,2) && (table(p,col) ~=0))
        half_max([table(p+1,col):table(p+2,col)],table(p,col))=1;
        col = col + 1;
    end
end

save('TrackExtraction.mat','picture','table','rngmap','half_max');

%Display input data and final results
figure;
imagesc(t,range(rangeix),rngmap); 
set(gca,'YDir','norm'); 
title('Data')

figure;
imshow(picture);
set(gca,'YDir','norm'); 
title('Result');

figure;
imshow(half_max);
set(gca,'YDir','norm'); 
title('Half-Max Result');
