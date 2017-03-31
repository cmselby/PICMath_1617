function [table,picture] = TrackOutput(current,original,mintime)
%function [table,picture] = TrackOutput(current,original,mintime)
%Output the final image of track a table of track information
%Inputs:
%current - current result
%original - original data
%mintime - minmum time for a track
%Outputs
%table - a table of track information that contains time and range
%picture - the picture contain all tracks
CC = bwconncomp(current);
numPixels = cellfun(@numel,CC.PixelIdxList);
%Get a list of tracks
[biggest,idx] = find(numPixels>1);
otrack = 1;

%Separate each tracks into independent picture
for id=1:size(idx,2)
    sp = zeros(size(current));
    for in=1:size(idx,2)
        if in == id
            sp(CC.PixelIdxList{idx(in)}) = 1;
        end
    end
    stt = regionprops(sp,'PixelList');
    timerange = unique(stt.PixelList(:,1));
    %See if the track is greater than a given time length, e.g. 15 miniutes
    if size(timerange,1) >= mintime
        res(:,:,otrack) = sp;
        otrack = otrack + 1;
    end
end

%Find range of a track in a given time
for ind = 1:size(res,3)
    st = regionprops(res(:,:,ind),'PixelList');
    timerange = unique(st.PixelList(:,1));
    for tm = 1:size(timerange,1)
        [heightrange] = find(st.PixelList(:,1)==(timerange(tm)));
        
        hr = st.PixelList(heightrange,2); 
        ave = mean(original(:,tm));        
        data = original(hr,tm);
        maxi = max(original(hr,tm));
        lowerbound = maxi - abs((maxi - ave))/2;%set a zero mean
        
        [indi] = find(data>lowerbound);
        hr = hr(indi);
        %In the table, tree consecutive lines describ a track
        table(3*(ind-1)+1,tm) = timerange(tm);%First line shows the time of track (unit minutes since 00:00 UTC)
        table(3*(ind-1)+2,tm) = min(hr);%Second line shows the lowerbound of height of the track
        table(3*(ind-1)+3,tm) = max(hr);%Third line shows the upperbound of height of the track;
    end
end
    

picture = sum(res,3);
end
