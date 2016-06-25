function GenMaps()
% Script to help create maps.
%   Set width and height below to define outer bounds
%   Click points in the plotter to add walls. 

clc; close all;

figure; hold on;
axis([-20,20,-20,20]);

h = 15;
w = 20;
lines = getBox(w,h);
plotLines(lines, '-k');

numWalls = 5;
for j =1:numWalls
    [x,y] = ginput(2);
    plot(x, y, '-b');
    lines = [lines; x(1), y(1), x(2), y(2)];
end


xRange = [-w/2, w/2];
yRange =  [-h/2,h/2];
% save('Maps/DoubleSlit.mat', 'lines', 'bounds')
end

function lines = getBox(w, h)
lines = [-w/2, -h/2, w/2, -h/2; 
         w/2, -h/2, w/2, h/2;
         w/2, h/2, -w/2, h/2;
         -w/2, h/2, -w/2, -h/2];
end