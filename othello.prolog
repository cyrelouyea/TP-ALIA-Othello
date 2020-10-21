:- include('heuristic.prolog').
:- include('ia_minimax.prolog').
:- include('ia_random.prolog').

:- dynamic board/1.
:- dynamic ponderation/4.
:- dynamic depth/2.
:- dynamic showTrace/1.

gameover(Board, Winner) :-
    winner(Board, Winner), 
    !.
gameover(Board, 'Draw') :-
    isFinished(Board).

winner(Board, 'x') :- 
    isFinished(Board),
    nbPawnPlayer(Board, 'x', NbPawnX),
    nbPawnPlayer(Board, 'o', NbPawnO),
    NbPawnX > NbPawnO,
    !.
winner(Board, 'o') :- 
    isFinished(Board),
    nbPawnPlayer(Board, 'x', NbPawnX),
    nbPawnPlayer(Board, 'o', NbPawnO),
    NbPawnO > NbPawnX,
    !.

isFinished(Board) :-
    not(playablePositions(Board, 'x', _)),
    not(playablePositions(Board, 'o', _)).

playablePositions(Board, Player, X) :-
    playablePositions(Board, Board, Player, 0, X).
playablePositions(Board, [H|_], Player, N, X) :-
    var(H),
    isPositionPlayable(Board, Player, N),
    X is N.
playablePositions(Board, [_|T], Player, N, X) :-
    N1 is N + 1,
    playablePositions(Board, T, Player, N1, X).

