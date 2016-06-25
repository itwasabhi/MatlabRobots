function GenPianos()
% a Piano is a series of line segments. The origin of Piano is at (0,0)
% with the front of the piano at (1,0). 
t=0.5;
h=2;

lines = [0,0,4,0;
         4,0,4,t;
         4,t, t, t;
         t, t, t, h;
         t, h, 0,h;
         0,h,0,0];
clc; close all;

figure;hold on;
axis([-10,10,-10,10]);
plotLines(lines, '-k');

save('Pianos/LShape.mat', 'lines')
end