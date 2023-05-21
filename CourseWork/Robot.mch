/* Robot
 * Author: W1761873 - Alexio Peiris - 2018110
 * Creation date: 2022-12-28
 */
MACHINE
    Robot
SEES 
    Maze
SETS
    //set which contains all the movement outcomes, used for the move functions, teleport and revert
    MOVEMENT_OUTCOMES = {Exceeding_Maze_Boundary, Maze_Wall_Crash, Moved_North, Moved_East, Moved_South, Moved_West, Cannot_Teleport_To_The_Same_Square, Teleported, Exit_Square_Reached, Move_Reverted, Cannot_Revert_Move, Cannot_Move_To_Specified_Square } ; 
    //set which contains all the intejections, used for the foundExit function
    INTERJECTIONS = {Yes, No};
    //set which contains other texts, used for the reset function
    OTHER_TEXTS = {System_Reinitialised};
    DIRECTIONS = {North, South, East, West}
VARIABLES
    robotXPosition,
    robotYPosition,
    currentPosition,
    //sequence used save all the visited squares
    squaresVisited,
    //ordered pair used to save the position which the robot was previously in
    previousPosition
INVARIANT
    robotXPosition : x_axis_range &
    robotYPosition : y_axis_range &
    currentPosition : maze &
    squaresVisited : seq(maze) &
    previousPosition : maze 
INITIALISATION
    //initialising the variables to the first square
    robotXPosition, robotYPosition := 1, 1 ||
    currentPosition, previousPosition, squaresVisited := ( 1 |-> 1 ), ( 1 |-> 1 ), [( 1 |-> 1 )]
