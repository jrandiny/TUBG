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
move(e) :- canMove(e),locX(CurrX),retract(locX(CurrX)), NewX is CurrX+1, assertz(locX(NewX)),printMove.
move(w) :- canMove(w),locX(CurrX),retract(locX(CurrX)), NewX is CurrX-1, assertz(locX(NewX)),printMove.
move(n) :- canMove(n),locY(CurrY),retract(locY(CurrY)), NewY is CurrY-1, assertz(locY(NewY)),printMove.
move(s) :- canMove(s),locY(CurrY),retract(locY(CurrY)), NewY is CurrY+1, assertz(locY(NewY)),printMove.

/*MENGECILKAN MAP*/
resize:- resizeChance(X),real_time(Time),Chance is Time mod X, Chance =:= 0,
         petaSize(Size),Size>2,retractall(petaSize(_)),asserta(petaSize(Size-2)),write('\n\nThe map has shrink!').
resize.

terrainXY(X,Y,Terrain):- isInside(X,Y),peta(Peta),EvalY is Y,nth(EvalY,Peta,PetaY),EvalX is X,nth(EvalX,PetaY,Lokasi),terrainLabel(Lokasi,Terrain),!.
terrainXY(_,_,Terrain):- Terrain = 'deadzone'.
