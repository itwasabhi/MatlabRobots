function h = plotRobotPose(pos,rad,col)

if nargin < 3
    col = 'k';
end

h1 = plot(pos(1), pos(2), [col,'*']);
h = [h1];

if (length(pos)>2)
rFront = robot2global(pos, [rad,0]);
rCent = robot2global(pos, [0,0]);
h2= plot([rFront(1) rCent(1)], [rFront(2) rCent(2)], [col,'-']);
h = [h, h2];
end
end