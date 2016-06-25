%Check if pt is within a velocity obstacle
function [ptOutside, errID] = checkVO(pt, allVO)
%allVO is a cell array with obstacles where each cell is a 3-by-2 matrix
%with   row 1 == center pt
%       row 2 == endpt 1
%       row 3 == endpt 2

ptOutside = true;
errID = 0;
for i=1:length(allVO)
    if ~isempty(allVO{i})
        %plotSingVO(allVO{i});

        vo_poly = [allVO{i}(1,:); allVO{i}(3,:); allVO{i}(2,:)];
        if inpolygon(pt(1), pt(2), vo_poly(:,1), vo_poly(:,2))
            errID = i;
            ptOutside = false;
            return
        end
    end
end

end