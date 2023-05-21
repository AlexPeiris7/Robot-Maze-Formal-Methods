/* Maze
 * Author:  W1761873 - Alexio Peiris - 2018110
 * Creation date: 2022-12-28
 */
MACHINE
    Maze
CONSTANTS
    width,
    height,
    x_axis_range,
    y_axis_range,
    maze,
    internal_maze_walls,
    entrance_square,
    exit_square
    
PROPERTIES
    width = 7 & 
    height = 5 & 
    // setting up the ranges of the x and y axis as per the specification
    x_axis_range <: NATURAL1 & x_axis_range = 1..width & 
    y_axis_range <: NATURAL1 & y_axis_range = 1..height &
    maze : x_axis_range <-> y_axis_range &
    //generating the maze using the cartesian product of x and y axis ranges
    maze = x_axis_range * y_axis_range &
    internal_maze_walls : x_axis_range <-> y_axis_range &
    //setting the internal walls in the maze
    internal_maze_walls = {
        (1 |-> 3),
        (2 |-> 1), 
        (2 |-> 3),
        (2 |-> 5),
        (3 |-> 3),
        (4 |-> 2),
        (4 |-> 3), 
        (4 |-> 4), 
        (6 |-> 1), 
        (6 |-> 2),
        (6 |-> 4), 
        (7 |-> 4)}  &
    entrance_square : x_axis_range <-> y_axis_range &
    //setting the entrance square to the start point
    entrance_square = {(1 |-> 1)} &
    exit_square : x_axis_range <-> y_axis_range &
    //setting the exit square to the end point
    exit_square = {(1 |-> 5)}
END
