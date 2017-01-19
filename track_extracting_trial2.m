function res=track_extracting_trial(d)
%function res=track_extracting_trial(d)
%Export a matrix res which contain location and time of tracks

d='ROF_CODAR_20160502_4350_ch0.mat';
load(d);
k=ones(size(rngmap));
denomap = rngmap;

A=denomap.';
[value,pos]=min(var(A));
thresholding=mean(A(pos));

for i = 1: size(rngmap,1);
    for j = 1: size(rngmap,2);
        if denomap(i,j)<thresholding+3;
            k(i,j)=0;
        end
    end
end
figure;
imshow(k);

for i = 1: size(k,1)-1;
    for j = 1: size(k,2)-1;
        k(i,j) = (k(i,j)+k(i,j+1)+k(i+1,j)+k(i+1,j+1))/4;
        if k(i,j)<1
            k(i,j)=0;
        end
    end
end

res=k;
figure;
imshow(k);