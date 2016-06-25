## Nonholonomic

Three planners have been implemented:
- RRT, [1]
- BiRRT, [1]
- CarGridSearch, [2]

### Examples

### To Run
- In order run a solver, you must define a *Case*: vehicle, start and end configurations, map. Use `GenerateCase.m` to help configure a case. 

- Use `RunSolver.m` to load a case, configure a planner, and find a solution. The solution, if exists, will be appended to the *Case* file. 

- Use `displaySolution.m` with a *Case* file to display an animation of the solution. 


### References
[1] Planning Algorithms, Steve LaValle
[2] Principles of Robot Motion, Howie Choset