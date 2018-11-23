/* RULES */
printXHoriz(0):-nl.
printXHoriz(Count):-write('X'),NextCount is Count -1, printXHoriz(NextCount).

printMap(_,Y):- maxMapSize(MaxSize),Y>MaxSize,!.
printMap(_,Y):- maxMapSize(MaxSize),
                getTopLeft(_,YPojok),
                Y<YPojok,
                printXHoriz((MaxSize*3 )-2),!,
                printMap(1, Y+1).
printMap(_,Y):- maxMapSize(MaxSize),
                getBottomRight(_,YBawah),
                Y>YBawah,printXHoriz((MaxSize *3)-2),!,
                printMap(1,Y+1).
printMap(X,Y):- maxMapSize(MaxSize),
                X>MaxSize,nl,!,
                printMap(1,Y+1).
printMap(X,Y):- isInside(X,Y),
                locX(XPlayer),locY(YPlayer),
                X=:=XPlayer,Y=:=YPlayer,
                write(' P '),!,
                printMap(X+1,Y).
printMap(X,Y):- isInside(X,Y),write(' - '),!,
                printMap(X+1,Y).
printMap(X,Y):- X=1,write('X '),!,printMap(X+1,Y).
printMap(X,Y):- write(' X '),!,printMap(X+1,Y).

printEnemyMap(_,Y):- maxMapSize(MaxSize),Y>MaxSize,!.
printEnemyMap(_,Y):- maxMapSize(MaxSize),
                     getTopLeft(_,YPojok),
                     Y<YPojok,
                     printXHoriz((MaxSize*3 )-2),!,
                     printEnemyMap(1, Y+1).
printEnemyMap(_,Y):- maxMapSize(MaxSize),
                     getBottomRight(_,YBawah),
                     Y>YBawah,printXHoriz((MaxSize*3 )-2),!,
                     printEnemyMap(1,Y+1).
printEnemyMap(X,Y):- maxMapSize(MaxSize),
                     X>MaxSize,nl,!,
                     printEnemyMap(1,Y+1).
printEnemyMap(X,Y):- isInside(X,Y),locX(XPlayer),locY(YPlayer),X=:=XPlayer,Y=:=YPlayer,write(' P '),!,printEnemyMap(X+1,Y).
printEnemyMap(X,Y):- isInside(X,Y),findall(1,(enemy('E',_,CurrX,CurrY,_),CurrX=:=X,CurrY=:=Y),Bag),length(Bag,ListEnemy),ListEnemy>0,write(' E '),!,printEnemyMap(X+1,Y).
printEnemyMap(X,Y):- isInside(X,Y),write(' - '),!,printEnemyMap(X+1,Y).
printEnemyMap(X,Y):- X=1,write('X '),!,printEnemyMap(X+1,Y).
printEnemyMap(X,Y):- write(' X '),!,printEnemyMap(X+1,Y).

/* objek('W',Nama,LocX,LocY)*/
printlook(X,Y) :- \+(isInside(X,Y)), write(' X '),!.
printlook(X,Y) :- enemy(_,_,X,Y,_),write(' E '),!.
printlook(X,Y) :- benda(Simbol,_,X,Y), Simbol='M',write(' M '),!.
printlook(X,Y) :- benda(Simbol,_,X,Y), Simbol='W',write(' W '),!.
printlook(X,Y) :- benda(Simbol,_,X,Y), Simbol='A',write(' A '),!.
printlook(X,Y) :- benda(Simbol,_,X,Y), Simbol='O',write(' O '),!.
printlook(X,Y) :- benda(Simbol,_,X,Y), Simbol='B',write(' B '),!.
printlook(X,Y) :- locX(X), locY(Y),write(' P '),!.
printlook(_,_) :- write(' - '),!.
 
surround(X,Y) :- printlook(X-1,Y-1),printlook(X,Y-1),printlook(X+1,Y-1),nl,
                 printlook(X-1,Y),printlook(X,Y),printlook(X+1,Y),nl,
                 printlook(X-1,Y+1),printlook(X,Y+1),printlook(X+1,Y+1).

