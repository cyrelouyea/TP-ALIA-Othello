% Random strategy
findMove(Board, 'x', Move) :-
    findMove_o(Board, 'x', Move).

findMove_o(Board, _, Move) :-
    length(Board, Length),
    Move is random(Length).
