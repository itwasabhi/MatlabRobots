function ret = directPathInFreeSpace(map, config, qA, qB, minSpacing)

delta = qB - qA; 
qMidpoint = (qB + qA)/2;
totalDist = norm(delta); 
if (totalDist<minSpacing)
    ret = true;
    return;
end

robotMidpoint.config = config;
robotMidpoint.state = qMidpoint;

if robotInFreeSpace(robotMidpoint, map) && ...
    directPathInFreeSpace(map, config, qA, qMidpoint, minSpacing) && ...
    directPathInFreeSpace(map, config, qMidpoint, qB, minSpacing)
    ret = true; 
else
    ret = false;
end

end