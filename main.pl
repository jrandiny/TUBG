/* RULES */
setupGame:- consult('definition.pl'),
            consult('print.pl'),
            consult('space.pl'),
            consult('inventori.pl'),
            consult('enemy.pl'),
            consult('eksternal.pl'),
            setupPeta,
            real_time(Time),
            set_seed(Time),
            setupPemain,
            setupRandomObject.

setupPemain:-   maxpHealth(Health),
                asserta(pHealth(Health)),
                asserta(pArmor(0)),
                asserta(pWeapon(none)),
                asserta(pInventori(none)),
                asserta(pInventoriAmmo(0)),
                asserta(pCurrAmmo(0)),
                asserta(maxInventori(3)),
                getTopLeft(TopX,TopY),
                getBottomRight(BottomX,BottomY),
                random(TopX,BottomX,RandX),
                random(TopY,BottomY,RandY),
                asserta(locX(RandX)),
                asserta(locY(RandY)).
            
setupPeta:- asserta(petaSize(10)),
            collectMap(Map),
            asserta(peta(Map)).

getRandomTile(Tile) :- findall(Object,terrainLabel(Object,_),Bag),
                       length(Bag,BagL),Max is BagL+1,
                       random(1,Max,N),nth(N,Bag,Tile).

makeTileXY(X,Y) :- isInside(X,Y),getRandomTile(Tile), assertz(tempGenTile(Tile)),!.
makeTileXY(_,_) :- assertz(tempGenTile(x)).
 
generateRow(X,Y) :- maxMapSize(Max),X=<Max,makeTileXY(X,Y),Z is X+1,generateRow(Z,Y).
generateRow(X,Y) :- maxMapSize(Max),X>Max.
generateColumn(X,Y) :- maxMapSize(Max),Y=<Max,generateRow(1,Y),makeMapRow,Z is Y+1,generateColumn(X,Z).
generateColumn(X,Y) :- maxMapSize(Max),Y>Max.

makeMapRow :- findall(Tile,tempGenTile(Tile),List),
              retractall(tempGenTile(_)),
              assertz(tempGenRow(List)).

collectMap(Map) :- generateColumn(1,1),findall(Row,tempGenRow(Row),Map),retractall(tempGenRow(_)).

start :- setupGame,
         printWelcome,nl,
         repeat,
            write('> '),
            read(Ans),
            \+((\+(execute(Ans)),write('Command invalid.\n\n'))),nl,nl,
            (Ans == quit; loseGame ; winGame),!.


execute(quit):- write('You quit the game.').
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
execute(enemy):- printEnemyMap(1,1).
execute(teleport(X,Y)) :- retract(locX(_)),retract(locY(_)),asserta(locX(X)),asserta(locY(Y)).
execute(oneEnemy):- retractall(enemy(_,_,_,_,_)),spawnRandomEnemy(1).
execute(trace) :- trace.
execute(hesoyam):- retract(pHealth(_)),retract(pArmor(_)),asserta(pHealth(100)),asserta(pArmor(100)).
execute(fullclip):- addCurrAmmo(9999).
execute(resizeMapTo(X)) :- retract(petaSize(_)),asserta(petaSize(X)).
execute(botKill):- retractall(enemy(_,_,_,_,_)).
execute(goodbyeTubes):- retract(pHealth(_)),retract(pArmor(_)),asserta(pHealth(0)),asserta(pArmor(0)),write('You commited suicide.').
execute(sayaSukaTubes):- write('Anda diamuk massa! Anda kehilangan setengah nyawa anda.'),pHealth(Health),NewHP is Health//2,
                        retract(pHealth(_)),asserta(pHealth(NewHP)).
execute(botAdd(X)):- spawnRandomEnemy(X).
execute(professionalskit):- retract(pWeapon(_)),asserta(pWeapon(awp)).

enemyDo :- enemyAttack,!.
enemyDo.

routineCheck :- resize,randomDrop,deadAllEnemy,resolveAllEnemy,moveAllEnemy.

winGame:- findall(1,(enemy(_,_,_,_,_)),Bag),
          length(Bag,JumlahE),
          JumlahE=:=0,
          write('WINNER-WINNER\nCHICKEN DINNER!\n').
loseGame:- pHealth(Health),
           Health =<  0,
           write('WASTED').
loseGame:- locX(X),locY(Y),
           \+isInside(X,Y),
           write('The deadzone catches you!'),!.

randomDrop:- dropChance(X),
             real_time(Time),
             Chance is Time mod X, 
             Chance =:= 0,
             random(1,5,Random),
             dropRandomBase(Base),dropRandomMax(Max),random(Base,Max,RandomCount),
             dropRandomObject(Random,RandomCount),
             write('\n\nThere is a new drop on the map!'),!.
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