/* KELOMPOK INVENTORI */
/* rule untuk menghitung jumlah inventori sekarang tanpa ammo */
inventoriObjCount(Count) :- pInventori(none),Count = 0.
inventoriObjCount(Count) :- findall(1,pInventori(_),_L),length(_L,Count).

/* rule untuk menghitung jumlah inventori termasuk jumlah ammo */
inventoriCount(Count) :- inventoriObjCount(ObjCount),
                         pInventoriAmmo(AmmoCount), 
                         maxAmmoPack(MaxAmmo),
                         AmmoSpace is ceiling(AmmoCount / MaxAmmo),
                         Count is AmmoSpace + ObjCount.

/* predikat yang menyatakan masih bisa barang dimasukkan ke inventori */
canPutInventori(object) :-  maxInventori(Max),
                            inventoriCount(Count),
                            Count<Max.

canPutInventori(ammo,Count)   :- maxInventori(Max),
                                 inventoriObjCount(InvCount),
                                 pInventoriAmmo(CurrAmmo), 
                                 maxAmmoPack(MaxAmmo),
                                 AmmoSpace is ceiling((CurrAmmo+Count) / MaxAmmo), 
                                 Total is AmmoSpace+InvCount, 
                                 Total=<Max.

/* predikat yang menyatakan apakah kita dapat menjalankan take */
canTake(Object) :- canPutInventori(object),
                   locX(CurrX),locY(CurrY),
                   benda(_,Object,CurrX,CurrY).

/* rule untuk menambahkan suatu objek ke inventori */
addInventori(Object) :- pInventori(none),!,
                        retract(pInventori(none)),
                        assertz(pInventori(Object)).
addInventori(Object) :- canPutInventori(object), assertz(pInventori(Object)).

/* rule untuk mengurangi suatu objek dari inventori */
delInventori(Object) :- inventoriObjCount(Count),
                        Count =:= 1,!,
                        pInventori(Object),
                        retract(pInventori(Object)),
                        assertz(pInventori(none)).
delInventori(Object) :- pInventori(Object),
                        retract(pInventori(Object)).

/* KELOMPOK AMMO MANAGEMENT */
/* predikat yang menyatakan apakah dapat menambahkan ammo ke inventori */

/* rule untuk menambahkan ammo ke inventori */
addAmmo(Count) :- canPutInventori(ammo,Count),
                  pInventoriAmmo(AmmoCount),
                  NewAmmo is AmmoCount+Count,
                  retractall(pInventoriAmmo(_)),
                  assertz(pInventoriAmmo(NewAmmo)).

/* rule untuk mengurangi ammo dari inventori */
delAmmo(Count) :- pInventoriAmmo(OldAmmo),
                  NewAmmo is OldAmmo - Count,
                  retractall(pInventoriAmmo(_)),
                  assertz(pInventoriAmmo(NewAmmo)).

/* rule untuk menambahkan ammo pada player */
addCurrAmmo(Count) :- pCurrAmmo(CurrAmmo),
                      NewAmmo is CurrAmmo+Count,
                      retractall(pCurrAmmo(_)),
                      assertz(pCurrAmmo(NewAmmo)).

/* rule untuk mengurangi ammo pada player */
delCurrAmmo(Count) :- pCurrAmmo(CurrAmmo),
                      NewAmmo is CurrAmmo - Count,
                      retractall(pCurrAmmo(_)),
                      assertz(pCurrAmmo(NewAmmo)).

/* predikat yang menyatakan apakah ada ammo di player */
isCurrAmmoAvaiable :- pCurrAmmo(CurrAmmo),
                      CurrAmmo >0.


/* KELOMPOK TAKE */
/* rule untuk mengambil objek */
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
take(Object) :- magazine(Object,Count),!,
                canPutInventori(ammo,Count),
                locX(CurrX),locY(CurrY),
                retract(benda(_,Object,CurrX,CurrY)),
                addAmmo(Count),
                printTake(Object),!. 
take(Object) :- \+magazine(Object,_), weapon(Object),armor(Object),medicine(Object),
                \+canTake(Object),!,write('Inventory full.').
take(Object) :- locX(CurrX),locY(CurrY),
                retract(benda(_,Object,CurrX,CurrY)),
                addInventori(Object),
                printTake(Object).

