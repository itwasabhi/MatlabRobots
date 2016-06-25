function globalLines = getLinesInGlobal(lines, pose)
nl = size(lines,1);
globalLines = zeros(nl, 4);

for l = 1:nl
    globalLines(l, :) = [robot2global(pose, lines(l, 1:2)), robot2global(pose, lines(l, 3:4))];
end
end