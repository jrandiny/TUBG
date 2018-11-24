/* RULES */
/* rule untuk inisialisasi semua file */
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

/* rule untuk inisialisasi pemain */
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

/* rule untuk inisialisasi peta */
setupPeta:- asserta(petaSize(10)),
            collectMap(Map),
            asserta(peta(Map)).

/* mengembalikan tile random dari daftar terrainLabel */
getRandomTile(Tile) :- findall(Object,terrainLabel(Object,_),Bag),
                       length(Bag,BagL),Max is BagL+1,
                       random(1,Max,N),nth(N,Bag,Tile).

/* memasukkan tile ke database untuk dibuat peta */
makeTileXY(X,Y) :- isInside(X,Y),getRandomTile(Tile), assertz(tempGenTile(Tile)),!.
makeTileXY(_,_) :- assertz(tempGenTile(x)).
 /* rule membuat tile sebanyak kolom peta */
generateRow(X,Y) :- maxMapSize(Max),X=<Max,makeTileXY(X,Y),Z is X+1,generateRow(Z,Y).
generateRow(X,_) :- maxMapSize(Max),X>Max.
/* rule membuat baris sebanyak maxMapSize pada peta */
generateMap(X,Y) :- maxMapSize(Max),
                    Y=<Max,generateRow(1,Y),
                    findall(Tile,tempGenTile(Tile),List),
                    retractall(tempGenTile(_)),
                    assertz(tempGenRow(List)),
                    Z is Y+1,generateMap(X,Z).
generateMap(_,Y) :- maxMapSize(Max),Y>Max.
/* rule untuk membuat peta */
collectMap(Map) :- generateMap(1,1),findall(Row,tempGenRow(Row),Map),retractall(tempGenRow(_)).

/* rule untuk memulai permainan */
start :- write('Enter your name : '),
         read(Name),
         assertz(playerName(Name)),
         setupGame,
         printWelcome,nl,
         repeat,
            write('> '),
            read(Ans),
            \+((\+(execute(Ans)),write('Command invalid.\n\n'))),nl,nl,
            (Ans == quit; loseGame ; winGame),!.

/* RULES EXECUTEABLE */
execute(quit):- write('You quit the game.').
execute(look) :- look.
execute(help) :- printHelp.
execute(status):- status.
execute(map) :- printMap(1,1).
execute(n) :- enemyAttack, move(n),routineCheck.
execute(w) :- enemyAttack, move(w),routineCheck.
execute(e) :- enemyAttack, move(e),routineCheck.
execute(s) :- enemyAttack, move(s),routineCheck.
execute(take(X)) :- take(X).
execute(use(X)):- use(X).
execute(drop(X)):- drop(X).
execute(attack) :- attack.
execute(save(X)) :- saveAll(X),write('Game saved.').
execute(load(X)) :- loadAll(X),write('Game loaded.').
execute(loadDebug(X)) :- consult(X).
execute(X) :- debug(X).

debug(dummy).

/* predikat yang dicek setiap kali jalan */
routineCheck :- resize,randomDrop,deadAllEnemy,resolveAllEnemy,moveAllEnemy.

/* predikat yang menyatakan saat menang */
winGame:- findall(1,(enemy(_,_,_,_,_)),Bag),
          length(Bag,JumlahE),
          JumlahE=:=0,
          %shell('aplay lagu.wav &'),
          write('You got an A'),nl,
          write('YAYY'),nl,
          sleep(1),
          write('...hmm'),nl,
          sleep(1),
          write('But....'),nl,
          sleep(1.5),
          write('What did it cost me...'),nl,
          sleep(0.5),
          write('.'),nl,
          sleep(0.5),
          write('.'),nl,
          sleep(0.5),
          write('.'),nl,
          sleep(0.5),nl,nl,nl,
          write('We gather here to support those who have lost their beloved friend and family member'),nl,
          sleep(2),
          write('The world is cruel to take away such young man'),nl,
          sleep(2),
          write('But life must go on'),nl,
          sleep(1),
          write('See you...'),nl,
          sleep(0.5),
          write('.'),nl,
          sleep(0.5),
          write('.'),nl,
          sleep(0.5),
          write('.'),nl,
          sleep(0.5),
          playerName(Name),write(Name),nl,
          write('You will always be remembered...'),nl,
          sleep(2),
          write('The person who sacrifice everything...'),nl,
          sleep(2),nl,
          write('for tubes...').
          
/* predikat yang menyatakan saat kalah */
loseGame:- pHealth(Health),
           Health =<  0,
           write('We are dissapointed in you '),
           playerName(Name),write(Name),write('.').
loseGame:- locX(X),locY(Y),
           \+isInside(X,Y),
           write('The deadline catches you!'),!.

/* rule untuk melakukan random drop pada peta */
randomDrop:- dropChance(X),
             real_time(Time),
             Chance is Time mod X, 
             Chance =:= 0,
             random(1,5,Random),
             dropRandomBase(Base),dropRandomMax(Max),random(Base,Max,RandomCount),
             dropRandomObject(Random,RandomCount),
             write('\n\nThere is a new drop on the map!'),!.
randomDrop.
/* drop weapon */
dropRandomObject(1,Count):- findall(Object,weapon(Object),Bag),
                            while_randomObject(Bag,Count,'W').
/* drop medicine */
dropRandomObject(2,Count):- findall(Object,medicine(Object),Bag),
                            while_randomObject(Bag,Count,'M').
/* drop armor */
dropRandomObject(3,Count):- findall(Object,armor(Object),Bag),
                            while_randomObject(Bag,Count,'A').
/* drop magazine */
dropRandomObject(4,Count):- findall(Object,magazine(Object,_),Bag),
                            while_randomObject(Bag,Count,'O').
/* drop bag */
dropRandomObject(5,Count):- findall(Object,bag(Object,_),Bag),
                            while_randomObject(Bag,Count,'B').

/* rule untuk melakukan random setup lokasi benda-benda saat awal permainan */
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
/* setup objek yang loopin, diulang sebanyak N kali */
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