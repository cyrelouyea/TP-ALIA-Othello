:- include('heuristic_valuation.prolog').
:- include('heuristic_nb_pawns.prolog').
:- include('heuristic_mobility.prolog').

heuristic(Board, Player, Opponent, Turn, Score) :-
    ponderation(Player, A, B, C),
    (A > 0 -> heuristic_nb_pawns(Board, Player, Opponent, Turn, ScoreA); ScoreA is 0),
    (B > 0 -> heuristic_mobility(Board, Player, Opponent, Turn, ScoreB); ScoreB is 0),
    (C > 0 -> heuristic_valuation(Board, Player, Opponent, Turn, ScoreC); ScoreC is 0),
    Score is A * ScoreA + B * ScoreB + C * ScoreC.


