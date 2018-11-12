/* RULES */
printXHoriz(0):-nl.
printXHoriz(Count):-write('X'),NextCount is Count -1, printXHoriz(NextCount).

printMap(X,Y):- Y>12,!.
printMap(X,Y):- getTopLeft(_,YPojok),Y<YPojok,printXHoriz(33),!,printMap(1, Y+1).
printMap(X,Y):- getBottomRight(_,YBawah), Y>YBawah,printXHoriz(33),!,printMap(1,Y+1).
printMap(X,Y):- X>12,nl,!,printMap(1,Y+1).
printMap(X,Y):- isInside(X,Y),write(' - '),!,printMap(X+1,Y).
printMap(X,Y):- X=1,write('X'),!,printMap(X+1,Y).
printMap(X,Y):- write(' X '),!,printMap(X+1,Y).

status:- write('Health: '),
        pHealth(Health),
        write(Health), nl,
        write('Armor: '),
        pArmor(Armor), nl,
        write(Armor),
        write('Weapon: '),
        pWeapon(Weapon),
        write(Weapon),nl,
        write('Inventory : '). /*print list*/