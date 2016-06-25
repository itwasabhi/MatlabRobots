function minID = findNearestPoint(q, allVert)
%INPUTS
%   q = [x,y] point
%   allVert = k-by-3 list of points

%OUTPUTS
%   minID = row_idx of point in allVert that is closest to q

minDist = norm(allVert(1,:) - q);
minID = 1;
for i=2:size(allVert,1)
    tempDist = norm(allVert(i,:) - q);
    if tempDist<minDist
        minDist = tempDist;
        minID = i;
    end
end
end