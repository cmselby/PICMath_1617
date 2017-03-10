clear;
clc;
%Initialize variables
d='ROF_CODAR_20160502_4350_ch0.mat';
load(d);
k = zeros(size(rngmap));
time1 = 620;%When evening starts
time2 = 1380;%When morning starts
[gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap]=SperateDayandNight(0,time1,time2,d);

%Day
[k_day]=TrackExtraction(0,1,d,time1,time2);
%Night
[k_night]=TrackExtraction(0,2,d,time1,time2);
%Dawn
[k_dawn]=TrackExtraction(0,3,d,time1,time2);

%Combining three parts together
for i = 1: size(k_day,1);
    for j = 1: size(k_day,2);
        if k_day(i,j)==1;
            k(i,j)=1;
        end
    end
end

for i = 1: size(k_night,1);
    for j = 1: size(k_night,2);
        if k_night(i,j)==1;
            k(i,j+time1)=1;
        end
    end
end

for i = 1: size(k_dawn,1);
    for j = 1: size(k_dawn,2);
        if k_dawn(i,j)==1;
            k(i,j+time2)=1;
        end
    end
end

%Display input data and final results
figure;
imshow(gray_rngmap);
set(gca,'YDir','norm'); 
title('Data')

figure;
imshow(k);
set(gca,'YDir','norm'); 
title('Result')
