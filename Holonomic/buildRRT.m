function [path] = buildRRT(walls, robot, qStart, qEnd, searchStepSize, maxN)
%Grows RRT and finds path from startPt to endPt. Returns a set of waypoints. Plots RRT online.  

%INPUTS
%   obstVert: Cell array where each cell holds vertices of an obstacle
%   boundVert: k-by-2 array that stores k points of boundary
%   startPt = [x,y] start position
%   endPt = [x,y] end (goal) position
%   stepSize = Step size for RRT segments
%   robotRad = radius of robot
%   maxN = max number of iterations before giving up

%OUTPUTS
%   path = l-by-3 array that stores waypoints to traverse from qStart to
%           qEnd
lineStepSize = 0.1;
allVert = qStart;
adjMat = 0;

assert(stateInFreeSpace(walls, robot, qStart), 'Start state not in free space');
assert(stateInFreeSpace(walls, robot, qEnd), 'End state not in free space');


goalUnlocked = false;
failedSamp = 0;
while (size(allVert,1)<maxN) && (~goalUnlocked)
    currSamp = sampleRandom(1, walls, robot);
    
    %Find closest point in current tree
    nearID = findNearestPoint(currSamp, allVert);
    
    %Extend closest point by stepSize
    delta  = currSamp- allVert(nearID,:);
    qNew = allVert(nearID,:) + delta/norm(delta)*searchStepSize;
        
    
    %Check if edge is in free space, considering robot radius.
    if stateInFreeSpace(walls, robot, qNew) && directPathInFreeSpace(walls, robot, allVert(nearID,:), qNew, lineStepSize);
        %sample_Global = GetRobotInGlobal(robot, currSamp);
        %plotRobot(qNew, 1, 'c');
        %plotLines(sample_Global, '-m');
        
        allVert =[allVert; qNew];
        [ra, ca] = size(adjMat);
        newAdj = zeros(ra+1, ca+1);
        newAdj(1:ra, 1:ca) = adjMat;
        newAdj(nearID, end) = 1;
        adjMat = newAdj;
        
        %Check if endPt is in view from q_new
        if directPathInFreeSpace(walls, robot, qNew, qEnd, lineStepSize)
            goalUnlocked = true;            
        end
    else
        failedSamp = failedSamp+1;
    end
    
end

%Build path using adjacency Vertex
if goalUnlocked
    nextPrev = size(adjMat,1);
    path = allVert(nextPrev,:);
    while nextPrev ~= 1
        nextPrev = find(adjMat(:,nextPrev));
        path = [allVert(nextPrev,:); path];
    end
    path = [path; qEnd];
    
    fprintf('RRT Path found!\n');
else
    path = [];
    fprintf('Could not find a path within search limit.\n');
end

end