/* RULES */
setupGame:- consult('definition.pl'),
            consult('print.pl'),
            consult('space.pl'),
            consult('inventori.pl'),
            consult('enemy.pl'),
            consult('eksternal.pl'),
            real_time(Time),
            set_seed(Time),
            setupPemain,
            setupPeta,
            setupRandomObject.

setupPemain:-   maxpHealth(Health),
                asserta(pHealth(Health)),
                asserta(pArmor(0)),
                asserta(pWeapon(none)),
                asserta(pInventori(none)),
                asserta(pInventoriAmmo(0)),
                asserta(pCurrAmmo(0)),
                asserta(maxInventori(3)),
                random(2,12,RandX),
                random(2,12,RandY),
                asserta(locX(RandX)),
                asserta(locY(RandY)).
            
setupPeta:- asserta(petaSize(10)),
            asserta(peta([[x,x,x,x,x,x,x,x,x,x,x,x],
                        [x,a,a,b,b,b,b,d,d,d,d,x],
                        [x,a,a,a,b,b,b,b,d,d,d,x],
                        [x,b,a,a,b,b,b,b,d,d,d,x],
                        [x,b,a,a,b,b,b,b,d,d,d,x],
                        [x,b,b,b,b,c,c,b,d,d,d,x],
                        [x,b,b,b,c,c,c,c,b,d,d,x],
                        [x,b,b,b,c,c,c,c,b,b,d,x],
                        [x,b,b,b,b,c,c,c,b,b,d,x],
                        [x,b,b,b,b,b,c,b,d,d,d,x],
                        [x,b,b,b,b,b,b,b,b,b,d,x],
                        [x,x,x,x,x,x,x,x,x,x,x,x]])).

/*
objek('W',ak47,4,4).
objek('A',abcd,5,5). */

start :- setupGame,
         printWelcome,nl,
         repeat,
            write('> '),
            read(Ans),
            \+((\+(execute(Ans)),write('Command invalid.\n\n'))),randomDrop,nl,nl,
            (Ans == quit; loseGame ; winGame),!.


execute(quit).
execute(look) :- look.
execute(help) :- printHelp.
execute(status):- status.
execute(map) :- printMap(1,1).
execute(n) :- enemyDo, move(n),routineCheck.
execute(w) :- enemyDo, move(w),routineCheck.
execute(e) :- enemyDo, move(e),routineCheck.
execute(s) :- enemyDo, move(s),routineCheck.
execute(take(X)) :- take(X).
execute(use(X)):- use(X).
execute(drop(X)):- drop(X).
execute(attack) :- attack.
execute(save(X)) :- saveAll(X),write('Game saved.').
execute(load(X)) :- loadAll(X),write('Game loaded.').
execute(list) :- findall(1,(benda('E',_,X,Y),write(X),write(' '),write(Y),nl),_).

enemyDo :- enemyAttack.
enemyDo.

routineCheck :- resize,deadAllEnemy,resolveAllEnemy,moveAllEnemy.

winGame:- findall(X,(benda(X,_,_,_),X = 'E'),Bag),length(Bag,JumlahE),JumlahE=:=0,write('WINNER-WINNER\nCHICKEN DINNER!\n'). /* goal state*/
loseGame:- pHealth(Health),Health =<  0,write('WASTED'),nl,write('See your past'),nl,execute(look).
loseGame:- locX(X),locY(Y),\+isInside(X,Y),write('The deadzone catches you!'),!. /* fail state*/

randomDrop:- dropChance(X),real_time(Time),Chance is Time mod X, Chance =:= 0,
            random(1,5,Random),
            dropRandomBase(Base),dropRandomMax(Max),random(Base,Max,RandomCount),
            dropRandomObject(Random,RandomCount).
randomDrop.

dropRandomObject(1,Count):- findall(Object,weapon(Object),Bag),
                            while_randomObject(Bag,Count,'W').

dropRandomObject(2,Count):- findall(Object,medicine(Object),Bag),
                            while_randomObject(Bag,Count,'M').

dropRandomObject(3,Count):- findall(Object,armor(Object),Bag),
                            while_randomObject(Bag,Count,'A').

dropRandomObject(4,Count):- findall(Object,magazine(Object,_),Bag),
                            while_randomObject(Bag,Count,'O').

dropRandomObject(5,Count):- findall(Object,bag(Object,_),Bag),
                            while_randomObject(Bag,Count,'B').

spawnRandomEnemy(Count):- findall(Object,weapon(Object),Bag),
                          while_randomObject(Bag,Count,'E').
                                                        
/* objek('W',Nama,LocX,LocY) */
setupRandomObject:- maxWeapon(MaxW),
                    dropRandomObject(1,MaxW),                    
                    maxMedicine(MaxM),
                    dropRandomObject(2,MaxM),
                    maxArmor(MaxA),
                    dropRandomObject(3,MaxA),
                    maxMagazine(MaxO),
                    dropRandomObject(4,MaxO),
                    maxBag(MaxB),
                    dropRandomObject(5,MaxB),
                    maxEnemy(MaxE),
                    spawnRandomEnemy(MaxE).

while_randomObject(_,0,_).
while_randomObject(L,N,Sign):- N > 0,
                            getTopLeft(X1,Y1),
                            getBottomRight(X2,Y2),
                            random(X1,X2,LocX),
                            random(Y1,Y2,LocY),
                            length(L,TmpCount),
                            Count is TmpCount+1,
                            random(1,Count,Idx),
                            nth(Idx,L,Object),
                            asserta(benda(Sign,Object,LocX,LocY)),
                            M is N-1,
                            !,while_randomObject(L,M,Sign).