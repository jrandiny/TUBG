
/* RANDOM ENEMY*/
/* me-random kemunculan enemy sebanyak Count */
spawnRandomEnemy(Count):- findall(Object,weapon(Object),Bag),
                          while_randomEnemy(Bag,Count,'E').
/* random enemy yang looping, diulang sebayak N kali */
while_randomEnemy(_,0,_).
while_randomEnemy(L,N,Sign):- N > 0,
                            getTopLeft(X1,Y1),
                            getBottomRight(X2,Y2),
                            NewX is X2 +1,
                            NewY is Y2+1,
                            random(X1,NewX,LocX),
                            random(Y1,NewY,LocY),
                            length(L,TmpCount),
                            Count is TmpCount+1,
                            random(1,Count,Idx),
                            nth(Idx,L,Object),
                            maxEHealth(MaxHealth),
                            asserta(enemy(Sign,Object,LocX,LocY,MaxHealth)),
                            M is N-1,
                            !,while_randomEnemy(L,M,Sign).

/* RULES UNTUK PERGERAKAN ENEMY */
/* mengecek apakah enemy dapat move */
canMoveE(Direction,X,Y):- Direction == n,isInside(X,Y-1).
canMoveE(Direction,X,Y):- Direction == e,isInside(X+1,Y).
canMoveE(Direction,X,Y):- Direction == s,isInside(X,Y+1).
canMoveE(Direction,X,Y):- Direction == w,isInside(X-1,Y).

/* menggerakkan enemy ke arah yang dituju */
moveE(e,X,Y) :- canMoveE(e,X,Y),
                retract(enemy('E',Weapon,X,Y,Health)),
                NewX is X+1, 
                asserta(enemy('E',Weapon,NewX,Y,Health)).
moveE(w,X,Y) :- canMoveE(w,X,Y),
                retract(enemy('E',Weapon,X,Y,Health)),
                NewX is X-1, 
                asserta(enemy('E',Weapon,NewX,Y,Health)).
moveE(n,X,Y) :- canMoveE(n,X,Y),
                retract(enemy('E',Weapon,X,Y,Health)),
                NewY is Y-1, 
                asserta(enemy('E',Weapon,X,NewY,Health)).
moveE(s,X,Y) :- canMoveE(s,X,Y),
                retract(enemy('E',Weapon,X,Y,Health)),
                NewY is Y+1, 
                asserta(enemy('E',Weapon,X,NewY,Health)).

/* rule untuk menggerakkan semua enemy */
moveAllEnemy :- findall(1,(enemy('E',_,X,Y,_),
                moveEnemy(X,Y)),_).
/* bagian rule yang me-random arah gerakan enemy dan enemy hanya bergerak jika tidak dekat player */
moveEnemy(X,Y):- random(1,5,Temp),
                 \+(isSurroundPlayer(X,Y)),
                 moveList(Temp,Sign),
                 moveE(Sign,X,Y).

/* daftar arah pergerakan */
moveList(1,n).
moveList(2,e).
moveList(3,s).
moveList(4,w).

/* rule mengecek apakah X,Y adalah posisi player sekarang */
cekP(X,Y) :- locX(XP),locY(YP),
             X =:=XP,Y =:= YP.

/* rule mengecek apakah X,Y ada di sekitar player */
isSurroundPlayer(X,Y) :- cekP(X-1,Y-1),!.
isSurroundPlayer(X,Y) :- cekP(X,Y-1),!.
isSurroundPlayer(X,Y) :- cekP(X+1,Y-1),!.
isSurroundPlayer(X,Y) :- cekP(X-1,Y),!.
isSurroundPlayer(X,Y) :- cekP(X,Y),!.
isSurroundPlayer(X,Y) :- cekP(X+1,Y),!.
isSurroundPlayer(X,Y) :- cekP(X-1,Y+1),!.
isSurroundPlayer(X,Y) :- cekP(X,Y+1),!.
isSurroundPlayer(X,Y) :- cekP(X+1,Y+1),!.

