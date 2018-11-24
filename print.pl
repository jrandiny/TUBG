/* RULES PRINT PETA*/
/* menampilak sebaris X */
printXHoriz(0):-nl.
printXHoriz(Count):-write('X'),NextCount is Count -1, printXHoriz(NextCount).

/* menuliskan peta yang sesuai dengan petaSize */
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

/* menampilkan peta bersamaan dengan lokasi enemy */
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

/* rule untuk hierarki penampilan objek */
printlook(X,Y) :- \+(isInside(X,Y)), write(' X '),!.
printlook(X,Y) :- enemy(_,_,LocX,LocY,_),
                  LocX=:=X,LocY=:=Y,
                  write(' E '),!.
printlook(X,Y) :- benda(Simbol,_,LocX,LocY),
                  LocX=:=X,LocY=:=Y, 
                  Simbol='M',
                  write(' M '),!.
printlook(X,Y) :- benda(Simbol,_,LocX,LocY),
                  LocX=:=X,LocY=:=Y, 
                  Simbol='W',
                  write(' W '),!.
printlook(X,Y) :- benda(Simbol,_,LocX,LocY),
                  LocX=:=X,LocY=:=Y, 
                  Simbol='A',
                  write(' A '),!.
printlook(X,Y) :- benda(Simbol,_,LocX,LocY),
                  LocX=:=X,LocY=:=Y, 
                  Simbol='O',
                  write(' O '),!.
printlook(X,Y) :- benda(Simbol,_,LocX,LocY),
                  LocX=:=X,LocY=:=Y, 
                  Simbol='B',
                  write(' B '),!.
printlook(X,Y) :- locX(X), locY(Y),
                  write(' P '),!.
printlook(_,_) :- write(' - '),!.

/* rule menampilkan keadaan sekitar player */
surround(X,Y) :- printlook(X-1,Y-1),printlook(X,Y-1),printlook(X+1,Y-1),nl,
                 printlook(X-1,Y),printlook(X,Y),printlook(X+1,Y),nl,
                 printlook(X-1,Y+1),printlook(X,Y+1),printlook(X+1,Y+1).

/* rule yang menjalankan command look */
look :- locX(X),locY(Y),
        printAllObject,nl,surround(X,Y).

/* rule untuk menuliskan semua objek-objek yang ada di lokasi pemain */
printAllObject :- findall(1,(locX(X),locY(Y),printObject(X,Y)),_).
printObject(X,Y) :- enemy(_,_,X,Y,_), write('You see your friend. ').
printObject(X,Y) :- benda(Sign,ObjName,X,Y),Sign == 'W', format('You suddenly thought of %s',[ObjName]),write(' inspiration. ').
printObject(X,Y) :- benda(Sign,ObjName,X,Y),Sign \== 'W', format('You see %s. ',[ObjName]).
printObject(X,Y) :- \+(benda(_,_,X,Y)),write('There is nothing in your place.').

/* rule untuk menampilkan semua status player */
status:- write('Energy : '),
        pHealth(Health),
        write(Health), nl,
        write('Reference : '),
        pArmor(Armor),
        write(Armor), nl,
        write('Tubes : '),
        printWeapon,nl,
        write('Max Inventory: '),
        maxInventori(MaxInventori),
        write(MaxInventori), nl,        
        findall(Inventori,pInventori(Inventori),Bag),
        tulisInventori(Bag),!. /*print list*/

/* rule untuk menampilkan ammo jika ada weaponnya */
printWeapon :- pWeapon(Weapon),write(Weapon),Weapon == none,!.
printWeapon :- pCurrAmmo(CurrAmmo), CurrAmmo =:= 0, !.
printWeapon :- pCurrAmmo(CurrAmmo), format('\nSpecification: %d',[CurrAmmo]).

/* RULES MENULIS INVENTORI SEKARANG */
/* tulis ammo sekarang */
tulisAmmo(Count) :- Count=\=0, 
                    maxAmmoPack(MaxAmmo),
                    Count >MaxAmmo,
                    format('\n   Pack of specification (%d)',[MaxAmmo]),
                    NewAmmo is Count - MaxAmmo,!,
                    tulisAmmo(NewAmmo).
tulisAmmo(Count) :- Count=\=0,
                    format('\n   Pack of specification (%d)',[Count]).
tulisAmmo(0).
/* tulis inventori sekarang */
tulisInventori([H]) :- H = none,
                       pInventoriAmmo(Ammo),
                       Ammo =:=0,!,
                       write('Your inventory is empty!').
tulisInventori([H]) :- write('Inventory: '),
                       pInventoriAmmo(Ammo),
                       tulisAmmo(Ammo),
                       H==none,!.
tulisInventori([H]) :- nl,write('   '),write(H).
tulisInventori([H|T]) :- tulisInventori(T),nl,
                         write('   '),write(H),!.

/* rule yang dipanggil setiap kali move untuk menampilkan terrain di sekitar player */
printMove:- locX(X),locY(Y),
            terrainXY(X,Y,TerrainNow),
            format('You are in %s. ',[TerrainNow]),
            printMoveEnemy(X,Y),
            printMoveNorth(X,Y),
            printMoveEast(X,Y),
            printMoveSouth(X,Y),
            printMoveWest(X,Y).
