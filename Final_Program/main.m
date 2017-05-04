%Set data
data = 'ROF_CODAR_20160502_4350_ch0.mat'
%Extrack tracks (Please see 'TrackExtraction.m' for explaination of arguments)
TrackExtraction(data,0.849,0.625,1380,620,15);

%Load the result
name= strsplit(data,'.');
res_name = strcat(strcat('Track_',name(1)),'.mat')
load(char(res_name));
figure;
imshow(half_max);
set(gca,'YDir','norm'); 
xlabel('Universal Time (minutes)');
ylabel('Height (km)');
