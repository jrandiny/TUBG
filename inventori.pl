inventoriObjCount(Count) :- pInventori(none),Count = 0.
inventoriObjCount(Count) :- findall(1,pInventori(_),_L),length(_L,Count).

inventoriCount(Count) :- inventoriObjCount(ObjCount),pInventoriAmmo(AmmoCount), AmmoSpace is AmmoCount // 50, Count is AmmoSpace + ObjCount.

canPutInventori :- maxInventori(Max),inventoriCount(Count),Count<Max.

canTake(Object) :- canPutInventori,locX(CurrX),locY(CurrY),benda(_,Object,CurrX,CurrY).

addInventori(Object) :- pInventori(none),!,retract(pInventori(none)),assertz(pInventori(Object)).
addInventori(Object) :- canPutInventori, assertz(pInventori(Object)).

canAddAmmo(Count) :- maxInventori(Max),
                     inventoriObjCount(InvCount),
                     pInventoriAmmo(CurrAmmo), 
                     AmmoSpace is (CurrAmmo+Count)//50, 
                     Total is AmmoSpace+InvCount, 
                     Total<Max.

addAmmo(Count) :- canAddAmmo(Count), pInventoriAmmo(AmmoCount), NewAmmo is AmmoCount+

delInventori(Object) :- inventoriCount(Count), Count =:= 1,!, pInventori(Object), retractall(pInventori(_)),assertz(pInventori(none)).
delInventori(Object) :- pInventori(Object),retract(pInventori(Object)).

take(Object) :- canTake(Object),locX(CurrX),locY(CurrY), retract(benda(_,Object,CurrX,CurrY)),addInventori(Object). 

/* Kelompok USE */
use(Object) :- pInventori(Object), weapon(Object), pWeapon(none), retract(pWeapon(none)), assertz(pWeapon(Object)).
use(Object) :- pInventori(Object), weapon(Object), pWeapon(CurrWeapon), retract(pWeapon(CurrWeapon)), assertz(pWeapon(Object)), delInventori(Object),addInventori(CurrWeapon).

use(Object) :- pInventori(Object), medicine(Object), recover(Object,HP),pHealth(CurrHP),NewHP is CurrHP + HP,maxHealth(MH), NewHP > MH, !, retract(pHealth(_)),assertz(pHealth(MH))).
use(Object) :- pInventori(Object), medicine(Object), recover(Object,HP),pHealth(CurrHP),NewHP is CurrHP + HP,maxHealth(MH), NewHP <= MH, retract(pHealth(_)),assertz(pHealth(NewHP))).

use(Object) :- pInventori(Object), armor(Object), armorHealth(Object,HP)retract(pArmor(_)),assertz(pArmor(HP))).

use(Object) :- pInventori(Object), magazine(Object,Count), armorHealth(Object,HP)retract(pArmor(_)),assertz(pArmor(HP))).