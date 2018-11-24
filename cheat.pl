debug(enemy):- printEnemyMap(1,1).
debug(teleport(X,Y)) :- retract(locX(_)),retract(locY(_)),asserta(locX(X)),asserta(locY(Y)).
debug(oneEnemy):- retractall(enemy(_,_,_,_,_)),spawnRandomEnemy(1).
debug(trace) :- trace.
debug(hesoyam):- retract(pHealth(_)),retract(pArmor(_)),asserta(pHealth(100)),asserta(pArmor(100)).
debug(fullclip):- addCurrAmmo(9999).
debug(resizeMapTo(X)) :- retract(petaSize(_)),asserta(petaSize(X)).
debug(botKill):- retractall(enemy(_,_,_,_,_)).
debug(goodbyeTubes):- retract(pHealth(_)),retract(pArmor(_)),asserta(pHealth(0)),asserta(pArmor(0)),write('You commited suicide.').
debug(sayaSukaTubes):- write('Anda diamuk massa! Anda kehilangan setengah nyawa anda.'),pHealth(Health),NewHP is Health/2,retract(pHealth(_)),asserta(pHealth(NewHP)).
debug(botAdd(X)):- spawnRandomEnemy(X).
debug(professionalskit):- retract(pWeapon(_)),asserta(pWeapon(alstrukdat)).