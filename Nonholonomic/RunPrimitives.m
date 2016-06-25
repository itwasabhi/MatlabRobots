function RunPrimitives
clc; close all;
figure; hold on;
axis([-20,20,-20,20]);
carA.state = [0,0,0];
carA.config = [2];
plotVehicle(carA, 'b');

% carGoal = carA;
% carGoal.state = [10,-5,0,0];
% PlotVehicle(carGoal, 'm');


%%%% List of Primitives
t = 0.25;
v = 5;
a = 0.4; %pi/4~=.79
allPrims = [v,0, t;
            -v, 0, t;
            v, a, t;
            v, -a, t;
            -v, a, t;
            -v, -a, t;
            ];
        
save('d_primitives.mat', 'allPrims');

for p=1:size(allPrims,1)
    carRuning = propogateVehicle(carA, allPrims(p,1:2),allPrims(p,3), 'y');
    plotRobotPose(carRuning.state, 1);
    plotVehicle(carRuning, 'g');
    pause(0.5);
end

end