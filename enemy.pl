/* RULES UNTUK PERGERAKAN ENEMY */

canMoveE(Direction,X,Y):- Direction == n,isInside(X,Y-1).
canMoveE(Direction,X,Y):- Direction == e,isInside(X+1,Y).
canMoveE(Direction,X,Y):- Direction == s,isInside(X,Y+1).
canMoveE(Direction,X,Y):- Direction == w,isInside(X-1,Y).

moveE(e,X,Y) :- canMoveE(e,X,Y),retract(benda('E',Weapon,X,Y)),NewX is X+1, asserta(benda('E',Weapon,NewX,Y)).
moveE(w,X,Y) :- canMoveE(w,X,Y),retract(benda('E',Weapon,X,Y)),NewX is X-1, asserta(benda('E',Weapon,NewX,Y)).
moveE(n,X,Y) :- canMoveE(n,X,Y),retract(benda('E',Weapon,X,Y)),NewY is Y-1, asserta(benda('E',Weapon,X,NewY)).
moveE(s,X,Y) :- canMoveE(s,X,Y),retract(benda('E',Weapon,X,Y)),NewY is Y+1, asserta(benda('E',Weapon,X,NewY)).

moveAllEnemy :- findall(1,(benda('E',_,X,Y),moveEnemy(X,Y)),_).
            
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


deadAllEnemy:- findall(1,(benda('E',_,X,Y),deadEnemy(X,Y)),_).
deadEnemy(X,Y):- \+isInside(X,Y),retract(benda('E',_,X,Y)).

resolveAllEnemy:- findall(1,(benda('E',_,X,Y),resolveEnemy(X,Y)),_). 
resolveEnemy(X,Y):- benda('E',Weapon,X,Y),retractall(benda('E',_,X,Y)),asserta(benda('E',Weapon,X,Y)).

/*ATTACK ENEMY*/
attack :- locX(CurrX),locY(CurrY),enemyAttack,!,\+pWeapon(none),isCurrAmmoAvaiable,delCurrAmmo(1),
          benda('E',Weapon,CurrX,CurrY),retract(benda('E',_,CurrX,CurrY)),asserta(benda('W',Weapon,CurrX,CurrY)), write('You killed an enemy.').

enemyAttack:- locX(CurrX),locY(CurrY),benda('E',Weapon,CurrX,CurrY),damage(Weapon,Hit),
            pArmor(Armor),Armor>=Hit,!,retract(pArmor(_)),NewArmor is Armor-Hit,asserta(pArmor(NewArmor)),
            format('You have been attacked by %s and your armor has received %d damage.\n',[Weapon,Hit]).
enemyAttack:- locX(CurrX),locY(CurrY),benda('E',Weapon,CurrX,CurrY),damage(Weapon,Hit),
            pArmor(Armor),Armor>0,Armor<Hit,!,pHealth(HP),retract(pHealth(_)),retract(pArmor(_)),
            SisaAttack is Hit-Armor,asserta(pArmor(0)),
            NewHP is HP-SisaAttack,asserta(pHealth(NewHP)),
            format('You have been attacked by %s, your armor has gone, and your health is reduced by %d.\n',[Weapon,SisaAttack]).      
enemyAttack:- locX(CurrX),locY(CurrY),
                benda('E',Weapon,CurrX,CurrY),damage(Weapon,Hit),
            pHealth(HP),retract(pHealth(_)),
            NewHP is HP-Hit,asserta(pHealth(NewHP)),
            format('You have been attacked by %s, you were shot directly without using armor and received %d damage.\n',[Weapon,Hit]).
