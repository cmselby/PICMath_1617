function [picture]=whole_program(daycof,nightcof)
%Default daycof = 0.9 nightcof = 0.8
%Initialize variables
mintime = 15; %minimum time last for a track (unit:minutes)
d='ROF_CODAR_20160502_4350_ch0.mat';
time1 = 620; %When evening starts
time2 = 1380; %When morning starts

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
picture=picture.*gray_rngmap;
save('TrackExtraction.mat','picture','table','rngmap');

%Display input data and final results
% figure;
% imagesc(t,range(rangeix),rngmap); 
% set(gca,'YDir','norm'); 
% title('Data')
% 
% figure;
% imshow(picture);
% set(gca,'YDir','norm'); 
% title('Result');
end