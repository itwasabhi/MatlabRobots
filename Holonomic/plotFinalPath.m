function plotFinalPath(robot, path, steps, animate, dispHistory, saveToGif)

if ~isempty(saveToGif)
    SaveFrameToGif(saveToGif, animate, 1);
end

%h = transformAndPlot(robot, path(1,:));
h = [];
for p = 2:size(path,1)
    subPath = getDirectPath(robot, path(p-1,:), path(p,:), steps);
    
    for s = 1:size(subPath,1)
        if (animate>0)
            pause(animate);
        end
        if ~isempty(h) && ~dispHistory
            delete(h);
        end
        h = transformAndPlot(robot, subPath(s,:));
        
        if ~isempty(saveToGif)
        SaveFrameToGif(saveToGif, animate, 0);
        end
    end
end

%transformAndPlot(robot, path(end,:));

end


function path = getDirectPath(robot, qA, qB, steps)
delta = qB-qA;
qMidpoint = (qB + qA)/2;

totalDist = norm(delta); 
if (totalDist<steps)
    path = [];
    return;
end

firstHalf = getDirectPath(robot, qA, qMidpoint, steps);
secondHalf = getDirectPath(robot, qMidpoint, qB, steps);
path = [ firstHalf; qMidpoint; secondHalf];

end

function h = transformAndPlot(robot, q)
q_global = getLinesInGlobal(robot, q);
h = plotLines(q_global, '-b');
end