function plotFinalPath(robotConfig, path, stepSize, dt, dispHistory, saveToGif)

if ~isempty(saveToGif)
    SaveFrameToGif(saveToGif, dt, 1);
end

currRobot.config = robotConfig;
currRobot.state = path(1,:);
h = plotRobot(currRobot);

for p = 2:size(path,1)
    subPath = getDirectPath(path(p-1,:), path(p,:), stepSize);
    
    for s = 1:size(subPath,1)
        if (dt>0)
            pause(dt);
        end
        if ~isempty(h) && ~dispHistory
            delete(h);
        end
        currRobot.state = subPath(s,:);
        h = plotRobot(currRobot, 'b');
        
        if ~isempty(saveToGif)
        SaveFrameToGif(saveToGif, dt, 0);
        end
    end
end

currRobot.state = path(end,:);
plotRobot(currRobot);

end


function path = getDirectPath(qA, qB, stepSize)
delta = qB-qA;
qMidpoint = (qB + qA)/2;

totalDist = norm(delta); 
if (totalDist<stepSize)
    path = [];
    return;
end

firstHalf = getDirectPath(qA, qMidpoint, stepSize);
secondHalf = getDirectPath(qMidpoint, qB, stepSize);
path = [ firstHalf; qMidpoint; secondHalf];

end
