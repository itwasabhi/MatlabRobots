## Holonomic

This is a planner to move an arbitrarily shaped object ("Piano") from an initial to goal configuration. The object is assumed to be able to move in any direction in the configuration space (R^2 x S^1)
One planner has been implemented:
- RRT, [1]

### Examples
![Go object gooo](https://github.com/as2587/MatlabRobots/blob/master/Holonomic/examples/slitsInBlocks1.gif)

### To Run
- Define a random object as a set of lines... see `Pianos/' for some examples

- Use `RunSolver.m` to load a map, configure a planner, and find a solution. The solution, if exists, will be animated. 


### References
[1] Planning Algorithms, Steve LaValle
