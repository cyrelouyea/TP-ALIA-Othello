% Random strategy
% 
% findMove(Board, _, Move) :-
%     length(Board, Length),
%     Move is random(Length).


% The greatest number of captures possible
%
findMove(Board, Player, Move) :-
    bagof(X, playablePositions(Board, Player, X), L),
    findMaxPoint(Board, Player, L, Move, NbPoint),
    writeln(NbPoint).

findMaxPoint(Board, Player, [H], H, NbPoint) :-
    replaceInThePosition(Board, H, Player, NewBoard),
    nbPawnPlayer(NewBoard, Player, NbPoint).

findMaxPoint(Board, Player, [H|T], Move, NbPoint) :-
    replaceInThePosition(Board, H, Player, NewBoard),
    nbPawnPlayer(NewBoard, Player, NbPawn),
    findMaxPoint(Board, Player, T, Move, NbPawnMax),
    NbPoint is max(NbPawn, NbPawnMax).