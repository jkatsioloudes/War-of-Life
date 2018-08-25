% Takes 3 inputs.  The number of games played and the strategies that the 2
% players are going to follow in all these games.
% Makes use of helper functions defined and explained below.
test_strategy(NumberOfGames, Strategy1, Strategy2):-
	length( ListOfGames, NumberOfGames),
	statistics(runtime, _),
	findall( [Winner, NumberOfMoves], (nth1(_, ListOfGames, _),
	play(quiet,Strategy1,Strategy2, NumberOfMoves, Winner)) , List),
	findall( b , member([b,_], List), List1),
	findall( r , member([r,_], List), List2),
	length( List1 , Wins1),
	length( List2 , Wins2),
	Draws is NumberOfGames - Wins1 - Wins2,
	write('The number of draws is '), write(Draws), nl,
	write('Player with blue pieces has: '),
	write(Wins1),
	write(' wins '), nl,
	write('Player with red pieces has: '),
	write(Wins2),
	write(' wins '),  nl,
	findall( Moves , member([_,Moves], List), ListMoves),
	average(ListMoves, Avg),
	min_list(ListMoves, Min),
	max_list(ListMoves, Max),
	write('Average game length: ') , write(Avg), nl ,
	write('Longest game: ') , write(Max), nl,
	write('Shortest game: ') , write(Min), nl,
	statistics(runtime,[_,Time]),
	AvgTime is Time/NumberOfGames,
	write('Average game time: ') , write(AvgTime), write(' ms').


% Not used directly above as it is created to provide clarity for the
% function calculating the average defined below.
% Acts as fold in the list, returning the summation of all elements.
fold_l([], 0).
fold_l([Head | Tail], TotalSum) :-
	fold_l(Tail, Sum1),
	TotalSum is Head + Sum1.


% Returns the average defined as Sum divided by total number of inputs.
average(List, Avg):-
	fold_l(List, Sum),
	length(List, N),
	Avg is Sum / N.


% Returns the highest element inside list of lists.
max_list([Max],Max).
max_list([H,N|T],M) :-
    	H > N,
    	max_list([H|T],M).
max_list([H,N|T],M) :-
    	H =< N,
    	max_list([N|T],M).


% Returns the lowest element inside list of lists.
min_list([Min],Min).
min_list([H,N|T],M) :-
    	H =< N,
    	min_list([H|T],M).
min_list([H,N|T],M) :-
    	H > N,
    	min_list([N|T],M).


% Implementation for the bloodlust strategy.
bloodlust('b', [AliveBlues, AliveReds], [NewAliveBlues, AliveReds], Move) :-
	  move('b', bloodlust, AliveBlues, AliveReds, Move),
	  alter_board(Move, AliveBlues, NewAliveBlues).

bloodlust('r', [AliveBlues, AliveReds], [AliveBlues, NewAliveReds], Move) :-
	  move('r', bloodlust, AliveBlues, AliveReds, Move),
	  alter_board(Move, AliveReds, NewAliveReds).


% Implementation for the self_preservation strategy.
self_preservation('b', [AliveBlues, AliveReds], [NewAliveBlues, AliveReds], Move) :-
	  move('b', self_preservation, AliveBlues, AliveReds, Move),
	  alter_board(Move, AliveBlues, NewAliveBlues).

self_preservation('r', [AliveBlues, AliveReds], [AliveBlues, NewAliveReds], Move) :-
	  move('r', self_preservation, AliveBlues, AliveReds, Move),
	  alter_board(Move, AliveReds, NewAliveReds).


% Implementation for the land_grab strategy.
land_grab('b', [AliveBlues, AliveReds], [NewAliveBlues, AliveReds], Move) :-
  	move('b', land_grab, AliveBlues, AliveReds, Move),
  	alter_board(Move, AliveBlues, NewAliveBlues).

land_grab('r', [AliveBlues, AliveReds], [AliveBlues, NewAliveReds], Move) :-
  	move('r', land_grab, AliveBlues, AliveReds, Move),
  	alter_board(Move, AliveReds, NewAliveReds).


% Implementation for the minimax strategy.
minimax('b', [AliveBlues, AliveReds], [NewAliveBlues, AliveReds], Move) :-
  	move('b', minimax, AliveBlues, AliveReds, Move),
  	alter_board(Move, AliveBlues, NewAliveBlues).

minimax('r', [AliveBlues, AliveReds], [AliveBlues, NewAliveReds], Move) :-
 	move('r', minimax, AliveBlues, AliveReds, Move),
  	alter_board(Move, AliveReds, NewAliveReds).


% Helper function used in the strategies developed above to represent
% a movement on board.
move('b', Strategy, AliveBlues, AliveReds, BestMove):-
	findall([A,B,MA,MB],
		(member([A,B], AliveBlues),
                neighbour_position(A,B,[MA,MB]),
	        \+member([MA,MB],AliveBlues),
	        \+member([MA,MB],AliveReds)),
	 	PossMoves),
	findall(Score,
		(member([A,B,MA,MB], PossMoves),
		alter_board([A,B,MA,MB], AliveBlues, NewAliveBlues),
		next_generation([NewAliveBlues,AliveReds], [Blue,Red]),
		strategy(Strategy, Blue ,Red, Score)),
	        ScoreValues),
	max_list(ScoreValues, MaxBlue),
	nth1(N,ScoreValues, MaxBlue),
	nth1(N, PossMoves, BestMove).

move('r', Strategy, AliveBlues, AliveReds, BestMove):-
	findall([A,B,MA,MB],
		(member([A,B], AliveReds),
                neighbour_position(A,B,[MA,MB]),
	        \+member([MA,MB],AliveReds),
	        \+member([MA,MB],AliveBlues)),
	 	PossMoves),
	findall(Score, (member([A,B,MA,MB], PossMoves),
	        alter_board([A,B,MA,MB], AliveReds, NewAliveReds),
	        next_generation([AliveBlues,NewAliveReds], [Blue,Red]),
		strategy(Strategy, Red ,Blue, Score)),
	        ScoreValues),
	max_list(ScoreValues, MaxRed),
	nth1(N,ScoreValues, MaxRed),
	nth1(N, PossMoves, BestMove).

strategy(bloodlust,_,Opp, Score):-
	length(Opp,L),
	Score is  -L.
strategy(self_preservation,Playing,_, Score):-
	length(Playing,Score).
strategy(land_grab,Playing,Opp, Score):-
	length(Playing,P),
	length(Opp,K),
	Score is P-K.
strategy(minimax, Player,Opp, Score) :-
	findall([A,B,MA,MB],
 	       (member([A,B], Opp),
	        neighbour_position(A,B,[MA,MB]),
		\+member([MA,MB],Player),
		\+member([MA,MB], Opp)),
	        Moves),
	findall(S,
	        (member([A,B,MA,MB], Moves),
		alter_board([A,B,MA,MB], Opp, NewOpp),
		next_generation([Player, NewOpp], [P, O]),
		strategy(land_grab,O,P,S)),
		ScoreValues),
	max_list(ScoreValues, MaxScore),
	Score is -MaxScore.