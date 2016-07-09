function displaySolution(caseFile, sID, saveToFile)
if nargin<3
    saveToFile = 'n';
else
    %Need to save the file! Generate filename
    saveToFile = strcat(caseFile, '_', int2str(sID), '.gif');
end

c = load(caseFile);
plotCase(c.carStart, c.carGoal, c.map);
title( c.solutions{sID}.info);

% Save intial frame to GIF if needed
if (length(saveToFile)>4)
    SaveFrameToGif(saveToFile, 0,1);
end

animateCar(c.carStart, c.solutions{sID}.controls, saveToFile);

% Save final frame to GIF if needed
if (length(saveToFile)>4)
    SaveFrameToGif(saveToFile, 0, 0);
end

end