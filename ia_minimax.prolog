
findMove(Board, 'o', Move) :-
    findMove_o(Board, 'o', 'x', Move).

findMove_o(Board, Player, Opponent, Move) :-
    minimax(Board, 4, Player, Opponent, Player, Score, Move),
    write('Score: '), write(Score), writeln(''),
    write('Move: '), write(Move), writeln('').

heuristic(Board, Player, Opponent, Turn, Score) :-
    nbPawnPlayer(Board, Player, ScoreP),
    nbPawnPlayer(Board, Opponent, ScoreO),
    Score is ScoreP - ScoreO.

minimax(Board, 0, Player, Opponent, Turn, Score, _) :-
    heuristic(Board, Player, Opponent, Turn, Score),
    !.
minimax(Board, _, _, Opponent, _, Score, _) :-
    winner(Board, Opponent),
    Score is -inf,
    !.
minimax(Board, _, Player, _, _, Score, _) :-
    winner(Board, Player),
    Score is inf,
    !.
minimax(Board, _, _, _, _, Score, _) :-
    isFinished(Board),
    Score is 0,
    !.
minimax(Board, Depth, Player, Opponent, Turn, Score, Move) :-
    Turn == Player,
    bagof(X, playablePositions(Board, Player, X), PlayablePositions),
    maxScoreChild(Board, PlayablePositions, Depth, Player, Opponent, Turn, Score, Move),
    !.
minimax(Board, Depth, Player, Opponent, Turn, Score, Move) :-
    Turn == Opponent,
    bagof(X, playablePositions(Board, Opponent, X), PlayablePositions),
    minScoreChild(Board, PlayablePositions, Depth, Player, Opponent, Turn, Score, Move),
    !.
minimax(Board, Depth, Player, Opponent, Turn, Score, Move) :-
    changePlayer(Turn, NewTurn),
    minimax(Board, Depth, Player, Opponent, NewTurn, Score, Move),
    !.

maxScoreChild(Board, [Move], Depth, Player, Opponent, Turn, Score, Move) :-
    playMove(Board, NewBoard, Turn, Move),
    NewDepth is Depth - 1,
    changePlayer(Turn, NewTurn),
    minimax(NewBoard, NewDepth, Player, Opponent, NewTurn, Score, _),
    !.
maxScoreChild(Board, [H|PlayablePositions], Depth, Player, Opponent, Turn, Score, Move) :-
    playMove(Board, NewBoard, Turn, H),
    NewDepth is Depth - 1,
    changePlayer(Turn, NewTurn),
    minimax(NewBoard, NewDepth, Player, Opponent, NewTurn, ChildScore, _),
    maxScoreChild(Board, PlayablePositions, Depth, Player, Opponent, Turn, ChildrenScore, ChildrenMove),
    maxWithPosition(ChildScore, H, ChildrenScore, ChildrenMove, Score, Move).

minScoreChild(Board, [Move], Depth, Player, Opponent, Turn, Score, Move) :-
    playMove(Board, NewBoard, Turn, Move),
    NewDepth is Depth - 1,
    changePlayer(Turn, NewTurn),
    minimax(NewBoard, NewDepth, Player, Opponent, NewTurn, Score, _),
    !.
minScoreChild(Board, [H|PlayablePositions], Depth, Player, Opponent, Turn, Score, Move) :-
    playMove(Board, NewBoard, Turn, H),
    NewDepth is Depth - 1,
    changePlayer(Turn, NewTurn),
    minimax(NewBoard, NewDepth, Player, Opponent, NewTurn, ChildScore, _),
    minScoreChild(Board, PlayablePositions, Depth, Player, Opponent, Turn, ChildrenScore, ChildrenMove),
    minWithPosition(ChildScore, H, ChildrenScore, ChildrenMove, Score, Move).



minWithPosition(A, PosA, B, _, Min, PosMin) :-
    A < B,
    Min is A,
    PosMin is PosA.
minWithPosition(A, _, B, PosB, Min, PosMin) :-
    A > B,
    Min is B,
    PosMin is PosB.
minWithPosition(A, PosA, B, PosB, Min, PosMin) :-
    A == B,
    randomBetweenTwo(A, PosA, B, PosB, Min, PosMin).

maxWithPosition(A, PosA, B, _, Max, PosMax) :-
    A > B,
    Max is A,
    PosMax is PosA.
maxWithPosition(A, _, B, PosB, Max, PosMax) :-
    A < B,
    Max is B,
    PosMax is PosB.
maxWithPosition(A, PosA, B, PosB, Min, PosMin) :-
    A == B,
    randomBetweenTwo(A, PosA, B, PosB, Min, PosMin).


randomBetweenTwo(A, PosA, _, _, V, PosV) :-
    I is random(2),
    I == 0,
    V is A,
    PosV is PosA,
    !.
randomBetweenTwo(_, _, B, PosB, V, PosV) :-
    V is B,
    PosV is PosB,
    !.