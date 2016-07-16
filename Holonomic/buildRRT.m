function [path] = buildRRT(robotStart, robotGoal, map, params)
%Grows RRT and finds path from startPt to endPt. Returns a set of waypoints.

%Ensure start and end points are valid
assert(robotInFreeSpace(robotStart, map), 'Start state not in free space');
assert(robotInFreeSpace(robotGoal, map), 'End state not in free space');

% Setup some parameters (or load from params)
lineStepSize = 0.1;
searchStepSize = 1;
maxN = 1000;

% Get variables ready
allVert = robotStart.state;
adjMat = 0;
robotConfig = robotStart.config;
goalUnlocked = false;
failedSamp = 0;

while (size(allVert,1)<maxN) && (~goalUnlocked)
    currSamp = sampleRandom(1, map, robotStart);
    
    %Find closest point in current tree
    nearID = findNearestPoint(currSamp, allVert);
    
    %Extend closest point by stepSize
    delta  = currSamp- allVert(nearID,:);
    newState = allVert(nearID,:) + delta/norm(delta)*searchStepSize;
    robotNew.config = robotConfig;
    robotNew.state = newState;
    
    nearState = allVert(nearID,:);

    %Check if edge is in free space
    if robotInFreeSpace(robotNew, map) && ... 
        directPathInFreeSpace(map, robotConfig, nearState, newState, lineStepSize);
        
        allVert =[allVert; newState];
        [ra, ca] = size(adjMat);
        newAdj = zeros(ra+1, ca+1);
        newAdj(1:ra, 1:ca) = adjMat;
        newAdj(nearID, end) = 1;
        adjMat = newAdj;
        
        %Check if endPt is in view from q_new
        if directPathInFreeSpace(map, robotConfig, newState, robotGoal.state, lineStepSize)
            goalUnlocked = true;            
        end
    else
        failedSamp = failedSamp+1;
    end
    
end

%Build path using adjacency vertex
if goalUnlocked
    nextPrev = size(adjMat,1);
    path = allVert(nextPrev,:);
    while nextPrev ~= 1
        nextPrev = find(adjMat(:,nextPrev));
        path = [allVert(nextPrev,:); path];
    end
    path = [path; robotGoal.state];
    
    fprintf('RRT Path found!\n');
else
    path = [];
    fprintf('Could not find a path within search limit.\n');
end

end