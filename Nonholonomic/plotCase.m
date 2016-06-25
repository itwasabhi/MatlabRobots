function plotCase(carStart, carGoal, map)
figure; hold on;
axis equal;

%Plot map, start, and goal
plotLines(map.lines, 'k', 2);
plotVehicle(carStart, 'k');
plotVehicle(carGoal, 'g');

end