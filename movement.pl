/*RULES*/

getTopLeft(X,Y):- petaSize(Z),X is ((12-Z)//2)+1,Y is ((12-Z)//2)+1.
getBottomRight(X,Y):- petaSize(Z),getTopLeft(PosX,PosY),X is PosX+Z-1,Y is PosY+Z-1. 
isInside(X,Y) :- getTopLeft(PosXA,PosYA),getBottomRight(PosXB,PosYB),
                 X >= PosXA,Y >= PosYA, X =< PosXB, Y =< PosYB,!.

canMove(Direction) :- Direction == n, locX(X), locY(Y), isInside(X,Y-1).
canMove(Direction) :- Direction == e, locX(X), locY(Y), isInside(X+1,Y).
canMove(Direction) :- Direction == s, locX(X), locY(Y), isInside(X,Y+1).
canMove(Direction) :- Direction == w, locX(X), locY(Y), isInside(X-1,Y).                      



/*Pemain dapat take : weapon / helmet / armor / medicine / magazine */

/*
canTake(X) :- maxInventori(Y), Y<10, weapon(X), look(X).
canTake(X) :- maxInventori(Y), Y<10, armor(X), look(X).
canTake(X) :- maxInventori(Y), Y<10, medicine(X), look(X).
canTake(X) :- maxInventori(Y), Y<10, magazine(X,Y), look(X).

canDrop(X) :- using(X), inventory(X).

canUse(X) :- inventory(X), weapon(X).

canAttack() :- */