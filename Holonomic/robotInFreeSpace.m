function ret = robotInFreeSpace(robot, map)

if length(robot.config)>1
    % Robot is a set of lines
    ret = linesInFreeSpace(robot, map.lines);
else
    % Robot is a point
    ret = pointInFreeSpace(robot, map);
end

end


function ret = linesInFreeSpace(robot, walls)
linesGlobal = getLinesInGlobal(robot.config, robot.state);
ret = checkLineIntersections(linesGlobal, walls);
end


function ret = pointInFreeSpace(robot, map)
ret = true;
pt = robot.state(1:2);
rad = robot.config;

for i = 1:size(map.lines,1)
    l1 = map.lines(i, 1:2); l2 = map.lines(i, 3:4);
    minDist = distancePointToLineSegment(pt, l1, l2);
    
    if (minDist < rad)
        ret=false;
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