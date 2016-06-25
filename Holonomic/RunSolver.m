function RunSolver()
clc; close all;
figure; hold on;
%Select desired map
map = load('../Maps/Blocks1.mat');
axis([map.xRange, map.yRange]);
plotLines(map.lines, '-k');

%Select desired figure
piano = load('Pianos/slits.mat');

%Desired initial configuration
initialConfig = [-4,7,-pi/2];
init_Global = getLinesInGlobal(piano.lines, initialConfig);
plotRobotPose(initialConfig, 1);
plotLines(init_Global, '-b');

%Desired final configuration
goalConfig = [5,-7,pi/2];
goal_Global = getLinesInGlobal(piano.lines, goalConfig);
plotRobotPose(goalConfig, 1);
plotLines(goal_Global, '-g');

%%%%
% Search for solution (RRT, PRM)
path = buildRRT(map.lines, piano.lines, initialConfig, goalConfig, 1, 1000);
plotFinalPath(piano.lines, path, 1, 0.1, true);
end
