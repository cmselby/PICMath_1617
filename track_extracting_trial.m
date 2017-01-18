function res=track_extracting_trial(d)
%function res=track_extracting_trial(d)
%Export a matrix res which contain location and time of tracks
d='ROF_CODAR_20160502_4350_ch0.mat'

load(d)
k=ones(size(rngmap));
denomap = zeros(size(rngmap));

for i = 1: size(denomap,1)
    for j = 1: size(denomap,2)
        if j<size(denomap,2)-1
            denomap(i,j) = (rngmap(i,j)+rngmap(i,j+1)+rngmap(i,j+2))/3;
        else
            denomap(i,j) = rngmap(i,j);
        end
    end
end


for i = 1: size(rngmap,1)
    for j = 1: size(rngmap,2)
        if denomap(i,j)<-111
            k(i,j)=0;
        end
    end
end
res=k;
imshow(k)