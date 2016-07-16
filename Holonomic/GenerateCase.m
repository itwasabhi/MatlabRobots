function GenerateCase

map = load('../Maps/Blocks1.mat');

%The robot could be configured the following ways:
% -STATE
%       -- DOF of robot can be in [x,y] or [x,y,theta]
%
% -CONFIG
%       -- A random object where config = an arbitrary set of lines
%       [x1, y1, x2 y2; x3 y3, x4 y4];
%       -- A point where config = [radius]

% Its possible to have a point robot with [x,y,theta], but that would be an
% unecessary burden on the planner since the robot is assumed to be
% holonomic.

p = load('Pianos/slits.mat');
robotStart.state = [-5, -17];
robotStart.config = [2];

robotGoal = robotStart;
robotGoal.state = [-17, 12.5];

plotCase(robotStart, robotGoal, map);

filename = 'examples/Case2_Point.mat';
save(filename, 'robotStart', 'robotGoal', 'map');
end