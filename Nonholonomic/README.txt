Important Files:

 - RunPrimitives
  -- For designing and visualizing primitives
  -- Saves primitives to 'allPrims' variable im 'primitives.mat'

 - SimpleSimulator


 - plotControlledVehicle(car, prim)
  -- Propogates car according to primitive and returns propogated car




`````````````````````````
setup.mat: 
    - carStart, carGoal, map

example.mat:
    - carStart, carGoal, map
    - solvedControls -- array of struct:
        -- solvedControls{1}.controls
        -- solvedControls{2}.planner_config

controls = SolveCase(case_config, planner_config, plot_config)

PlotSolution(case, controls)