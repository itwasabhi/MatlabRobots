function allSamp = sampleRandom(nVert, walls, robot)
%INPUTS:
%   nVert: number of samples
%   walls: Cell array where each cell holds vertices of an obstacle

%OUTPUTS:
%   allSamp = nVert-by-3 sample points


allSamp = zeros(nVert,3);

xBound = [min([walls(:,1); walls(:, 3)]),  max([walls(:,1); walls(:, 3)])];
yBound = [min([walls(:,2); walls(:, 4)]),  max([walls(:,2); walls(:, 4)])];
thetaBound = [0, 2*pi];

completed = 0;
while completed~=nVert
    %Get random sample
    currSamp = [getRand(xBound), getRand(yBound), getRand(thetaBound)];
    
    %Check if sample is in q_free and add to list
    if stateInFreeSpace(walls, robot, currSamp)
        completed = completed+1;
        allSamp(completed, :) = currSamp;
    end
end

end

function val = getRand(bounds)
	val = (bounds(2)-bounds(1))*rand(1) + bounds(1);
end