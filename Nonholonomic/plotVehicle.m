function h=plotVehicle(vehic, c)
% car.state = [x , y, theta,theta1, theta2, ... thetaK]
% car.config = [carLength, trailerLength, dHitch1, dHitch2, ... dHitchK]
% figure; hold on;
% car.state = [0,0,0,0,pi/16];
% car.config = [5];
% axis([-5,5,-5,5]);

% car.config = [carLength] 
%%%%%%%
col = 'r';
if (nargin>1)
    col = c;
end

allLines = getVehicleLines(vehic);
h = plotLines(allLines, col);

end