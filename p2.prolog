tete(X,[X|_]).

element(_,[],[]).
element(Obj,[Obj|List],Nlist):-element(Obj,List,Nlist),tete(X,Nlist),Obj\==X.
element(Obj,[X|List],[X|Nlist]):-element(Obj,List,Nlist),Obj\==X.

append([],L1,L1).
append([X|L1],L2,[X|L3]):-append(L1,L2,L3).

inv([],[]).
inv([X|L],R):-append(Z,[X],R),inv(L,Z),!.

composante(1,X,[X|_]).
composante(I,X,[_|L]):-composante(J,X,L),I is J+1.

list2ens([],[]).