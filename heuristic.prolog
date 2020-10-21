:- include('heuristic_b1.prolog').
:- include('mobility.prolog').

heuristic_nbPawns(Board, Player, Opponent, Turn, Score) :-
    % heuristic
    nbPawnPlayer(Board, Player, ScoreP),
    nbPawnPlayer(Board, Opponent, ScoreO),
    Score is (ScoreP - ScoreO) / 64.

heuristic(Board, Player, Opponent, Turn, Score) :-

    ponderation(Player, A, B, C),
    heuristic_nbPawns(Board, Player, Opponent, Turn, ScoreA),
    heuristic_mobility(Board, Player, Opponent, Turn, ScoreB),
    heuristic_b1(Board, Player, Opponent, Turn, ScoreC),
    Score is A * ScoreA + B * ScoreB + C * ScoreC.