OPERATIONS
    
    //operation which moves the robot to the north
    movementOutcome <-- moveNorth =
    PRE movementOutcome : MOVEMENT_OUTCOMES
    THEN
        //checking if the robot is in the exit square
        IF (currentPosition : exit_square) THEN
            movementOutcome := Exit_Square_Reached
        //checking if moving north meets an internal wall
        ELSIF ((robotXPosition |-> robotYPosition + 1) : internal_maze_walls) THEN
            movementOutcome := Maze_Wall_Crash
        //checking if moving north goes outside the maze
        ELSIF ((robotXPosition |-> robotYPosition + 1)  /: maze) THEN
            movementOutcome := Exceeding_Maze_Boundary 
        //else performing the needed steps to move the robot towards north
    ELSE 
            //Appending element to the end of the squaresVisited
            squaresVisited := (squaresVisited <-  (robotXPosition |-> robotYPosition + 1 )) ||
            robotYPosition := robotYPosition + 1 ||
            currentPosition := (robotXPosition |-> robotYPosition + 1 ) ||
            previousPosition := (robotXPosition |-> robotYPosition) ||
            movementOutcome := Moved_North
        END
    END;
    
    //operation which moves the robot to the south
    movementOutcome <-- moveSouth =
    PRE movementOutcome : MOVEMENT_OUTCOMES
    THEN
        IF (currentPosition : exit_square) THEN
            movementOutcome := Exit_Square_Reached
        ELSIF ((robotXPosition |-> robotYPosition - 1) : internal_maze_walls) THEN
            movementOutcome := Maze_Wall_Crash
        ELSIF ((robotXPosition |-> robotYPosition - 1)  /: maze) THEN
            movementOutcome := Exceeding_Maze_Boundary
        ELSE 
            squaresVisited := (squaresVisited <- (robotXPosition |-> robotYPosition - 1 )) ||
            currentPosition := (robotXPosition |-> robotYPosition - 1 ) ||
            previousPosition := (robotXPosition |-> robotYPosition) ||
            robotYPosition := robotYPosition - 1 ||
            movementOutcome := Moved_South
        END
    END;
    
    //operation which moves the robot to the east
    movementOutcome <-- moveEast =
    PRE movementOutcome : MOVEMENT_OUTCOMES
    THEN
        IF (currentPosition : exit_square) THEN
            movementOutcome := Exit_Square_Reached
        ELSIF ((robotXPosition + 1 |-> robotYPosition) : internal_maze_walls) THEN
            movementOutcome := Maze_Wall_Crash
        ELSIF ((robotXPosition + 1 |-> robotYPosition)  /: maze) THEN
            movementOutcome := Exceeding_Maze_Boundary
        ELSE   
            squaresVisited := (squaresVisited <-  (robotXPosition + 1  |-> robotYPosition)) ||
            currentPosition := (robotXPosition + 1  |-> robotYPosition) ||
            previousPosition := (robotXPosition |-> robotYPosition) ||
            robotXPosition := robotXPosition + 1 ||
            movementOutcome := Moved_East
        END
    END;
    
    //operation which moves the robot to the west
    movementOutcome <-- moveWest =
    PRE movementOutcome : MOVEMENT_OUTCOMES
    THEN
        IF (currentPosition : exit_square) THEN
            movementOutcome := Exit_Square_Reached
        ELSIF ((robotXPosition - 1 |-> robotYPosition) : internal_maze_walls) THEN
            movementOutcome := Maze_Wall_Crash
        ELSIF ((robotXPosition - 1 |-> robotYPosition)  /: maze) THEN
            movementOutcome := Exceeding_Maze_Boundary
        ELSE 
            squaresVisited := (squaresVisited <- (robotXPosition - 1 |-> robotYPosition)) ||
            currentPosition := (robotXPosition - 1 |-> robotYPosition) ||
            previousPosition := (robotXPosition |-> robotYPosition) ||
            robotXPosition := robotXPosition - 1 ||
            movementOutcome := Moved_West
        END
    END;
    
    //operation which teleports the robot to a square which is not an internal wall and which is not out of boundary
    movementOutcome <-- teleport(toRobotXPosition, toRobotYPosition) =
    PRE movementOutcome : MOVEMENT_OUTCOMES & toRobotXPosition : NATURAL1 & toRobotYPosition : NATURAL1
    THEN
        IF (currentPosition : exit_square) THEN
            movementOutcome := Exit_Square_Reached
        ELSIF ((toRobotXPosition |-> toRobotYPosition) : internal_maze_walls) THEN
            movementOutcome := Maze_Wall_Crash
        ELSIF ((toRobotXPosition |-> toRobotYPosition)  /: maze) THEN
            movementOutcome := Exceeding_Maze_Boundary
        ELSIF ((toRobotXPosition |-> toRobotYPosition)  = currentPosition) THEN
            movementOutcome := Cannot_Teleport_To_The_Same_Square
        ELSE 
            squaresVisited := (squaresVisited <- (toRobotXPosition |-> toRobotYPosition)) ||
            currentPosition := (toRobotXPosition |-> toRobotYPosition) ||
            previousPosition := (robotXPosition |-> robotYPosition) ||
            robotXPosition := toRobotXPosition ||
            robotYPosition := toRobotYPosition ||
            movementOutcome := Teleported
        END
    END;
    
    //operation which returns the robots position
    robotsPosition <-- getPosition = 
    BEGIN
        robotsPosition := currentPosition
    END;
    
    //operation which returns whether the robot is on the exit square or not
    exitFound <-- foundExit =
    PRE exitFound : INTERJECTIONS
    THEN
        IF (currentPosition : exit_square) THEN
            exitFound := Yes
        ELSE
            exitFound := No
        END
    END;
    
    //operation which returns whether the square was already previously visited or not, does not take in consideration the actual move but only previous moves
    wasSquareVisited <-- hasVisitedSquare(robotCurrentPosition) =
    PRE
        wasSquareVisited : INTERJECTIONS & robotCurrentPosition : maze
    THEN
        IF(robotCurrentPosition : ran(front(squaresVisited))) THEN
            wasSquareVisited := Yes
        ELSE
            wasSquareVisited := No
        END
    END;
    
    //operation which return the ordered robots route
    orderedRoute <-- robotsRoute =
    BEGIN
        //squaresVisited is the sequence which has the squares visited
        orderedRoute := squaresVisited
    END;
    
    //operation which reinitialises the whole system
    resetText <-- reset =
    PRE resetText : OTHER_TEXTS
    THEN
        //Resetting all the variables to the initialised values
        robotXPosition, robotYPosition := 1, 1 ||
        currentPosition, previousPosition, squaresVisited := ( 1 |-> 1 ), ( 1 |-> 1 ), [( 1 |-> 1 )] ||
        resetText := System_Reinitialised
    END;
    
    //operation which reverts the last move 
    movementOutcome <-- revertMove =
    PRE movementOutcome : MOVEMENT_OUTCOMES
    THEN
        //Disabling revert move as exit square is already reached
        IF (currentPosition : exit_square) THEN
            movementOutcome := Exit_Square_Reached
            //Disabling revert move as you cannot revert without doing any moves
        ELSIF (currentPosition : entrance_square) THEN
            movementOutcome := Cannot_Revert_Move
            //Disabling revert move as reset can be used instead
        ELSIF (previousPosition : entrance_square) THEN
            movementOutcome := Cannot_Revert_Move
        ELSE 
            // sequence is reversed to drop the first element of the sequence and then is reversed again to make it return to the normal state
            squaresVisited := rev(rev(squaresVisited) \|/ 1)||
            currentPosition := previousPosition ||
            //getting the x axis value from the before the last square visited and setting it to the robots X position
            robotXPosition := last(ran(front(rev(rev(squaresVisited) \|/ 1)))) || 
            //getting the y axis value from the before the last square visited and setting it to the robots Y position
            robotYPosition := last(ran(tail(rev(rev(squaresVisited) \|/ 1)))) ||
            movementOutcome := Move_Reverted
        END
    END
END