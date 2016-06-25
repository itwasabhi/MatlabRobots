function animateCar(car, controlIDs, saveToFile)
for c = 1:length(controlIDs)
    cPrim = getControls(car.primitives, controlIDs(c));
    car = propogateVehicle(car, cPrim(1:2), cPrim(3), saveToFile);
end
end
