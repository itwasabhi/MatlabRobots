function ret = checkTreeForState(vert, goal, distCloseEnough)

nVert = size(vert,1);
allDistances = zeros(nVert,1);
for v=1:size(vert,1)
    allDistances(v) = dist(goal, vert(v,:));
end

[val, id] = min(allDistances);

ret = 0;
if (val<distCloseEnough)
    ret = id;
end

end
