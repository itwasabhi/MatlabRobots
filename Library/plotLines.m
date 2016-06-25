function h = plotLines(walls, c, lw)
h = [];

%This is hideous, but done for backwards compatibility
if (nargin<3)
    lw = 1;
    if (nargin<2)
        c = 'k';
    end
end
for r = 1:size(walls,1)
    hc = plot([walls(r,1), walls(r,3)],[walls(r,2), walls(r,4)], c, 'linewidth', lw);
    h = [h,hc];
end
end