/* RULES */
printXHoriz(0):-nl.
printXHoriz(Count):-write('X'),NextCount is Count -1, printXHoriz(NextCount).

printMap(X,Y):- Y>12,!,fail.
printMap(X,Y):- getTopLeft(_,YPojok),Y<YPojok,printXHoriz(12),!,printMap(1, Y+1).
printMap(X,Y):- getBottomRight(_,YBawah), Y>YBawah,printXHoriz(12),!,printMap(1,Y+1).
printMap(X,Y):- X>12,nl,!,printMap(1,Y+1).
printMap(X,Y):- isInside(X,Y),write('O'),!,printMap(X+1,Y).
printMap(X,Y):- write('X'),!,printMap(X+1,Y).
printMap(X,Y):- X>12,!,fail.



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