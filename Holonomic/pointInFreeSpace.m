function ret = pointInFreeSpace(obstVert, boundVert, pt, robotRad)
%Checks if a point is in q_free. Considers robotRadius

%INPUTS
%   obstVert: Cell array where each cell holds vertices of an obstacle
%   boundVert: k-by-2 array that stores k points of boundary
%   pt: [x y] of point to check

ret = true;

%Check if point is within boundary
if ~isempty(boundVert)
if ~inpolygon(pt(1), pt(2), boundVert(:,1), boundVert(:,2))
    ret=false;
    return;
end
end

%Check if point is outside obstacle
for i = 1:length(obstVert)
    if inpolygon(pt(1), pt(2), obstVert{i}(:,1), obstVert{i}(:,2))
        ret = false;
        return 
    end
end

if (nargin<4) || (robotRad==0)
    return
end

%Check if pt is away from boundary p
requiredDist = robotRad;

if ptNearPolygon(boundVert, pt, requiredDist)
	ret = false;
    return;
end

for o =1:length(obstVert)
    currVert=obstVert{o};
    if ptNearPolygon(currVert, pt, requiredDist)
        ret = false;
        return;
    end
end



end

function ret = ptNearPolygon(currVert, pt, requiredDist)
ret = false;
for i = 1:size(currVert,1)
    X3 = currVert(i, 1); Y3 = currVert(i, 2);
    
    if i==size(currVert,1)
        X4 = currVert(1, 1); Y4 = currVert(1, 2);
    else
        X4 = currVert(i+1, 1); Y4 = currVert(i+1, 2);
    end
    
    l1 = [X3,Y3]; l2 = [X4,Y4];
    minDist = distancePointToLineSegment(pt, l1, l2);
    
    if (minDist < requiredDist)
        ret=true;
        return;
    end
end
end

function distance = distancePointToLineSegment(p, a, b)
%Taken from: https://gist.github.com/jcchurch/1961989#file-distancepointtolinesegment-m

    % p is a point
    % a is the start of a line segment
    % b is the end of a line segment
 
    pa_distance = sum((a-p).^2);
    pb_distance = sum((b-p).^2);
 
    unitab = (a-b) / norm(a-b);
 
    if pa_distance < pb_distance
        d = dot((p-a)/norm(p-a), -unitab);
 
        if d > 0
            distance = sqrt(pa_distance * (1 - d*d));
        else
            distance = sqrt(pa_distance);
        end
    else
        d = dot((p-b)/norm(p-b), unitab);
 
        if d > 0
            distance = sqrt(pb_distance * (1 - d*d));
        else
            distance = sqrt(pb_distance);
        end
    end
end
