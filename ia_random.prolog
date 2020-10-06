% Random strategy
findMove(Board, 'o', Move) :-
    findMove_o(Board, 'o', Move).

findMove_o(Board, _, Move) :-
    length(Board, Length),
    Move is random(Length).
