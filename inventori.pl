inventoriObjCount(Count) :- pInventori(none),Count = 0.
inventoriObjCount(Count) :- findall(1,pInventori(_),_L),length(_L,Count).

inventoriCount(Count) :- inventoriObjCount(ObjCount),pInventoriAmmo(AmmoCount), maxAmmoPack(MaxAmmo),AmmoSpace is ceiling(AmmoCount / MaxAmmo), Count is AmmoSpace + ObjCount.

canPutInventori :- maxInventori(Max),inventoriCount(Count),Count<Max.

canTake(Object) :- canPutInventori,locX(CurrX),locY(CurrY),benda(Sign,Object,CurrX,CurrY),Sign \== 'E'.

addInventori(Object) :- pInventori(none),!,retract(pInventori(none)),assertz(pInventori(Object)).
addInventori(Object) :- canPutInventori, assertz(pInventori(Object)).

canAddAmmo(Count) :- maxInventori(Max),
                     inventoriObjCount(InvCount),
                     pInventoriAmmo(CurrAmmo), 
                     maxAmmoPack(MaxAmmo),
                     AmmoSpace is ceiling(CurrAmmo / MaxAmmo), 
                     Total is AmmoSpace+InvCount, 
                     Total<Max.

addAmmo(Count) :- canAddAmmo(Count),
                  pInventoriAmmo(AmmoCount),
                  NewAmmo is AmmoCount+Count,
                  retractall(pInventoriAmmo(_)),
                  assertz(pInventoriAmmo(NewAmmo)).

delAmmo(Count) :- pInventoriAmmo(OldAmmo),
                  NewAmmo is OldAmmo - Count,
                  retractall(pInventoriAmmo(_)),
                  assertz(pInventoriAmmo(NewAmmo)).

addCurrAmmo(Count) :- pCurrAmmo(CurrAmmo),
                      NewAmmo is CurrAmmo+Count,
                      retractall(pCurrAmmo(_)),
                      assertz(pCurrAmmo(NewAmmo)).

delCurrAmmo(Count) :- pCurrAmmo(CurrAmmo),
                      NewAmmo is CurrAmmo - Count,
                      retractall(pCurrAmmo(_)),
                      assertz(pCurrAmmo(NewAmmo)).

isCurrAmmoAvaiable :- pCurrAmmo(CurrAmmo),
                      CurrAmmo >0.

delInventori(Object) :- inventoriObjCount(Count),
                        Count =:= 1,!,
                        pInventori(Object),
                        retract(pInventori(Object)),
                        assertz(pInventori(none)).

delInventori(Object) :- pInventori(Object),
                        retract(pInventori(Object)).

take(Object) :- bag(Object,MaxBag),
                maxInventori(MaxInventori),
                MaxBag<MaxInventori,!,
                write('You can\'t take bag with lower level.').
take(Object) :- bag(Object,MaxBag), 
                maxInventori(MaxInventori),
                MaxBag>=MaxInventori,!,
                locX(CurrX),locY(CurrY),
                retract(benda('B',Object,CurrX,CurrY)),
                retract(maxInventori(_)),
                asserta(maxInventori(MaxBag)), 
                format('You take and equip %s.', [Object]).
take(Object) :- magazine(Object,Count),
                canAddAmmo(Count),
                locX(CurrX),locY(CurrY),
                retract(benda(_,Object,CurrX,CurrY)),
                addAmmo(Count),
                printTake(Object),!. 
take(Object) :- \+magazine(Object,_), 
                \+canTake(Object),!,write('Inventory full.').
take(Object) :- locX(CurrX),locY(CurrY),
                retract(benda(_,Object,CurrX,CurrY)),
                addInventori(Object),
                printTake(Object).

printTake(Object) :- write('You took '),write(Object).

/* Kelompok USE */
use(Object) :- pInventori(Object), weapon(Object), pWeapon(none), 
               retract(pWeapon(none)),delInventori(Object), 
               assertz(pWeapon(Object)),printUseGun(Object),!.
use(Object) :- pInventori(Object), weapon(Object), pWeapon(CurrWeapon),
               retract(pWeapon(CurrWeapon)), assertz(pWeapon(Object)),
               delInventori(Object),addInventori(CurrWeapon),printUseGun(Object),
               pCurrAmmo(CA),delCurrAmmo(CA).

use(Object) :- pInventori(Object), medicine(Object), recover(Object,HP),pHealth(CurrHP),NewHP is CurrHP + HP,maxpHealth(MH), NewHP > MH, !, retract(pHealth(_)),assertz(pHealth(MH)),delInventori(Object),printUseMedicine(Object).
use(Object) :- pInventori(Object), medicine(Object), recover(Object,HP),pHealth(CurrHP),NewHP is CurrHP + HP,maxpHealth(MH), NewHP =< MH, retract(pHealth(_)),assertz(pHealth(NewHP)),delInventori(Object),printUseMedicine(Object).

use(Object) :- pInventori(Object), armor(Object), armorHealth(Object,HP),pArmor(CurrArmor),NewArmor is HP + CurrArmor,maxpArmor(MaxArmor),
                NewArmor > MaxArmor,!,retract(pArmor(_)),assertz(pArmor(MaxArmor)),delInventori(Object),write('Your armor is full.').
use(Object) :- pInventori(Object), armor(Object), armorHealth(Object,HP),pArmor(CurrArmor),NewArmor is HP + CurrArmor,maxpArmor(MaxArmor),
                NewArmor=<MaxArmor,retract(pArmor(_)),assertz(pArmor(NewArmor)),delInventori(Object),printUseArmor(Object).

use(ammo) :- pWeapon(CurrWeapon),
             CurrWeapon == none,write('No weapon.'),!.
use(ammo) :- pInventoriAmmo(InvAmmo), 
             pWeapon(Weapon),
             pCurrAmmo(CurrAmmo),
             ammoMax(Weapon,MA),
             Selisih is MA - CurrAmmo,
             Sisa is InvAmmo - Selisih,
             useAmmo(Selisih,Sisa).

useAmmo(0,_) :- write('Still full.').
useAmmo(Selisih,Sisa) :- Sisa >=0,delAmmo(Selisih),addCurrAmmo(Selisih),write('Reloaded.'),!.
useAmmo(_,_) :- pInventoriAmmo(Add),retractall(pInventoriAmmo(Add)),assertz(pInventoriAmmo(0)),addCurrAmmo(Add),write('Reloaded.').

printUseGun(Object) :- write(Object), write(' is equipped. '),printAmmoCount.
printUseArmor(Object) :- write(Object), write(' is equipped. ').
printUseMedicine(Object) :- write(Object), write(' is used. ').

printAmmoCount:- pCurrAmmo(Count),Count =:= 0, write('But the gun\'s empty, mate.'),!.
printAmmoCount:- pCurrAmmo(Count), format('with %d ammo left.',[Count]).

drop(Object) :- pWeapon(Object), retract(pWeapon(Object)),pCurrAmmo(CA),delCurrAmmo(CA),asserta(pWeapon(none)), locX(CurrX),locY(CurrY), asserta(benda('W',Object,CurrX,CurrY)),printDrop(Object),!.
drop(Object) :- pInventori(Object),locX(CurrX),locY(CurrY), delInventori(Object), sign(Object,Sign),asserta(benda(Sign,Object,CurrX,CurrY)),printDrop(Object).

printDrop(Object) :- write(Object), write(' is dropped.').