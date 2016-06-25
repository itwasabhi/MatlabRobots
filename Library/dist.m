function d = dist(p1, p2)
%INPUTS:
%   p1 = [x y] of point 1
%   p2 = [x y] of point 2

%OUTPUTS:
%   d = euclidian distance between p1 and p2


d = norm(p1 - p2);
end