/* RULES PENGURANGAN ENEMY */
/* rule untuk mengecek semua enemy mati karena terkena deadzone */
deadAllEnemy:- findall(1,(enemy('E',_,X,Y,_),
               deadEnemy(X,Y)),_).
/* rule yang menghilangkan enemy jika di luar batas area (dalam deadzone) */
deadEnemy(X,Y):- \+isInside(X,Y),
                 retract(enemy('E',_,X,Y,_)).

/* rule untuk mengecek semua enemy yang bertemu di satu tempat yang sama */
resolveAllEnemy:- findall(1,(enemy('E',_,X,Y,_),
                  resolveEnemy(X,Y)),_). 
/* rule untuk menghilangkan enemy yang ada di temmpat yang sama dan menyisakan enemy dengan nyawa terbanyak */
resolveEnemy(X,Y):- findall(H,enemy('E',_,X,Y,H),List_Enemy),
                    max_list(List_Enemy,MaxHealth),
                    enemy('E',Weapon,X,Y,MaxHealth),
                    retractall(enemy('E',_,X,Y,_)),
                    asserta(enemy('E',Weapon,X,Y,MaxHealth)).

/* RULES ATTACK ENEMY*/
/* rule  untuk mengurangi health enemy*/
minEHealth(X,Y,Count) :- enemy('E',Weapon,X,Y,Health),
                         NewHealth is Health-Count,
                         NewHealth >0,
                         retract(enemy('E',Weapon,X,Y,Health)),
                         asserta(enemy('E',Weapon,X,Y,NewHealth)),
                         write('Your friend suffer energy loss, but he is still standing!'),!.
minEHealth(X,Y,Count) :- enemy('E',Weapon,X,Y,Health),
                         NewHealth is Health-Count,
                         NewHealth =<0,
                         retract(enemy('E',Weapon,X,Y,Health)),
                         assertz(benda('W',Weapon,X,Y)),
                         write('You successfuly drained your friend\'s energy. He fainted.'),!.

/* rule untuk menyatakan player attack ke enemy */
attack :- \+pWeapon(none),
          locX(CurrX),locY(CurrY),
          enemyAttack,
          isCurrAmmoAvaiable,delCurrAmmo(1),
          enemy('E',_,CurrX,CurrY,_),
          pWeapon(Weapon),
          damage(Weapon,Hit),
          minEHealth(CurrX,CurrY,Hit),!.
attack :- write('You don\'t have any tubes inspiration!').

/* rule untuk enemy menyerang player */
enemyAttack:- locX(CurrX),locY(CurrY),
              enemy('E',Weapon,CurrX,CurrY,_),
              damage(Weapon,Hit),
              pArmor(Armor),Armor>=Hit,!,
              retract(pArmor(_)),
              NewArmor is Armor-Hit,
              asserta(pArmor(NewArmor)),
              format('You have been given %s and your reference material is decreased by %d.\n',[Weapon,Hit]).
enemyAttack:- locX(CurrX),locY(CurrY),
              enemy('E',Weapon,CurrX,CurrY,_),
              damage(Weapon,Hit),
              pArmor(Armor),
              Armor>0,Armor<Hit,!,
              pHealth(HP),
              retract(pHealth(_)),retract(pArmor(_)),
              SisaAttack is Hit-Armor,asserta(pArmor(0)),
              NewHP is HP-SisaAttack,asserta(pHealth(NewHP)),
              format('You have been given %s, you lose your reference material, and your energy is reduced by %d.\n',[Weapon,SisaAttack]).      
enemyAttack:- locX(CurrX),locY(CurrY),
              enemy('E',Weapon,CurrX,CurrY,_),
              damage(Weapon,Hit),
              pHealth(HP),retract(pHealth(_)),
              NewHP is HP-Hit,asserta(pHealth(NewHP)),
              format('You have been given %s, you had no reference for that and suffer %d energy loss.\n',[Weapon,Hit]).
enemyAttack.
