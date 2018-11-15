/* RULES */
setupGame:- consult('definition.pl'),
            consult('print.pl'),
            consult('space.pl'),
            consult('inventori.pl'),
            real_time(Time),
            set_seed(Time),
            setupPemain,
            setupPeta,
            setupRandomObject.

setupPemain:-   maxHealth(Health),
                asserta(pHealth(Health)),
                asserta(pArmor(0)),
                asserta(pWeapon(none)),
                asserta(pInventori(none)),
                asserta(pInventoriAmmo(0)),
                random(2,12,RandX),
                random(2,12,RandY),
                asserta(locX(RandX)),
                asserta(locY(RandY)).
            
setupPeta:- asserta(petaSize(10)).

/*
objek('W',ak47,4,4).
objek('A',abcd,5,5). */

start :- setupGame,
         printWelcome,nl,
         repeat,
            write('> '),
            read(Ans),
            execute(Ans),nl,
            (Ans == quit),!.


execute(quit).
execute(look) :- locX(CurrX),locY(CurrY),surround(CurrX,CurrY).
execute(help) :- printHelp.
execute(status):- status.
execute(map) :- printMap(1,1).
execute(n) :- move(n).
execute(w) :- move(w).
execute(e) :- move(e).
execute(s) :- move(s).
execute(take(X)) :- take(X).


/* objek('W',Nama,LocX,LocY) */
setupRandomObject:- findall(Object,weapon(Object),BagW),
                    maxWeapon(MaxW)
                    while_randomObject(BagW,MaxW,'W'),
                    findall(Object,medicine(Object),BagM),
                    maxMedicine(MaxM),
                    while_randomObject(BagM,MaxM,'M'),
                    findall(Object,armor(Object),BagA),
                    maxArmor(MaxA),
                    while_randomObject(BagA,MaxA,'A'),
                    findall(Object,magazine(Object,_),BagO),
                    maxMagazine(MaxO),
                    while_randomObject(BagO,MaxO,'O'),
                    maxEnemy(MaxE),
                    while_randomObject(BagW,MaxE,'E').

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