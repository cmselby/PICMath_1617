function res=track_extracting_trial(d)
%function res=track_extracting_trial(d)
%Export a matrix res which contain location and time of tracks

min(find(rngmap(size(rngmap,1),:)< mean(rngmap(size(rngmap,1),:))))%The number of column when night starts

d='ROF_CODAR_20160502_4350_ch0.mat';
load(d);
k=ones(size(rngmap));

%Simple moving average denoising
denomap = zeros(size(rngmap));
for i = 1: size(denomap,1);
    for j = 1: size(denomap,2);
        if j<size(denomap,2)-1
            denomap(i,j) = (rngmap(i,j)+rngmap(i,j+1)+rngmap(i,j+2))/3;
        else
            denomap(i,j) = rngmap(i,j);
        end
    end
end

A=denomap.';
[value,pos]=min(var(A));
thresholding=mean(A(pos));

for i = 1: size(rngmap,1);
    for j = 1: size(rngmap,2);
        if denomap(i,j)<thresholding;
            k(i,j)=0;
        end
    end
end
res=k;
figure;
imshow(k);
% figure;
% imagesc(denomap);
% figure;
% imagesc(rngmap);
