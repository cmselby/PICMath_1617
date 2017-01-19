function [day_rngmap,night_rngmap]=SperateDayandNight(d)
%function [day_rngmap,night_rngmap]=SperateDayandNight(d)

d='ROF_CODAR_20160502_4350_ch0.mat';
load(d);
time=min(find(rngmap(size(rngmap,1),:)< mean(rngmap(size(rngmap,1),:))));%The number of column when night starts
day_rngmap=rngmap(1:size(rngmap,1),1:time);
night_rngmap=rngmap(1:size(rngmap,1),time:size(rngmap,2));
% figure;
% imagesc(day_rngmap);
% figure;
% imagesc(night_rngmap);