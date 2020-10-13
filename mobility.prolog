heuristic(Board, Player, Opponent, Turn, Score) :-
    heuristic_mobility(Board, Opponent, NbMoves),
    Score is 64 - ScoreO.

heuristic_mobility(Board, Player, NbMoves) :-
    playablePositions(Board, Player, _),
    bagof(X, playablePositions(Board, Player, X), PlayablePositions),
    length(PlayablePositions, NbMoves),
    !.
heuristic_mobility(Board, Player, 0).