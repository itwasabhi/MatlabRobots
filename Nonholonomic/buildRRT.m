function [controls] = buildRRT(carStart, carGoal, map)
%Grows RRT and finds path from startPt to endPt. Returns a set of waypoints. Plots RRT online.  

%INPUTS

%OUTPUTS

plotting = 2;
allVert = carStart.state;
adjMat = 0;
primitives = carStart.primitives;

assert(stateInFreeSpace(carStart, map), 'Start state not in free space');
assert(stateInFreeSpace(carGoal, map), 'End state not in free space');

%Parameters
maxN = 100;

goalUnlocked = false;
while (size(allVert,1)<maxN) && (~goalUnlocked)
    
    currSamp = sampleRandom(1, map, carStart);
    plotRobotPose(currSamp, 1, 'y');
  
    [newVert, allVert, adjMat] = growTree(currSamp, allVert, adjMat, carStart, map, 'c');
    
    %Check if edge is in free space, considering robot radius.
    if ~isempty(newVert)
        goalUnlocked = checkTreeForState(allVert, carGoal.state, .3);
    end
    
    pause(0.1);
end

%Build path using adjacency Vertex
if goalUnlocked
    nextPrev = size(adjMat,1);
    controls = allVert(nextPrev,:);
    while nextPrev ~= 1
        nextPrev = find(adjMat(:,nextPrev));
        controls = [allVert(nextPrev,:); controls];
    end
    
    fprintf('RRT Path found!\n');
else
    controls = [];
    fprintf('Could not find a path within search limit.\n');
end

end