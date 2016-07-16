function controls = buildBIRRT(carStart, carGoal, map, params)
%Grows bi-RRT and finds path from startPt to endPt. Returns a set of waypoints. Plots RRT online.  

%INPUTS

%OUTPUTS
%   path = l-by-2 array that stores waypoints to traverse from startPt to

s_allVert = carStart.state; s_adjMat = 0;
e_allVert = carGoal.state; e_adjMat = 0;

%Ensure start and end points are valid
assert(stateInFreeSpace(carStart, map), 'Start state not in free space');
assert(stateInFreeSpace(carGoal, map), 'End state not in free space');
assert(length(carStart.state) == length(carGoal.state), 'Start and End state of varying DOF');

%Parameters
maxN = 700;

goalUnlocked = false;

while (size(s_allVert,1)<maxN) && (~goalUnlocked)
    currSamp = sampleRandom(1, map, carStart);
    [s_new, s_allVert, s_adjMat] = growTree(currSamp, s_allVert, s_adjMat, carStart, map, 'c');
    [e_new, e_allVert, e_adjMat] = growTree(currSamp, e_allVert, e_adjMat, carStart, map, 'g');
    
    % Check end condition
    if (~isempty(s_new)) %Check new s with all of e
       isConnected = checkTreeForState(e_allVert, s_new, .2);
       if isConnected
            connectionIndexInE = isConnected;
            connectionIndexInS = length(s_allVert);
            goalUnlocked = true;
       end
    end
    if (~isempty(e_new)) %Check new e with all of s
        isConnected = checkTreeForState(s_allVert, e_new, .2);
        if isConnected
            connectionIndexInS = isConnected;
            connectionIndexInE = length(e_allVert);
            goalUnlocked = true;
        end
    end
    
    pause(0.01);
end

controls = [];
if (goalUnlocked)
    %Build path using adjacency matrix
    s_controls = []; e_controls = [];
    
    %Obtain controls from carStart to intersection of trees
    indexCurr = connectionIndexInS;
    while indexCurr ~= 1
        indexPrev = find(s_adjMat(:,indexCurr));
        s_controls = [s_adjMat(indexPrev, indexCurr); s_controls];
        indexCurr = indexPrev;
    end
    
    %Obtain controls from intersection of trees to carGoal
    indexCurr = connectionIndexInE;
    while indexCurr ~= 1
        indexPrev = find(e_adjMat(:,indexCurr));
        e_controls = [e_controls; -e_adjMat(indexPrev, indexCurr)];
        indexCurr = indexPrev;
    end
    controls = [s_controls; e_controls];
    fprintf('PATH FOUND! \n');
else
    fprintf('Path could not be found. \n');
end
end
