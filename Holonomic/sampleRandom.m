function allSamp = sampleRandom(nVert, map, robot)
%INPUTS:
%   nVert: number of samples
%   walls: Cell array where each cell holds vertices of an obstacle

%OUTPUTS:
%   allSamp = nVert-by-3 sample points


nDOF = length(robot.state);
allSamp = zeros(nVert,nDOF);

completed = 0;
while completed~=nVert
    %Get random sample
    sampledState = getSample(map, nDOF);
    robot.state = sampledState;
    
    %Check if sample is in q_free and add to list
    if robotInFreeSpace(robot, map)
        completed = completed+1;
        allSamp(completed, :) = sampledState;
    end
end

end


function sample = getSample(map, nDOF)
sample = [getRand(map.xRange), getRand(map.yRange)];

if (nDOF==3)
    % Robot state is [x,y,theta]... generate a theta sample as well
    sample = [sample, getRand([0, 2*pi])];
end

end

function val = getRand(bounds)
val = (bounds(2)-bounds(1))*rand(1) + bounds(1);
end