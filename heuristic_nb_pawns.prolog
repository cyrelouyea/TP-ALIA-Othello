heuristic_nb_pawns(Board, Player, Opponent, Turn, Score) :-
    % heuristic
    nbPawnPlayer(Board, Player, ScoreP),
    nbPawnPlayer(Board, Opponent, ScoreO),
    Score is (ScoreP - ScoreO) / 64.