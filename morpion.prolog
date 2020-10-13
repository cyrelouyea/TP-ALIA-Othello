:- dynamic board/1.

gameover(Winner):-board(Board),winner(Board, Winner),!.
gameover('Draw'):-board(Board),isBoardFull(Board).

winner(Board, P):-Board=[P,Q,R,_,_,_,_,_,_], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[_,_,_,P,Q,R,_,_,_], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[_,_,_,_,_,_,P,Q,R], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[P,_,_,Q,_,_,R,_,_], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[_,P,_,_,Q,_,_,R,_], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[_,_,P,_,_,Q,_,_,R], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[P,_,_,_,Q,_,_,_,R], P==Q, Q==R, nonvar(P).
winner(Board, P):-Board=[_,_,P,_,Q,_,R,_,_], P==Q, Q==R, nonvar(P).

isBoardFull([]).
isBoardFull([H|T]):-nonvar(H), isBoardFull(T).

ia(Board, Index, _):-repeat, Index is random(9), nth0(Index, Board, Elem), var(Elem), !.

play(_):-gameover(Winner),!,write('Game is Over. Winner: '), writeln(Winner), displayBoard.
play(Player):-
    write('New turn for:'), writeln(Player),
    board(Board),
    displayBoard,
    ia(Board, Move, Player),
    playMove(Board, Move, NewBoard, Player),
    applyIt(Board, NewBoard),
    changePlayer(Player, NextPlayer),
    play(NextPlayer).

playMove(Board, Move, NewBoard, Player):-Board=NewBoard, nth0(Move,NewBoard,Player).

applyIt(Board, NewBoard):-retract(board(Board)),assert(board(NewBoard)).

changePlayer('x', 'o').
changePlayer('o', 'x').

printVal(N):-board(B), nth0(N,B,Val), var(Val), write('?'), !.
printVal(N):-board(B), nth0(N,B,Val), write(Val), !.

displayBoard:-
    writeln('*---------*'),
    printVal(0), printVal(1), printVal(2), writeln(''),
    printVal(3), printVal(4), printVal(5), writeln(''),
    printVal(6), printVal(7), printVal(8), writeln(''),
    writeln('*---------*').

init:- length(Board,9), assert(board(Board)), play('x').