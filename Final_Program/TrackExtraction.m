function TrackExtraction(data,daycof,nightcof,sunrise_time,sunset_time,mintime)
%%function whole_program(data,dayIcof,nightcof,sunrise_time,sunset_time,mintime)
%Input
%dataset - STRING. Name of dataset, which contains rngmap,
%          rangeix(range of height),default: 'ROF_CODAR_20160502_4350_ch0.mat'.
%daycof - Double/Float. Coefficient for threshholding on dayI part of data from 0 to 1, 
%         default: 0.849
%nightcof - Double/Float. Coefficient for threshholding on night part of data from 0 to 1, 
%           default: 0.625
%sunrise_time - INT. Universal time of sunrise in minutes passed UT 00:00,
%               default: 1380(UT 23:00)
%sunset_time - INT. Universal time of sunset in minutes passed UT 00:00,
%               default: 620(UT 10:20)
%mintime - INT. the minimum time in minutes for a "useful" track,
%                    default: 15
%Output
%A .mat file with name: 'Track'+data's name + '.mat',which includes
%half_max - a binary image with the same size as rngmap to show locaton of
%           tracks with full range in height at half maximum
%tracks - a 3n-by-m matrix, where n is number of tracks. For nth track in
%         the data, 3n-2 shows its time(minutes), 3n-1 shows the lower bound of
%         height(km) at that time, and 3n shows the upper bound of height(km) at
%         that time

%%Initialize parameters
if ~exist('data')
    d = 'ROF_CODAR_20160502_4350_ch0.mat';
else
    d = dataset;
end
if ~exist('daycof')
    daycof = 0.849;
end
if ~exist('nightcof')
    nightcof = 0.625;
end
if ~exist('sunset_time')
    sunset_time = 620;
end
if ~exist('sunrise_time')
    sunrise_time = 1380;
end
if ~exist('mintime')
    mintime = 15;
end

%%initialize variables
range = [];
load(data);
k = zeros(size(rngmap));
dayI_rngmap=rngmap(:,1:sunset_time);
night_rngmap=rngmap(:,sunset_time+1:sunrise_time);
dayII_rngmap=rngmap(:,sunrise_time+1:end);

%Split the original data into three parts
gray_rngmap=mat2gray(rngmap);
gray_dayI_rngmap=mat2gray(dayI_rngmap);
gray_night_rngmap=mat2gray(night_rngmap);
gray_dayII_rngmap=mat2gray(dayII_rngmap);

%Denoising
%dayI
[k_dayI]=ImageDenoising(gray_dayI_rngmap,0,1,sunset_time,sunrise_time,daycof);
%Night
[k_night]=ImageDenoising(gray_night_rngmap,0,2,sunset_time,sunrise_time,nightcof);
%dayII
[k_dayII]=ImageDenoising(gray_dayII_rngmap,0,3,sunset_time,sunrise_time,daycof);

%Combining three parts together
k = zeros(size(rngmap));
k(:,1:sunset_time) = k_dayI;
k(:,sunset_time+1:sunset_time + size(k_night,2)) = k_night;
k(:,sunrise_time+1:end) = k_dayII;

%Extract track information
[table,picture] = TrackOutput(k,rngmap,mintime);
hts = range(rangeix);
tracks = table;
for i = 1:size(table,1)
    if mod(i,3)~=1
        for j = 1:size(table,2)
            if table(i,j) ~= 0
                tracks(i,j) = hts(table(i,j));
            end
        end
    end
end

%Create binary image where each track has full range in height at half maximum
half_max = zeros(size(picture));
for row = 1:(size(table,1)/3)
    col = 1;
    p = 3*row - 2;
    while col<= size(table,2) && table(p,col) ~=0
        half_max([table(p+1,col):table(p+2,col)],table(p,col))=1;
        col = col + 1;
    end
end

%Save the output
first= strsplit(data,'.');
name = strcat(strcat('Track_',first(1)),'.mat');
save(char(name),'half_max','tracks');
end