look :- locX(X),locY(Y),printAllObject,nl,surround(X,Y).
printAllObject :- findall(1,(locX(X),locY(Y),printObject(X,Y)),_).
printObject(X,Y) :- enemy(_,_,X,Y,_), write('You see an enemy. ').
printObject(X,Y) :- benda(Sign,ObjName,X,Y),Sign == 'W', format('You see an empty %s',[ObjName]),write(' lying on the grass. ').
printObject(X,Y) :- benda(Sign,ObjName,X,Y),Sign \== 'W', format('You see a %s. ',[ObjName]).
printObject(X,Y) :- \+(benda(_,_,X,Y)),write('There is nothing in your place.').

status:- write('Health: '),
        pHealth(Health),
        write(Health), nl,
        write('Armor: '),
        pArmor(Armor),
        write(Armor), nl,
        write('Weapon: '),
        printWeapon,nl,
        write('Max Inventory: '),
        maxInventori(MaxInventori),
        write(MaxInventori), nl,        
        findall(Inventori,pInventori(Inventori),Bag),
        tulisInventori(Bag),!. /*print list*/

printWeapon :- pWeapon(Weapon),write(Weapon),Weapon == none,!.
printWeapon :- pCurrAmmo(CurrAmmo), CurrAmmo =:= 0, !.
printWeapon :- pCurrAmmo(CurrAmmo), format('\nAmmo: %d',[CurrAmmo]).


tulisAmmo(Count) :- Count=\=0, maxAmmoPack(MaxAmmo),Count >MaxAmmo, format('\n   Pack of ammo (%d)',[MaxAmmo]),NewAmmo is Count - MaxAmmo,!,tulisAmmo(NewAmmo).
tulisAmmo(Count) :- Count=\=0, format('\n   Pack of ammo (%d)',[Count]).
tulisAmmo(0).

tulisInventori([H]) :- H = none,
                       pInventoriAmmo(Ammo),
                       Ammo =:=0,!,
                       write('Your inventory is empty!').
tulisInventori([H]) :- write('Inventory: '),
                       pInventoriAmmo(Ammo),
                       tulisAmmo(Ammo),
                       H==none,!.
tulisInventori([H]) :- nl,write('   '),write(H).
tulisInventori([H|T]) :- tulisInventori(T),nl,write('   '),write(H),!.

printMove:- locX(X),locY(Y),
                terrainXY(X,Y,TerrainNow),
                format('You are in %s. ',[TerrainNow]),
                printMoveEnemy(X,Y),
                printMoveNorth(X,Y),
                printMoveEast(X,Y),
                printMoveSouth(X,Y),
                printMoveWest(X,Y).

printMoveNorth(X,Y):- locX(X),locY(Y),
                      terrainXY(X,Y-1,Terrain),
                      format('To the north is %s. ',[Terrain]).
printMoveEast(X,Y):- locX(X),locY(Y),
                     terrainXY(X+1,Y,Terrain),
                     format('To the east is %s. ',[Terrain]).
printMoveSouth(X,Y):- locX(X),locY(Y),
                      terrainXY(X,Y+1,Terrain),
                      format('To the south is %s. ',[Terrain]).
printMoveWest(X,Y):- locX(X),locY(Y),
                     terrainXY(X-1,Y,Terrain),
                     format('To the west is %s.',[Terrain]).                                                                        
printMoveEnemy(X,Y):- enemy('E',_,X,Y,_),write('You encounter an enemy! Kill or be killed! ').
printMoveEnemy(_,_).


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
                write('   map. -- look at the map, show the deadzone and the safezone'),nl,
                write('   take(Object). -- pick up an object'),nl,
                write('   drop(Object). -- drop an object'),nl,
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
                write('B = bag'),nl, 
                write('P = player'),nl, 
                write('E = enemy'),nl,
                write('- = accessible'),nl,
                write('X = inaccessible'),nl.


                                                                                                                                                                