setupRandEnemy :- random(5,11,MaxEnemies),
                  while_randomEnemy(MaxEnemies,'E')
                  
while_randomEnemy(_,0,_).
while_randomEnemy(N,Sign) :- !,N>0,
                        petaSize(Size),
                        Base is ((12-Size)//2)+1,
                        Max is (Base+Size),
                        random(Base,Max,LocX),
                        random(Base,Max,LocY),
                        randomWeapon(Weapon),
                        asserta(enemy(Sign,Weapon,LocX,LocY)),
                        while_randomEnemy(N-1,Sign).

randWeapon(Weapon):- findall(Object, weapon(Object),ListWeapon)
                     length(ListWeapon,TmpCount),
                     Count is TmpCount+1,
                     random(1,Count,Idx),
                     nth(Idx,ListWeapon,Weapon),
                     

canMove(Direction) :- Direction == n, locX(X), locY(Y), isInside(X,Y-1).
canMove(Direction) :- Direction == e, locX(X), locY(Y), isInside(X+1,Y).
canMove(Direction) :- Direction == s, locX(X), locY(Y), isInside(X,Y+1).
canMove(Direction) :- Direction == w, locX(X), locY(Y), isInside(X-1,Y).  

moveE(e) :- canMove(e),benda('E',_,CurrX,CurrY),locX(CurrX),retract(locX(CurrX)), NewX is CurrX+1, asserta(locX(NewX)).
moveE(w) :- canMove(w),benda('E',_,CurrX,CurrY),locX(CurrX),retract(locX(CurrX)), NewX is CurrX-1, asserta(locX(NewX)).
moveE(n) :- canMove(n),benda('E',_,CurrX,CurrY),locY(CurrY),retract(locY(CurrY)), NewY is CurrY-1, asserta(locY(NewY)).
moveE(s) :- canMove(s),benda('E',_,CurrX,CurrY),locY(CurrY),retract(locY(CurrY)), NewY is CurrY+1, asserta(locY(NewY)).

moveAllEnemy :- random(1,5,temp),
                moveList(temp,Sign),
                moveE(Sign).



moveList(X,Y) :- X = 1, Y is 'n',!.
moveList(X,Y) :- X = 2, Y is 'e',!.
moveList(X,Y) :- X = 3, Y is 's',!.
moveList(X,Y) :- X = 4, Y is 'w',!.