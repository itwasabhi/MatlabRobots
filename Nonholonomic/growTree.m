function [newVert, allVert, adjMat] = growTree(currSamp, allVert, adjMat, car, map, col)
    newVert = [];

    %Find closest point in current tree
    nearID = findNearestPoint(currSamp, allVert);
    
    %Extend closest point by stepSize
    %Use all primitives to get new positions. qNew = propogated state that
    %is closest to the seed
    qNear = allVert(nearID,:);
    carNear = car; carNear.state = qNear;
    
    [qNew, pID] = findExtendedState(carNear, currSamp);
    carNew = car; carNew.state = qNew;

    %Check if edge is in free space, considering robot radius.
    if stateInFreeSpace(carNew, map)
        %sample_Global = GetRobotInGlobal(robot, currSamp);
        plotRobotPose(qNew, 1, col);
        
        allVert =[allVert; qNew];
        [ra, ca] = size(adjMat);
        newAdj = zeros(ra+1, ca+1);
        newAdj(1:ra, 1:ca) = adjMat;
        newAdj(nearID, end) = pID;
        adjMat = newAdj;
        
        newVert = [qNew];
    end
        
end


%Using car, apply all primitives and determine state closest to goal
function [closestState, closestPrimID] = findExtendedState(car, towards)

prims = car.primitives;

% Apply each primitive to qNear. 
closestDistance = inf;
closestPrimID = -1;
closestState = car.state;

for p = 1:size(prims,1)
    carP = propogateVehicle(car, prims(p,1:2), prims(p,3));
    currentDistance = dist(carP.state, towards);
    
    if (currentDistance < closestDistance)
        closestDistance = currentDistance;
        closestPrimID = p;
        closestState = carP.state;
    end
end

end