% Random strategy
findMove(Board, 'o', Move) :-
    findMove_o(Board, 'o', 'x' Move).

findMove_o(Board, Player, Opponent, Move) :-
    minimax(Board, 4, Player, Opponent, Player, Move).

minimax(Board, 0, Player, Opponent, Turn, Score, _) :-
    heuristic(Board, Player, Opponent, Turn, Score),
    !.
minimax(Board, Depth, Player, Opponent, Turn, Score, Move) :-
    Turn == Player,
    CurrentScore is -inf,
    minimax(Board, )
    Score is max(CurrentScore, ) 
