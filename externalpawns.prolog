heuristic(Board, Player, Opponent, Turn, Score) :-
    heuristic_mobility(Board, Opponent, NbMoves),
    Score is (14 - ScoreO) / 28.

heuristic_externalpawns(Board, Player, NbMoves) :-
    playablePositions(Board, Player, _),
    bagof(X, playablePositions(Board, Player, X), PlayablePositions),
    length(PlayablePositions, NbMoves),
    !.
heuristic_externalpawns(Board, Player, 0).