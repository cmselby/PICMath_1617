function [gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap,day_rngmap,night_rngmap,dawn_rngmap]=SperateDayandNight(displayoption,dusktime,dawntime,data)
%function [gray_rngmap,gray_day_rngmap,gray_night_rngmap,gray_dawn_rngmap]=SperateDayandNight(displayoption,dusktime,dawntime,data)
%Seperate the original data into 3 parts: day, night and dawn
%Then return gray scale of whole data and day, night and dawn part of data
%Dawn part is similar to day part
%Inputs
%displayoption - display gray-scale data:1 for day part, 2 for night, and 3
%for dawn, default:0
%dusktime - Time when night starts(number of minutes from 0:00),default:620
%dawntime - Time when a new dawn starts(number of minutes from 0:00),default :1380
%data - default is 'ROF_CODAR_20160502_4350_ch0.mat'
%Ouputs
%Gray-scale of each part of data and the whole data.

if ~exist('displayoption')
    display = 0;
else
    display = displayoption;
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
    
if ~exist('data')
    d='ROF_CODAR_20160502_4350_ch0.mat';
else
    d=data;
end

load(d);
length = size(rngmap,1);

day_rngmap=rngmap(1:length,1:time1);
night_rngmap=rngmap(1:length,time1:time2);
dawn_rngmap=rngmap(1:length,time2:size(rngmap,2));

gray_rngmap=mat2gray(rngmap);
gray_day_rngmap=mat2gray(day_rngmap);
gray_night_rngmap=mat2gray(night_rngmap);
gray_dawn_rngmap=mat2gray(dawn_rngmap);

if display == 1
    figure;
    imshow(gray_day_rngmap);
    set(gca,'YDir','norm'); 
    title('Day part');
end

if display == 2
    figure;
    imshow(gray_night_rngmap);
    set(gca,'YDir','norm'); 
    title('Night part');
end

if display == 3
    figure;
    imshow(gray_dawn_rngmap);
    set(gca,'YDir','norm'); 
    title('Dawn part');
end
end

