function h = plotRobot(robot, c)
h = [];

if (nargin<2)
    c = 'k';
end

if length(robot.config)>1
    % Robot is a set of lines
    linesGlobal = getLinesInGlobal(robot.config, robot.state);
    h = plotLines(linesGlobal, c);
else
    % Robot is a point
    h = plotRobotPose(robot.state, robot.config, c);
end
end