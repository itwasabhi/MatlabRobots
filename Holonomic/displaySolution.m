function displaySolution(caseFile, sID, saveToFile)
if nargin<3
    saveToFile = '';
else
    %Need to save the file! Generate filename
    casePrefix = caseFile(1:end-4);
    saveToFile = strcat(casePrefix, '_', int2str(sID), '.gif');
end

c = load(caseFile);
plotCase(c.robotStart, c.robotGoal, c.map);
title( c.solutions{sID}.info);

% Save intial frame to GIF if needed
if (length(saveToFile)>4)
    SaveFrameToGif(saveToFile, 0,1);
end

robotConfig = c.robotStart.config;
path = c.solutions{sID}.path;
dt = 0.1;
stepSize = 1;
displayHistory = true;
plotFinalPath(robotConfig, path, stepSize, dt, displayHistory, saveToFile)

% Save final frame to GIF if needed
if (length(saveToFile)>4)
    SaveFrameToGif(saveToFile, 0, 0);
end

end