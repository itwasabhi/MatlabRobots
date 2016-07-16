function plotCase(robotStart, robotGoal, map)
figure; hold on;
axis equal;

%Plot map, start, and goal
plotLines(map.lines, 'k', 2);
plotRobot(robotStart, 'k');
plotRobot(robotGoal, 'g');

end