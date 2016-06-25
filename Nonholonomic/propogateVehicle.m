function car = propogateVehicle(car, control, dt, plotting)
%
% 
%
% INPUTS
% car.state = state of car at t, [x,y,theta, theta_1...]
% control = [u0, u1]
% dt = time step to propogate car

% OUTPUTS
% car.state = state of car at t + dt

if (nargin<4)
    plotting='';
end

deltaPropogation = 0.01; %Keep this pretty small
totalTime = 0;
while totalTime < dt
    car = SmallPropogation(car, control, deltaPropogation);
    totalTime = totalTime + deltaPropogation;
    
    % Plot and save to GIF if needed.
    if (length(plotting)>0)
        currH = plotVehicle(car, 'm');
        pause(deltaPropogation);
        %Enough to to save image for GIF every .1 seconds
        if (length(plotting)>4 && (mod(totalTime, .1)==0))
            SaveFrameToGif(plotting, deltaPropogation, 0);
        end
        delete(currH);
    end
end

end


% For the same set of controls, propogating the vehicle for t1 !=  
% the propogation form t1 + t2
%
% For best performance, propogate using a small dt
function car = SmallPropogation(car, control, dt)

numTrailers = length(car.state)-3;

deltaState = zeros(1, length(car.state));
deltaState(1) = control(1)*cos(car.state(3)); %dx = v*cos(theta)
deltaState(2) = control(1)*sin(car.state(3)); %dy = v*sin(theta)
deltaState(3) = control(1)*tan(control(2))/car.config(1); %d_theta = v*tan(phi)/L

if numTrailers>0
trailerAngles = car.state(4:end);
trailerDistances = car.config(3:end);

for t=1:numTrailers
    deltaState(t+3) = control(1)/trailerDistances(t);
    deltaState(t+3) = deltaState(t+3)*GetAngleProduct([car.state(3), trailerAngles], t+1);   
end
end

car.state = car.state + deltaState.*dt;

end


function res = GetAngleProduct(angles,tIndex)
res = 1;

for i = 2:(tIndex-1)
    res = res*cos(angles(i-1) - angles(i));
end

res = res*sin(angles(tIndex-1)-angles(tIndex));
end
