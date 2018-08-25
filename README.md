# Summary

## The Game

#### Initial Setup ####
A two-player board game called “War of Life” which will be played on an 8x8 board. Player 1 will start with a random configuration of 12 blue pieces and player 2 will start with a similar random configuration of 12 red pieces (please view the pictures uploaded in this repo to visualise a potential initial random configuration).

#### Movements ####
We call the board places where pieces can be placed cells (there are 64 cells on an 8x8 board). In the game, player 1 goes first and moves one of his/her pieces. A piece can be moved to one of its neighbour cells (vertically, horizontally or diagonally) as long as no other piece is occupying the cell to be moved to. So, for example, the blue piece at (3, 8) can move to (2,7), (2,8) or (4,7) or (4,8), but not (3,7) because there is a red piece there already. We say that a piece is surrounded by the pieces in neighbouring cells.

#### The Twist ####
There is a twist: after each player moves, “life” on the board “evolves” according to the following rules (referred to as
Conway’s Crank) for each of the 64 cells on the board:
* If C contains a piece and the piece is surrounded by 0 or 1 other pieces, then the piece dies of loneliness and is taken away (i.e., the cell becomes empty).
* If C contains a piece and the piece is surrounded by 4, 5, 6, 7 or 8 pieces, then the piece dies of overcrowding and is taken away.
* (If C contains a piece and the piece is surrounded by 2 or 3 pieces, then it is happy and survives.)
* If C is empty and C is surrounded by
    - 2 blue pieces and 1 red piece, or
    - 3 blue pieces, then a blue life is born and C is filled with a blue piece.
* If C is empty and C is surrounded by
    - 2 red pieces and 1 blue piece, or
    - 3 red pieces, then a red life is born and C is filled with a red piece.

#### Termination ####
The game terminates as follows:
* If at some stage no (red or blue) pieces at all are left on the board, then the game is drawn.
* If, when it is his/her turn, a player cannot move anywhere, then the game is declared a stalemate and is drawn.
* If one player has no pieces left on the board, then that player loses and the other player wins.
* If the game lasts for 250 moves without a winner, then it is declared an exhausted draw.

## The Strategies

#### Bloodlust ####
This strategy chooses the next move for a player to be the one which (after Conway’s crank) produces the board state with the fewest number of opponent’s pieces on the board (ignoring the player’s own pieces).

#### Self Preservation ####
This strategy chooses the next move for a player to be the one which (after Conway’s crank) produces the board state with the largest number of that player’s pieces on the board (ignoring the opponent’s pieces).

#### Land Grab ####
This strategy chooses the next move for a player to be the one which (after Conway’s crank) produces the board state which maximises this function: Number of Player’s pieces – Number of Opponent’s pieces.

#### Minimax ####
This strategy looks two-ply ahead using the heuristic measure described in the Land Grab strategy. It should follow the minimax principle and take into account the opponent’s move after the one being chosen for the current player.