/* rule untuk menuliskan apa yang diambil ke layar */
printTake(Object) :- format('You took %s.',[Object]).

/* KELOMPOK HELPER USE */
/* rule yang membantu mengevaluasi use */
evalMedicine(Object,Evaluated) :- pInventori(Object), 
                                  recover(Object,HP),
                                  pHealth(CurrHP),
                                  NewHP is CurrHP + HP,
                                  maxpHealth(MH), 
                                  NewHP =< MH,
                                  Evaluated is NewHP, !.
evalMedicine(_,Evaluated) :- maxpHealth(MH),Evaluated is MH.

evalArmor(Object,Evaluated) :- armorHealth(Object,HP),
                               pArmor(CurrArmor),
                               NewArmor is HP + CurrArmor,
                               maxpArmor(MaxArmor),
                               NewArmor=<MaxArmor,
                               Evaluated is NewArmor.
evalArmor(_,Evaluated) :- maxpArmor(Evaluated).

/* Kelompok USE */
/* rule untuk menjalankan command use */
/* use weapon */
use(Object) :- pInventori(Object), weapon(Object), pWeapon(none), 
               retract(pWeapon(none)),delInventori(Object), 
               assertz(pWeapon(Object)),printUseGun(Object),!.
use(Object) :- pInventori(Object), weapon(Object), pWeapon(CurrWeapon),
               retract(pWeapon(CurrWeapon)), assertz(pWeapon(Object)),
               delInventori(Object),addInventori(CurrWeapon),
               pCurrAmmo(CA),delCurrAmmo(CA),printUseGun(Object).
/* use medicine */
use(Object) :- medicine(Object),
               evalMedicine(Object,Res),
               retract(pHealth(_)),
               assertz(pHealth(Res)),
               delInventori(Object),
               printUseMedicine(Object).
/* use armor */
use(Object) :- pInventori(Object), armor(Object), 
               evalArmor(Object,NewArmor),
               retract(pArmor(_)),
               assertz(pArmor(NewArmor)),
               delInventori(Object),
               printUseArmor(Object).
/* cek use ammo */
use(ammo) :- pWeapon(CurrWeapon),
             CurrWeapon == none,write('No weapon.'),!.
use(ammo) :- pInventoriAmmo(InvAmmo), 
             pWeapon(Weapon),
             pCurrAmmo(CurrAmmo),   
             ammoMax(Weapon,MA),
             Selisih is MA - CurrAmmo,
             Sisa is InvAmmo - Selisih,
             useAmmo(Selisih,Sisa).

/* rule yang  menggunakan ammo*/
useAmmo(0,_) :- write('Still full.').
useAmmo(Selisih,Sisa) :- Sisa >=0,delAmmo(Selisih),
                         addCurrAmmo(Selisih),write('Reloaded.'),!.
useAmmo(_,_) :- pInventoriAmmo(Add),
                retractall(pInventoriAmmo(Add)),
                assertz(pInventoriAmmo(0)),
                addCurrAmmo(Add),
                write('Reloaded.').
/* Kelompok print use */
printUseGun(Object) :- write(Object),
                       write(' is equipped. '),
                       printAmmoCount.
printUseArmor(Object) :- write(Object),
                         write(' is equipped. ').
printUseMedicine(Object) :- write(Object),
                            write(' is used. ').
/* print jumlah ammo sekarang */
printAmmoCount:- pCurrAmmo(Count),Count =:= 0,
                 write('But the gun\'s empty, mate.'),!.
printAmmoCount:- pCurrAmmo(Count),
                 format('with %d ammo left.',[Count]).

/* KELOMPOK DROP */
/* drop weapon di tangan */
drop(Object) :- pWeapon(Object), 
                retract(pWeapon(Object)),
                pCurrAmmo(CA),delCurrAmmo(CA),
                asserta(pWeapon(none)),
                locX(CurrX),locY(CurrY),
                asserta(benda('W',Object,CurrX,CurrY)),
                printDrop(Object),!. 
/* drop objek di inventori */                                                                                                                                                                                                
drop(Object) :- pInventori(Object),
                locX(CurrX),locY(CurrY),
                delInventori(Object),
                sign(Object,Sign),
                asserta(benda(Sign,Object,CurrX,CurrY)),
                printDrop(Object).
/* print objek yang di drop */
printDrop(Object) :- write(Object),
                     write(' is dropped.').