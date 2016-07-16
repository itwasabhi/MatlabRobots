## Holonomic

This project generates paths to move holonomic robots from an initial to goal configuration. The robot can be an arbitrarily shaped object ("Piano"), or a point with a radius. The robot can be defined in either the (R^2 x S^1) or (R^2) configuration space. 

One planner has been implemented:
- RRT, [1]

### Examples
![Go object gooo](https://github.com/as2587/MatlabRobots/blob/master/Holonomic/examples/slitsInBlocks1.gif)
![Go object gooo](https://github.com/as2587/MatlabRobots/blob/master/Holonomic/examples/Cas2_Point_1.gif)

### To Run
- In order run a solver, you must define a *Case*: robot, start and end configurations, map. Use `GenerateCase.m` to help configure a case. 
  - If you want the robot to be a random object, define it as a set of lines... see `Pianos/' for some examples

- Use `RunSolver.m` to load a case, configure a planner, and find a solution. The solution, if exists, will be appended to the *Case* file. 

- Use `displaySolution.m` with a *Case* file to display an animation of the solution. 


### References
[1] Planning Algorithms, Steve LaValle
