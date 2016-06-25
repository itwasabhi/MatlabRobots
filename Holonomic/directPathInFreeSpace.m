function ret = directPathInFreeSpace(walls, robot, qA, qB, minSpacing)

delta = qB - qA; 
qMidpoint = (qB + qA)/2;
totalDist = norm(delta); 
if (totalDist<minSpacing)
    ret = true;
    return;
end

if stateInFreeSpace(walls, robot, qMidpoint) && ...
    directPathInFreeSpace(walls, robot, qA, qMidpoint, minSpacing) && ...
    directPathInFreeSpace(walls, robot, qMidpoint, qB, minSpacing)
    ret = true; 
    %plotRobot(qMidpoint, 1,'g')

else
    ret = false;
    %plotRobot(qMidpoint, 1,'r')
end

end