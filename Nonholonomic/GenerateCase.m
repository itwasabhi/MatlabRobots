function GenerateCase

p = load('d_primitives.mat');
map = load('../Maps/Blocks1.mat');

carStart.state = [-5, -17, pi/2];
carStart.config = [2];
carStart.primitives = p.allPrims;

carGoal = carStart;
carGoal.state = [-17, 12.5, 0];

plotCase(carStart, carGoal, map);

filename = 'examples/Case11_Blocks.mat';
save(filename, 'carStart', 'carGoal', 'map');
end