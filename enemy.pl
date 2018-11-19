
/* RANDOM ENEMY*/
spawnRandomEnemy(Count):- findall(Object,weapon(Object),Bag),
                          while_randomEnemy(Bag,Count,'E').

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

canMoveE(Direction,X,Y):- Direction == n,isInside(X,Y-1).
canMoveE(Direction,X,Y):- Direction == e,isInside(X+1,Y).
canMoveE(Direction,X,Y):- Direction == s,isInside(X,Y+1).
canMoveE(Direction,X,Y):- Direction == w,isInside(X-1,Y).

moveE(e,X,Y) :- canMoveE(e,X,Y),retract(enemy('E',Weapon,X,Y,Health)),NewX is X+1, asserta(enemy('E',Weapon,NewX,Y,Health)).
moveE(w,X,Y) :- canMoveE(w,X,Y),retract(enemy('E',Weapon,X,Y,Health)),NewX is X-1, asserta(enemy('E',Weapon,NewX,Y,Health)).
moveE(n,X,Y) :- canMoveE(n,X,Y),retract(enemy('E',Weapon,X,Y,Health)),NewY is Y-1, asserta(enemy('E',Weapon,X,NewY,Health)).
moveE(s,X,Y) :- canMoveE(s,X,Y),retract(enemy('E',Weapon,X,Y,Health)),NewY is Y+1, asserta(enemy('E',Weapon,X,NewY,Health)).

moveAllEnemy :- findall(1,(enemy('E',_,X,Y,_),moveEnemy(X,Y)),_).           
moveEnemy(X,Y):- random(1,5,Temp),isSurroundPlayer(X,Y,Ret),Ret=:=0,
                 moveList(Temp,Sign),moveE(Sign,X,Y).

moveList(X,Y) :- X = 1, Y = n,!.
moveList(X,Y) :- X = 2, Y = e,!.
moveList(X,Y) :- X = 3, Y = s,!.
moveList(X,Y) :- X = 4, Y = w,!.

cekP(X,Y) :- locX(XP),locY(YP),X =:=XP,Y =:= YP.

isSurroundPlayer(X,Y,Ret) :- cekP(X-1,Y-1), Ret = 1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X,Y-1), Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X+1,Y-1),Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X-1,Y), Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X,Y), Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X+1,Y), Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X-1,Y+1), Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X,Y+1), Ret=1,!.
isSurroundPlayer(X,Y,Ret) :- cekP(X+1,Y+1),Ret=1,!.
isSurroundPlayer(_,_,0).


deadAllEnemy:- findall(1,(enemy('E',_,X,Y,_),deadEnemy(X,Y)),_).
deadEnemy(X,Y):- \+isInside(X,Y),retract(enemy('E',_,X,Y,_)).

resolveAllEnemy:- findall(1,(enemy('E',_,X,Y,_),resolveEnemy(X,Y)),_). 
resolveEnemy(X,Y):- findall(H,enemy('E',_,X,Y,H),List_Enemy),max_list(List_Enemy,MaxHealth),
                    enemy('E',Weapon,X,Y,MaxHealth),
                    retractall(enemy('E',_,X,Y,_)),asserta(enemy('E',Weapon,X,Y,MaxHealth)).

/*ATTACK ENEMY*/
minEHealth(X,Y,Count) :- enemy('E',Weapon,X,Y,Health),
                        NewHealth is Health-Count, NewHealth >0,
                        retract(enemy('E',Weapon,X,Y,Health)),
                        asserta(enemy('E',Weapon,X,Y,NewHealth)),
                        write('You hit the enemy, but it didn\'t kill them!'),!.
minEHealth(X,Y,Count) :- enemy('E',Weapon,X,Y,Health),
                        NewHealth is Health-Count, NewHealth =<0,
                        retract(enemy('E',Weapon,X,Y,Health)),
                        write('You killed an enemy.'),!.

attack :- locX(CurrX),locY(CurrY),enemyAttack,!,
          \+pWeapon(none),isCurrAmmoAvaiable,delCurrAmmo(1),
          enemy('E',_,CurrX,CurrY,_),
          pWeapon(Weapon), damage(Weapon,Hit),
          minEHealth(CurrX,CurrY,Hit).

enemyAttack:- locX(CurrX),locY(CurrY),enemy('E',Weapon,CurrX,CurrY,_),damage(Weapon,Hit),
            pArmor(Armor),Armor>=Hit,!,retract(pArmor(_)),NewArmor is Armor-Hit,asserta(pArmor(NewArmor)),
            format('You have been attacked by %s and your armor has received %d damage.\n',[Weapon,Hit]).
enemyAttack:- locX(CurrX),locY(CurrY),enemy('E',Weapon,CurrX,CurrY,_),damage(Weapon,Hit),
            pArmor(Armor),Armor>0,Armor<Hit,!,pHealth(HP),retract(pHealth(_)),retract(pArmor(_)),
            SisaAttack is Hit-Armor,asserta(pArmor(0)),
            NewHP is HP-SisaAttack,asserta(pHealth(NewHP)),
            format('You have been attacked by %s, your armor has gone, and your health is reduced by %d.\n',[Weapon,SisaAttack]).      
enemyAttack:- locX(CurrX),locY(CurrY),
                enemy('E',Weapon,CurrX,CurrY,_),damage(Weapon,Hit),
            pHealth(HP),retract(pHealth(_)),
            NewHP is HP-Hit,asserta(pHealth(NewHP)),
            format('You have been attacked by %s, you were shot directly without using armor and received %d damage.\n',[Weapon,Hit]).
