function res = stateInFreeSpace(car, map)
res = true;

%Make sure car is within bounds
%TODO: this should use bounds of carLines instead of car state
if ~(IsInRange(car.state(1), map.xRange) && IsInRange(car.state(2), map.yRange))
    res = false;
end

%Make sure car doesn't collide with map
carLines = getVehicleLines(car, 1);
if ~checkLineIntersections(map.lines, carLines)
    res = false;
end

end


function res = IsInRange(val, range)
if (val>range(1) && val<range(2))
    res = true;
else
    res = false;
end
end