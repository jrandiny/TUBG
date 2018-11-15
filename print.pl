/* RULES */
printXHoriz(0):-nl.
printXHoriz(Count):-write('X'),NextCount is Count -1, printXHoriz(NextCount).

printMap(_,Y):- Y>12,!.
printMap(_,Y):- getTopLeft(_,YPojok),Y<YPojok,printXHoriz(34),!,printMap(1, Y+1).
printMap(_,Y):- getBottomRight(_,YBawah), Y>YBawah,printXHoriz(34),!,printMap(1,Y+1).
printMap(X,Y):- X>12,nl,!,printMap(1,Y+1).
printMap(X,Y):- isInside(X,Y),locX(XPlayer),locY(YPlayer),X=:=XPlayer,Y=:=YPlayer,write(' P '),!,printMap(X+1,Y).
printMap(X,Y):- isInside(X,Y),write(' - '),!,printMap(X+1,Y).
printMap(X,Y):- X=1,write('X '),!,printMap(X+1,Y).
printMap(X,Y):- write(' X '),!,printMap(X+1,Y).

/* objek('W',Nama,LocX,LocY)*/

printlook(X,Y) :- benda(Simbol,_,LocX,LocY), LocX =:= X, LocY =:= Y, format(' %s ',[Simbol]),!.
printlook(X,Y) :- \+(isInside(X,Y)), write(' X '),!.
printlook(X,Y) :- write(' - '),!.
 
surround(X,Y) :- printlook(X-1,Y-1),printlook(X,Y-1),printlook(X+1,Y-1),nl,
                 printlook(X-1,Y),printlook(X,Y),printlook(X+1,Y),nl,
                 printlook(X-1,Y+1),printlook(X,Y+1),printlook(X+1,Y+1),nl.

/*
Look ​ /0 ​ : menuliskan petak-petak 3x3 di sekitar pemain dengan posisi pemain saat ini
menjadi center. Dalam petak-petak tersebut tampilkan simbol untuk objek yang ada di
petak tersebut. Skala prioritas penampilan peta: Enemy > Medicine > Weapon > Armor
> Ammo > pemain. Jika ada lebih dari satu objek pada petak tersebut, tampilkan yang
memiliki prioritas tertinggi. Khusus untuk petak posisi pemain saat ini, berikan deskripsi
mengenai objek yang ada pada petak tersebut. Contoh dapat dilihat pada bagian E.

> look.
You are in the desert. You see a bandage. You see a pistol. You see pack of
magazines.
X _ _
X W _
X _ _

*/
look :- locX(X),locY(Y),surround(X,Y).

status:- write('Health: '),
        pHealth(Health),
        write(Health), nl,
        write('Armor: '),
        pArmor(Armor),
        write(Armor), nl,
        write('Weapon: '),
        pWeapon(Weapon),
        write(Weapon),nl,
        findall(Inventori,pInventori(Inventori),Bag),
        tulisInventori(Bag),!. /*print list*/

tulisInventori([H]) :- H = none,!,write('Your inventory is empty!'),nl.
tulisInventori([H]) :- write('Inventory: '),nl,write('   '),write(H),nl.
tulisInventori([H|T]) :- tulisInventori([T]),write('   '),write(H),nl,!.


printWelcome :- write(' ______  _     _ ______   ______                  _             '),nl,
                write('(_____ \\| |   | (____  \\ / _____)                | |          '),nl,
                write(' _____) ) |   | |____)  ) /  ___ ____   ____ ___ | | ___   ____ '),nl,
                write('|  ____/| |   | |  __  (| | (___)  _ \\ / ___) _ \\| |/ _ \\ / _  |'),nl,
                write('| |     | |___| | |__)  ) \\____/| | | | |  | |_| | | |_| ( ( | |'),nl,
                write('|_|      \\______|______/ \\_____/| ||_/|_|   \\___/|_|\\___/ \\_|| |'),nl, 
                write('                                |_|                      (_____|'),nl,       
                write('Welcome to the battlefield!'), nl,
                write('You have been chosen as one of the lucky contestants. Be the last man standing and you will be remembered as one of the victors'), nl, nl,
                printHelp.
printHelp :-    write('Available commands: '), nl,
                write('   start. -- start the game!'),nl,
                write('   help. -- show the available commands!'),nl,
                write('   quit. -- quit the game'),nl,
                write('   look. -- look around you'),nl,
                write('   n. s. e. w. -- move'),nl,
                write('   map. -- look at the map and detect enemies'),nl,
                write('   take(Object). -- pick up an object'),nl,
                write('   drop. -- drop an object'),nl,
                write('   use(Object). -- use an object'),nl,                                
                write('   attack. -- attack enemy that crosses your path'),nl,
                write('   status. -- show your status'),nl,
                write('   save(Filename). -- save your game'),nl,
                write('   load(Filename). -- load previously saved game'),nl,nl,
                write('Legends:'),nl, 
                write('W = weapon'),nl,                 
                write('A = armor'),nl, 
                write('M = medicine'),nl, 
                write('O = ammo'),nl, 
                write('P = player'),nl, 
                write('E = enemy'),nl,
                write('- = accessible'),nl,
                write('X = inaccessible'),nl.

/* take(X) :- canTake(X), asserta(PInventori(X)), write('You took the '), write(X),nl.
   use(X) :- canUse(X), weapon(X), write(X), write(' is equipped. But the gun's empty, mate.'), nl.
   use(X) :- canUse(X), magazine(X,Y), nl.        
*/

                                                                                                                                                                