/* dafter print sesuai arah */
printMoveNorth(X,Y):- locX(X),locY(Y),
                      terrainXY(X,Y-1,Terrain),
                      format('To the north, there is %s. ',[Terrain]).
printMoveEast(X,Y):- locX(X),locY(Y),
                     terrainXY(X+1,Y,Terrain),
                     format('To the east, there is %s. ',[Terrain]).
printMoveSouth(X,Y):- locX(X),locY(Y),
                      terrainXY(X,Y+1,Terrain),
                      format('To the south, there is %s. ',[Terrain]).
printMoveWest(X,Y):- locX(X),locY(Y),
                     terrainXY(X-1,Y,Terrain),
                     format('To the west, there is %s.',[Terrain]).                                                                        
printMoveEnemy(X,Y):- enemy('E',_,X,Y,_),
                      write('You bumped into another student! Decide what to do! ').
printMoveEnemy(_,_).

                                                


/* rule yang menampilkan pesan pembuka */
printWelcome :- nl,nl,write('Suatu hari di ITB, Institut Tugas Besar, seluruh mahasiswa jurusan IF sedang mengerjakan tubes,'),
                nl,write(' hal yang biasa di institut ini. Akan tetapi karena sudah sering memberi tubes, para dosen mulai '),
                nl,write('malas untuk membuat tubes lagi. Hingga suatu saat, seorang dosen mendapat ide brilian. Dosen tersebut'),
                nl,write('mempunyai ide, yaitu ia akan menyuruh sesama mahasiswa untuk memberi tubes satu sama lain. Saat dia '),
                nl,write('memberi tahu ide ini pada teman-teman dosennya, ruangan dosen langsung penuh keriuhan, semua setuju...'),
                nl,write(' Selama beberapa hari mereka menentukan cara terbaik untuk mengeksekusi ide ini. Hasilnya adalah...'),
                nl,printLogo,nl,nl,
                write('Terinspirasi dari fenomena battle royale seperti PUBG dan Fortnite, para dosen sepakat untuk membuat sistem '),
                nl,write('battleroyal untuk tugas besar. Mahasiswa akan memberi tubes satu sama lain, dan urutan bertahannya akan menjadi indeksnya.'),
                nl,nl,
                write('Setiap mahasiswa memiliki tingkat energi dan setiap tugas besar memilik beban masing-masing.'),
                nl,write('Tiap spek yang diberikan akan mengurangi energi para mahasiswa.'),
                nl,write('Mahasiswa tidak dapat menambahkan energi yang berkurang karena, no sleep.'),
                nl,write('Mahasiswa juga dapat menggunakan bantuan-bantuan seperti menyalin tubes kating dan lainnya.'),
                nl,write('Inspirasi untuk membuat tugas besar bisa didapatkan dari tempat-tempat di sekitar ITB.'),
                nl,
                nl,write('KAMU, iya kamu, harus melewati ini semua. Orangtuamu bergantung padamu, saudara-saudaramu bergantung padamu,'),
                nl,write('kampungmu bergantung padamu, untuk dapat A, untuk sukses, dan membawa Indonesia maju.'),nl,nl,
                printHelp.

printLogo    :- write('        ,----,                                  '),nl,
                write('      ,/   .`|                                  '),nl,
                write('    ,`   .\'  :               ,---,.   ,----..   '),nl,
                write('  ;    ;     /       ,--,  ,\'  .\'  \\ /   /   \\  '),nl,
                write('.\'___,/    ,\'      ,\'_ /|,---.\' .\' ||   :     : '),nl,
                write('|    :     |  .--. |  | :|   |  |: |.   |  ;. / '),nl,
                write(';    |.\';  ;,\'_ /| :  . |:   :  :  /.   ; /--`  '),nl,
                write('`----\'  |  ||  \' | |  . .:   |    ; ;   | ;  __ '),nl,
                write('    \'   :  ;|  | \' |  | ||   :     \\|   : |.\' .\''),nl,
                write('    |   |  \':  | | :  \' ;|   |   . |.   | \'_.\' :'),nl,
                write('    \'   :  ||  ; \' |  | \'\'   :  \'; |\'   ; : \\  |'),nl,
                write('    ;   |.\' :  | : ;  ; ||   |  | ; \'   | \'/  .\''),nl,
                write('    \'---\'   \'  :  `--\'   \\   :   /  |   :    /  '),nl,
                write('            :  ,      .-./   | ,\'    \\   \\ .\'   '),nl,                 
                write('             `--`----\'   `----\'       `---`     '),nl.

printHelp :-    write('Available commands: '), nl,
                write('   start.          -- start the game!'),nl,
                write('   help.           -- show the available commands!'),nl,
                write('   quit.           -- quit the game'),nl,
                write('   look.           -- look around you'),nl,
                write('   n. s. e. w.     -- move'),nl,
                write('   map.            -- look at the map, show the deadzone and the safezone'),nl,
                write('   take(Object).   -- pick up an object'),nl,
                write('   drop(Object).   -- drop an object'),nl,
                write('   use(Object).    -- use an object'),nl,                                
                write('   attack.         -- attack enemy that crosses your path'),nl,
                write('   status.         -- show your status'),nl,
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


                                                                                                                                                                