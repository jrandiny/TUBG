/*RULES*/

getTopLeft(X,Y):- petaSize(Z),X is ((12-Z)//2)+1,Y is ((12-Z)//2)+1.
getBottomRight(X,Y):- petaSize(Z),getTopLeft(PosX,PosY),X is PosX+Z-1,Y is PosY+Z-1. 
isInside(X,Y) :- getTopLeft(PosXA,PosYA),getBottomRight(PosXB,PosYB),
                 X >= PosXA,Y >= PosYA, X =< PosXB, Y =< PosYB,!.

canMove(Direction) :- Direction == n, locX(X), locY(Y), isInside(X,Y-1).
canMove(Direction) :- Direction == e, locX(X), locY(Y), isInside(X+1,Y).
canMove(Direction) :- Direction == s, locX(X), locY(Y), isInside(X,Y+1).
canMove(Direction) :- Direction == w, locX(X), locY(Y), isInside(X-1,Y).                      

/* RULES UNTUK PERGERAKAN PEMAIN */
move(e) :- canMove(e),locX(CurrX),retract(locX(CurrX)), NewX is CurrX+1, asserta(locX(NewX)),resize.
move(w) :- canMove(w),locX(CurrX),retract(locX(CurrX)), NewX is CurrX-1, asserta(locX(NewX)),resize.
move(n) :- canMove(n),locY(CurrY),retract(locY(CurrY)), NewY is CurrY-1, asserta(locY(NewY)),resize.
move(s) :- canMove(s),locY(CurrY),retract(locY(CurrY)), NewY is CurrY+1, asserta(locY(NewY)),resize.

/* RULES UNTUK PERGERAKAN ENEMY */
moveE(e,Enemy) :- canMove(e),Enemy('E',_,CurrX,CurrY),locX(CurrX),retract(locX(CurrX)), NewX is CurrX+1, asserta(locX(NewX)).
moveE(w,Enemy) :- canMove(w),Enemy('E',_,CurrX,CurrY),locX(CurrX),retract(locX(CurrX)), NewX is CurrX-1, asserta(locX(NewX)).
moveE(n,Enemy) :- canMove(n),Enemy('E',_,CurrX,CurrY),locY(CurrY),retract(locY(CurrY)), NewY is CurrY-1, asserta(locY(NewY)).
moveE(s,Enemy) :- canMove(s),Enemy('E',_,CurrX,CurrY),locY(CurrY),retract(locY(CurrY)), NewY is CurrY+1, asserta(locY(NewY)).

moveAllEnemy :- findall(X,(X = benda('E',_,_,_),isSurroundPlayer(X,Yes),Yes=:=0),BagE),
                moveEnemy(BagE).
            
moveEnemy([]):- !.
moveEnemy([H|T]):- random(1,5,temp),
                    moveList(temp,Sign),moveE(Sign,H),
                    moveEnemy(T).

moveList(X,Y) :- X = 1, Y is 'n',!.
moveList(X,Y) :- X = 2, Y is 'e',!.
moveList(X,Y) :- X = 3, Y is 's',!.
moveList(X,Y) :- X = 4, Y is 'w',!.

resize:- real_time(Time),Chance is Time mod 2, Chance =:= 0,petaSize(Size),retractall(petaSize(_)),asserta(petaSize(Size-2)).

cekP(X,Y) :- X = LocX, Y = LocY.

isSurroundPlayer(benda,Ret) :- benda(Simbol,_,X,Y), !,
                               cekP(X-1,Y-1), cekP(X,Y-1), cekP(X+1,Y-1),
                               cekP(X-1,Y), cekP(X,Y), cekP(X+1,Y),
                               cekP(X-1,Y+1), cekP(X,Y+), cekP(X+1,Y+1),
                               Ret = 1.


/*Pemain dapat take : weapon / helmet / armor / medicine / magazine */

/*
canTake(X) :- maxInventori(Y), Y<10, weapon(X), look(X).
canTake(X) :- maxInventori(Y), Y<10, armor(X), look(X).
canTake(X) :- maxInventori(Y), Y<10, medicine(X), look(X).
canTake(X) :- maxInventori(Y), Y<10, magazine(X,Y), look(X).

canDrop(X) :- using(X), inventory(X).

canUse(X) :- inventory(X), weapon(X).

canAttack() :- */