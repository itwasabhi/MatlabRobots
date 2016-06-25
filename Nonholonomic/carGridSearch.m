function controls = carGridSearch(carStart, carGoal, map, params)
% INPUT
%   carStart
%   carGoal
%   map

% params.scaling:
%   - Number of steps
%   - Number of changes in velocity sign
%   - distance to goal
% OUTPUT

%currently only works for x,y,theta

assert(stateInFreeSpace(carStart, map), 'Start-state is not valid');
assert(stateInFreeSpace(carGoal, map), 'Goal-state is not valid');

plotRobotPose(carStart.state(1:3), 1, 'g');
plotRobotPose(carGoal.state(1:3), 1, 'g');

% Parameters
% Load from parameters if available
maxTreeSize = 5000;
scaling = [1,3,3];
if (nargin>3) && isfield(params, 'scaling')
    maxTreeSize = params.maxTreeSize;
    scaling = params.scaling;
end

gridParams.xRange = map.xRange;
gridParams.yRange = map.yRange;
gridParams.thetaRange = [-pi,pi];
gridParams.xRes = 1.5;
gridParams.yRes = 1.5;
gridParams.thetaRes = 0.4; %radians 

searchTree = tree(carStart);
openStates = [1];
openStateCosts = [0];
prims = carStart.primitives;

%Search grid is a matrix discretized over the entire search space
%   A value of 0 == unvisted state
%   A value of 1 == visited state
%   A value of 2 == goal state
searchGrid = InitializeSearchGrid(gridParams);

[gi, gj, gk] = GetGridIndex(gridParams, carGoal.state);
searchGrid(gi, gj, gk) = 2;

% Helpful variables
sizeOfTree = 1;
iterationsCount = 0;

controls = [];
while (~isempty(openStates) && (sizeOfTree<maxTreeSize))
    [currStateID, openStates, openStateCosts] = PickOpenState(openStates, openStateCosts);
    currCar = searchTree.get(currStateID);
    [ci, cj, ck] = GetGridIndex(gridParams, currCar.state);
    ch = plotRobotPose(currCar.state(1:3), 1, 'r');

    if searchGrid(ci, cj, ck)==2            %Check if currState is close enough to goal
        fprintf('PATH FOUND! \n');
        
        controls = ControlsToCurrent(searchTree, currStateID);
        break;
        
    elseif searchGrid(ci, cj, ck)==0        %Check if currState is in a unique position
        searchGrid(ci,cj,ck)=1;
        
        % Apply primitives from current state 
        for p=1:size(prims,1)
            carP = propogateVehicle(currCar, prims(p,1:2), prims(p,3));
            [cpi, cpj, cpk] = GetGridIndex(gridParams, carP.state);
            
            if (stateInFreeSpace(carP, map) && (searchGrid(cpi,cpj,cpk)~=1))
                carP.derivedFromPrimitive = p;
                [searchTree, pID] = searchTree.addnode(currStateID, carP);
                
                currCost = CalculatePathCost(searchTree, pID, prims, carGoal.state, scaling);
                
                openStates = [openStates, pID];
                openStateCosts = [openStateCosts, currCost];
                
                sizeOfTree = sizeOfTree+1;
                plotRobotPose(carP.state(1:3), 1, 'c');
            end
        end
    end
    iterationsCount = iterationsCount+1;

    pause(0.1);
    delete(ch);
end

end



function [popped, list, cost] = PickOpenState(list, cost)
[~, popID] = min(cost);
popped = list(popID);

list(popID) = [];
cost(popID) = [];

end


function [i,j,k] = GetGridIndex(grid, state)
q = state(1:3);
q(3) =  atan2( sin(q(3)), cos(q(3)) ); %incase theta is not in [-pi/2, pi/2]

i = (q(1)-grid.xRange(1))/grid.xRes+1;
j = (q(2)-grid.yRange(1))/grid.yRes+1;
k = (q(3)-grid.thetaRange(1))/grid.thetaRes+1;

i = int8(i); j = int8(j); k = int8(k);
end

function matrix = InitializeSearchGrid(grid)

upperLimits = [grid.xRange(2), grid.yRange(2), grid.thetaRange(2)]; 
[iUpper, jUpper, kUpper] = GetGridIndex(grid, upperLimits);

matrix = zeros(iUpper, jUpper, kUpper);

end

function cost = ManhattanCost(a, b)
    cost = norm(a(1:2)-b(1:2));
end


function cost = CalculatePathCost(searchTree, toID, prims, goalState, scaling)
%Starting from the current node, work up to root and count the following
%   - Number of steps
%   - Number of changes in velocity sign
%   - distance to goal
a = scaling(1); b = scaling(2); c = scaling(3);

numSteps = 0;
numVelChange = 1;

currID = toID;
parentID = searchTree.getparent(currID);

while parentID ~=1
    numSteps= numSteps+1;
    
    currState = searchTree.get(currID);
    primitive_Current = prims(currState.derivedFromPrimitive,:);
    
    parentState = searchTree.get(parentID);
    primitive_Parent = prims(parentState.derivedFromPrimitive,:);
    
    if sign(primitive_Current(1)) ~= sign(primitive_Parent(1))
        numVelChange = numVelChange+1;
    end
    
    currID = parentID;
    parentID = searchTree.getparent(currID);
end

cost = a*numSteps + b*numVelChange + c*ManhattanCost(searchTree.get(toID).state, goalState);

end


%Return controls to go from rootNode(id=0) to current node(id=toID)
function controls = ControlsToCurrent(searchTree, toID)

currID = toID;
parentID = searchTree.getparent(currID);

controls = [];
while parentID ~=0    
    currCar = searchTree.get(currID);
    plotRobotPose(currCar.state, 1, 'r');

    controls = [controls, currCar.derivedFromPrimitive];
    
    currID = parentID;
    parentID = searchTree.getparent(currID);
end

controls = flip(controls);

end
