function RunSolver()
%Specify a case file to solve, the solver, and some information
% If a solution is found, it will be saved into the case file

clc; close all;

currentCase = 'examples/Case2_Point.mat';
c = load(currentCase);

plotCase(c.robotStart, c.robotGoal, c.map);

params = [];
path = runSolver(c, @buildRRT, params);
info = 'RRT';

if ~isempty(path)
    if ~isfield(c, 'solutions')
        c.solutions = {};
    end
    solutionID = length(c.solutions)+1;
    
    c.solutions{solutionID}.path = path;
    c.solutions{solutionID}.info = info;
    c.solutions{solutionID}.params = params;
    save(currentCase, '-struct', 'c'); %Save current case with solutions
    displaySolution(currentCase, solutionID);
end
end

function path = runSolver(c, planner, params)
path = planner(c.robotStart, c.robotGoal, c.map, params);
end