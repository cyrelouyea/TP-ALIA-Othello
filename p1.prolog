homme(aleryc).
homme(tyefen).
homme(kylian).
homme(michel).
homme(andre).
homme(antonio).
homme(tony).
femme(nadine).
femme(santa).
parent(michel,aleryc).
parent(michel,tyefen).
parent(michel,kylian).
parent(nadine,aleryc).
parent(nadine,tyefen).
parent(nadine,kylian).
parent(andre,nadine).
parent(antonio,michel).
parent(santa,michel).
parent(antonio,tony).
parent(santa,tony).

% X est le père de Y
pere(X,Y):-parent(X,Y),homme(X).
% X est la mère de Y.
mere(X,Y):-parent(X,Y),femme(X).


% X est l'enfant de Y
enfant(X,Y):-parent(Y,X).
% X est le fils de Y
fils(X,Y):-enfant(X,Y),homme(X).
% X est la fille de Y
fille(X,Y):-enfant(X,Y),femme(X).

% X est le frère ou la soeur de Y
frere_ou_soeur(X,Y):-parent(Z,X),parent(Z,Y),X\==Y.
% X est le frere de Y
frere(X,Y):-frere_ou_soeur(X,Y),homme(X).
% X est la soeur de Y
soeur(X,Y):-frere_ou_soeur(X,Y),femme(X).

% X est l'oncle ou la tante de Y
oncle_ou_tante(X,Y):-parent(Z,Y),frere_ou_soeur(Z,X).
% X est l'oncle de Y
oncle(X,Y):-oncle_ou_tante(X,Y),homme(X).
% X est la tante  de Y
tante(X,Y):-oncle_ou_tante(X,Y),femme(X).

% X est le grand-parent de Y
grand_parent(X,Y):-parent(X,Z),parent(Z,Y).
% X est le grand-père de Y
grand_pere(X,Y):-grand_parent(X,Y),homme(X).
% X est la grand-mère de Y
grand_mere(X,Y):-grand_parent(X,Y),femme(X).


% X est un ascendant de Y
ascendant(X,Y):-parent(X,Y).
ascendant(X,Y):-parent(X,Z),ascendant(Z,Y).

% X est un descendant de Y
descendant(X,Y):-enfant(X,Y).
descendant(X,Y):-enfant(X,Z),descendant(Z,Y).