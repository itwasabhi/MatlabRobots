function ret = stateInFreeSpace(walls, robot, q, plotError)
%INPUTS
%   walls = n-by-4 matrix describing n walls 
%   robot = n-by-4 matrix describing n lines that make up a robot
%   q     = [x, y, theta] position of robot in a global frame
%   plotError = true/false for plotting any points where robot and
%               wall intersect

%OUTPUTS
%   ret = true/false based on whether robot_q intersect walls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin<4)
    plotError = false;
end

robot_Global = getLinesInGlobal(robot, q);
ret = checkLineIntersections(robot_Global, walls, plotError);

end