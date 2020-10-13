heuristic(Board, Player, Opponent, Turn, Score) :-
    Value = [
        10, -10, 5, 1, 1, 5, -10, 10,
        -10, -10, 1, 1, 1, 1, -10, -10, 
        5, 1, 3, 1, 1, 3, 1, 5,
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1,
        5, 1, 3, 1, 1, 3, 1, 5,
        -10, -10, 1, 1, 1, 1, -10, -10, 
        10, -10, 5, 1, 1, 5, -10, 10
    ],

    get_score(Board, Value, Player, Opponent, PScore),
    get_score(Board, Value, Opponent, Player, OScore),
    Score is PScore - OScore.


get_score([HB|Board], [HV|Value], Player, Opponent, Score) :-
    Player == HB,
    nonvar(HB),
    get_score(Board, Value, Player, Opponent, NScore),
    Score is NScore + HV,
    !.

get_score([HB|Board], [HV|Value], Player, Opponent, Score) :-
    Opponent == HB,
    nonvar(HB),
    get_score(Board, Value, Player, Opponent, NScore),
    Score is NScore - HV,
    !.

get_score([], [], Player, Opponent, Score) :-
    Score is 0.

get_score([HB|Board], [HV|Value], Player, Opponent, Score) :-
    var(HB),
    get_score(Board, Value, Player, Opponent, Score).