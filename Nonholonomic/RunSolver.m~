function RunSolver
%Specify a case file to solve, the solver, and some information
% If a solution is found, it will be saved into the case file

clc; close all;

currentCase = 'examples/Case11_Blocks.mat';
c = load(currentCase);

plotCase(c.carStart, c.carGoal, c.map);

params = [];
controls = runSolver(c, @buildBIRRT, params);%@ carGridSearch % @buildBIRRT
info = 'buildBIRRT';

if ~isempty(controls)
    if ~isfield(c, 'solutions')
        c.solutions = {};
    end
    solutionID = length(c.solutions)+1;
    
    c.solutions{solutionID}.controls = controls;
    c.solutions{solutionID}.info = info;
    c.solutions{solutionID}.params = params;
    save(currentCase, '-struct', 'c'); %Save current case with solutions
    displaySolution(currentCase, solutionID);
end

end


function controls = runSolver(c, planner, params)
controls = planner(c.carStart, c.carGoal, c.map, params);
end
