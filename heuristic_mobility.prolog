heuristic_mobility(Board, Player, Opponent, Turn, Score) :-
    mobility(Board, Opponent, ScoreO),
    Score is (14 - ScoreO) / 14.

mobility(Board, Player, 0).
mobility(Board, Player, NbMoves) :-
    playablePositions(Board, Player, _),
    bagof(X, playablePositions(Board, Player, X), PlayablePositions),
    length(PlayablePositions, NbMoves),
    !.
