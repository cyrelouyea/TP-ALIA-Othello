:- include('heuristic_b1.prolog').
:- include('mobility.prolog').

heuristic_nbPawns(Board, Player, Opponent, Turn, Score) :-
    % heuristic
    nbPawnPlayer(Board, Player, ScoreP),
    nbPawnPlayer(Board, Opponent, ScoreO),
    Score is (ScoreP - ScoreO) / 64.

heuristic(Board, Player, Opponent, Turn, Score) :-

    ponderation(Player, A, B, C),
    (A > 0 -> heuristic_nbPawns(Board, Player, Opponent, Turn, ScoreA); ScoreA is 0),
    (B > 0 -> heuristic_mobility(Board, Player, Opponent, Turn, ScoreB); ScoreB is 0),
    (C > 0 -> heuristic_b1(Board, Player, Opponent, Turn, ScoreC); ScoreC is 0),
    Score is A * ScoreA + B * ScoreB + C * ScoreC.


