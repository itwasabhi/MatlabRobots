function allh = plotRobots(robots)
allh = []; 
for j =1:length(robots)
    ch = plotRobotPose(robots{j}.currPos, robots{j}.rad);
    allh = [allh, ch];
end
end