isPositionPlayable(Board, Player, N) :-
    N1 is N - 8,
    capturePawn(Board, BoardT, Player, N1),
    findPlayerTop(BoardT, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N - 7,
    mod(N1, 8) > mod(N, 8),
    capturePawn(Board, BoardTR, Player, N1),
    findPlayerTopRight(BoardTR, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N + 1,
    mod(N1, 8) > mod(N, 8),
    capturePawn(Board, BoardR, Player, N1),
    findPlayerRight(BoardR, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N + 9,
    mod(N1, 8) > mod(N, 8),
    capturePawn(Board, BoardBR, Player, N1),
    findPlayerBottomRight(BoardBR, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N + 8,
    capturePawn(Board, BoardR, Player, N1),
    findPlayerBottom(BoardR, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N + 7,
    mod(N1, 8) < mod(N, 8),
    capturePawn(Board, BoardBL, Player, N1),
    findPlayerBottomLeft(BoardBL, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N - 1,
    mod(N1, 8) < mod(N, 8),
    capturePawn(Board, BoardL, Player, N1),
    findPlayerLeft(BoardL, _, Player, N1),
    !.
isPositionPlayable(Board, Player, N) :-
    N1 is N - 9,
    mod(N1, 8) < mod(N, 8),
    capturePawn(Board, BoardTL, Player, N1),
    findPlayerTopLeft(BoardTL, _, Player, N1),
    !.


nbPawnPlayer([], _, 0).
nbPawnPlayer([H|T], Player, NbPawn) :-
    nonvar(H),
    H == Player,
    nbPawnPlayer(T, Player, NbPawnPrev),
    NbPawn is NbPawnPrev + 1,
    !.
nbPawnPlayer([_|T], Player, NbPawn) :-
    nbPawnPlayer(T, Player, NbPawn),
    !.

printVal(Board, N) :- 
    nth0(N, Board, Val), 
    var(Val), 
    write('?'), 
    !.

printVal(Board, N):-
    nth0(N, Board, Val), 
    write(Val), 
    !.

displayBoard(Board) :-
    writeln('*--------------*'),
    printVal(Board, 0), printVal(Board, 1), printVal(Board, 2), printVal(Board, 3), printVal(Board, 4), printVal(Board, 5), printVal(Board, 6), printVal(Board, 7), writeln(''),
    printVal(Board, 8), printVal(Board, 9), printVal(Board, 10), printVal(Board, 11), printVal(Board, 12), printVal(Board, 13), printVal(Board, 14), printVal(Board, 15), writeln(''),
    printVal(Board, 16), printVal(Board, 17), printVal(Board, 18), printVal(Board, 19), printVal(Board, 20), printVal(Board, 21), printVal(Board, 22), printVal(Board, 23), writeln(''),
    printVal(Board, 24), printVal(Board, 25), printVal(Board, 26), printVal(Board, 27), printVal(Board, 28), printVal(Board, 29), printVal(Board, 30), printVal(Board, 31), writeln(''),
    printVal(Board, 32), printVal(Board, 33), printVal(Board, 34), printVal(Board, 35), printVal(Board, 36), printVal(Board, 37), printVal(Board, 38), printVal(Board, 39), writeln(''),
    printVal(Board, 40), printVal(Board, 41), printVal(Board, 42), printVal(Board, 43), printVal(Board, 44), printVal(Board, 45), printVal(Board, 46), printVal(Board, 47), writeln(''),
    printVal(Board, 48), printVal(Board, 49), printVal(Board, 50), printVal(Board, 51), printVal(Board, 52), printVal(Board, 53), printVal(Board, 54), printVal(Board, 55), writeln(''),
    printVal(Board, 56), printVal(Board, 57), printVal(Board, 58), printVal(Board, 59), printVal(Board, 60), printVal(Board, 61), printVal(Board, 62), printVal(Board, 63), writeln(''),
    writeln('*--------------*').

playMove(Board, NewBoard, Player, N) :-
    copy_term(Board, NewBoardWithoutCapture),
    nth0(N, NewBoardWithoutCapture, Player),
    applyCapture(NewBoardWithoutCapture, NewBoard, Player, N),
    !.

applyCapture(Board, NewBoard, Player, N) :-
    captureTop(Board, BoardT, Player, N),
    captureTopRight(BoardT, BoardTR, Player, N),
    captureRight(BoardTR, BoardR, Player, N),
    captureBottomRight(BoardR, BoardBR, Player, N),
    captureBottom(BoardBR, BoardB, Player, N),
    captureBottomLeft(BoardB, BoardBL, Player, N),
    captureLeft(BoardBL, BoardL, Player, N),
    captureTopLeft(BoardL, NewBoard, Player, N),
    !.

% TOP
captureTop(Board, NewBoard, Player, N) :-
    findPlayerTop(Board, NewBoard, Player, N),
    !.
captureTop(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerTop(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N - 8,
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerTop(Board, NewBoard, Player, N) :-
    N1 is N - 8,
    capturePawn(Board, BoardT, Player, N1),
    findPlayerTop(BoardT, NewBoard, Player, N1),
    !.

% TOP-RIGHT
captureTopRight(Board, NewBoard, Player, N) :-
    findPlayerTopRight(Board, NewBoard, Player, N),
    !.
captureTopRight(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerTopRight(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N - 7,
    mod(N1, 8) > mod(N, 8),
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerTopRight(Board, NewBoard, Player, N) :-
    N1 is N - 7,
    mod(N1, 8) > mod(N, 8),
    capturePawn(Board, BoardTR, Player, N1),
    findPlayerTopRight(BoardTR, NewBoard, Player, N1),
    !.

% RIGHT
captureRight(Board, NewBoard, Player, N) :-
    findPlayerRight(Board, NewBoard, Player, N),
    !.
captureRight(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerRight(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N + 1,
    mod(N1, 8) > mod(N, 8),
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerRight(Board, NewBoard, Player, N) :-
    N1 is N + 1,
    mod(N1, 8) > mod(N, 8),
    capturePawn(Board, BoardR, Player, N1),
    findPlayerRight(BoardR, NewBoard, Player, N1),
    !.

% BOTTOM-RIGHT
captureBottomRight(Board, NewBoard, Player, N) :-
    findPlayerBottomRight(Board, NewBoard, Player, N),
    !.
captureBottomRight(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerBottomRight(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N + 9,
    mod(N1, 8) > mod(N, 8),
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerBottomRight(Board, NewBoard, Player, N) :-
    N1 is N + 9,
    mod(N1, 8) > mod(N, 8),
    capturePawn(Board, BoardBR, Player, N1),
    findPlayerBottomRight(BoardBR, NewBoard, Player, N1),
    !.

% BOTTOM
captureBottom(Board, NewBoard, Player, N) :-
    findPlayerBottom(Board, NewBoard, Player, N),
    !.
captureBottom(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerBottom(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N + 8,
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerBottom(Board, NewBoard, Player, N) :-
    N1 is N + 8,
    capturePawn(Board, BoardR, Player, N1),
    findPlayerBottom(BoardR, NewBoard, Player, N1),
    !.

% BOTTOM-LEFT
captureBottomLeft(Board, NewBoard, Player, N) :-
    findPlayerBottomLeft(Board, NewBoard, Player, N),
    !.
captureBottomLeft(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerBottomLeft(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N + 7,
    mod(N1, 8) < mod(N, 8),
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerBottomLeft(Board, NewBoard, Player, N) :-
    N1 is N + 7,
    mod(N1, 8) < mod(N, 8),
    capturePawn(Board, BoardBL, Player, N1),
    findPlayerBottomLeft(BoardBL, NewBoard, Player, N1),
    !.

% LEFT
captureLeft(Board, NewBoard, Player, N) :-
    findPlayerLeft(Board, NewBoard, Player, N),
    !.
captureLeft(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerLeft(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N - 1,
    mod(N1, 8) < mod(N, 8),
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerLeft(Board, NewBoard, Player, N) :-
    N1 is N - 1,
    mod(N1, 8) < mod(N, 8),
    capturePawn(Board, BoardL, Player, N1),
    findPlayerLeft(BoardL, NewBoard, Player, N1),
    !.

% TOP-LEFT
captureTopLeft(Board, NewBoard, Player, N) :-
    findPlayerTopLeft(Board, NewBoard, Player, N),
    !.
captureTopLeft(Board, NewBoard, _, _) :-
    Board = NewBoard,
    !.
findPlayerTopLeft(Board, NewBoard, Player, N) :-
    Board = NewBoard,
    N1 is N - 9,
    mod(N1, 8) < mod(N, 8),
    nth0(N1, Board, PlayerN1),
    nonvar(PlayerN1),
    PlayerN1 == Player,
    !.
findPlayerTopLeft(Board, NewBoard, Player, N) :-
    N1 is N - 9,
    mod(N1, 8) < mod(N, 8),
    capturePawn(Board, BoardTL, Player, N1),
    findPlayerTopLeft(BoardTL, NewBoard, Player, N1),
    !.

% CAPTURE PAWN
% fail if element at position N is var (e.g. there is no pawn)
capturePawn(Board, NewBoard, Player, N) :-
    changePlayer(Player, OtherPlayer),
    nth0(N, Board, P),
    nonvar(P),
    P == OtherPlayer,
    replaceInThePosition(Board, N, Player, NewBoard),
    !.

replaceInThePosition([_|T],0,E,[E|T]).
replaceInThePosition([H|T],P,E,[H|R]) :-
    P > 0, NP is P-1, replaceInThePosition(T,NP,E,R).

applyMove(Board, NewBoard) :-
    retract(board(Board)), 
    assert(board(NewBoard)).

changePlayer('x', 'o').
changePlayer('o', 'x').

% Check if game is over
play(_) :-
    board(Board),
    gameover(Board, Winner),
    (
        showTrace(true) ->
        (
            write('Game is Over. Winner: ')
        );  
        (
            write('Winner: ')
        )
    ),
    writeln(Winner), 
    (
        showTrace(true) ->
        (
            displayBoard(Board)
        );  
        (
            true
        )
    ),
    !.

% Player can play
play(Player) :-
    board(Board),
    playablePositions(Board, Player, _),
    (
        showTrace(true) ->
        (
            write('New turn for: '), writeln(Player),
            displayBoard(Board)
        );  
        (
            write(Player), write(' ')
        )
    ),
    get_time(StartTime),
    ia(Board, Move, Player),
    get_time(EndTime),
    Time is EndTime-StartTime, 
    (
        showTrace(true) ->
        (
            write('Time: '), writeln(Time)
        );  
        (
            writeln(Time)
        )
    ),
    playMove(Board, NewBoard, Player, Move),
    applyMove(Board, NewBoard),
    changePlayer(Player, NextPlayer),
    play(NextPlayer),
    !.

% Player can't play, change player
play(Player) :-
    changePlayer(Player, NextPlayer),
    play(NextPlayer),
    !.

ia(Board, Move, Player) :-
    repeat,
    findMove(Board, Player, Move),
    nth0(Move, Board, Elem), 
    var(Elem),
    isPositionPlayable(Board, Player, Move).


init :-
    initArgs,
    length(Board, 64), 
    nth0(27, Board, 'x'),
    nth0(28, Board, 'o'),
    nth0(35, Board, 'o'),
    nth0(36, Board, 'x'),
    assert(board(Board)),
    play('x').

initArgs :-
    current_prolog_flag(argv, Argv),
    [Player|Rest1] = Argv,
    [P1|Rest2] = Rest1,
    [P2|Rest3] = Rest2,
    [P3|Rest4] = Rest3,
    [PDepth|Rest5] = Rest4,
    [Opponent|Rest6] = Rest5,
    [O1|Rest7] = Rest6,
    [O2|Rest8] = Rest7,
    [O3|Rest9] = Rest8,
    [ODepth|Rest10] = Rest9,
    [ShowTrace] = Rest10,
    
    atom_number(P1, NP1),
    atom_number(P2, NP2),
    atom_number(P3, NP3),
    atom_number(PDepth, NPDepth),

    atom_number(O1, NO1),
    atom_number(O2, NO2),
    atom_number(O3, NO3),
    atom_number(ODepth, NODepth),

    assert(ponderation(Player, NP1, NP2, NP3)),
    assert(depth(Player, NPDepth)),
    assert(ponderation(Opponent, NO1, NO2, NO3)),
    assert(depth(Opponent, NODepth)),
    assert(showTrace(ShowTrace)).

reset :-
    board(Board),
    retract(board(Board)).