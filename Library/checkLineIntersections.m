function ret = checkLineIntersections(setA, setB, plotIntersections)

if (nargin<3)
    plotIntersections = false;
end

ret = true;
out = lineSegmentIntersect(setA, setB);
intersections = find(out.intAdjacencyMatrix(:)==1);
if ~isempty(intersections)
    if plotIntersections
        scatter(out.intMatrixX(intersections),out.intMatrixY(intersections),[],'r');
    end
    ret = false;
end

end