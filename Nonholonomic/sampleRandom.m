function allSamp = sampleRandom(nVert, map, car)
%INPUTS:
%   nVert: number of samples
%   walls: Cell array where each cell holds vertices of an obstacle

%OUTPUTS:
%   allSamp = nVert-by-3 valid sample points

allSamp = zeros(nVert,3);
thetaRange = [-pi, pi];

completed = 0;
while completed~=nVert
    %Get random sample
    currSamp = [getRand(map.xRange), getRand(map.yRange), getRand(thetaRange)];
    currCar = car;
    currCar.state = currSamp;
    
    %Check if sample is in q_free and add to list
    if stateInFreeSpace(currCar, map)
        completed = completed+1;
        allSamp(completed, :) = currSamp;
    end
end

end

function val = getRand(bounds)
	val = (bounds(2)-bounds(1))*rand(1) + bounds(1);
end