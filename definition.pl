/*FAKTA*/

/* MAXIMUM */
maxpHealth(100).
maxpArmor(100).
maxWeapon(10).
maxMagazine(10).
maxArmor(15).
maxMedicine(15).
maxEnemy(15).
maxAmmoPack(10).
maxBag(10).
maxMapSize(12).
maxEHealth(100).

/*WEAP0ON*/
weapon(orkom).
weapon(algeo).
weapon(tbfo).
weapon(logif).
weapon(matdis).
weapon(alstrukdat).

/*AMMO*/
ammoMax(orkom,7).
ammoMax(algeo,30).
ammoMax(tbfo,30).
ammoMax(logif,8).
ammoMax(matdis,30).
ammoMax(alstrukdat,10).

/*DAMAGE*/
damage(orkom,10).
damage(matdis,15).
damage(tbfo,20).
damage(algeo,30).
damage(logif,45).
damage(alstrukdat,60).

/*MAGAZINE*/
magazine(spekX1,1).
magazine(spekX3,3).
magazine(spekX5,5).
magazine(spekX8,8).

/*ARMOR*/
armor(webkuliah).
armor(stackoverflow).
armor(tubeskating).

/*ARMORHEALTH*/
armorHealth(webkuliah,10).
armorHealth(stackoverflow,25).
armorHealth(tubeskating,50).

/*MEDICINE*/
medicine(tolakangin).
medicine(madurasa).
medicine(kratingdaeng).
medicine(pizza).

/*RECOVER*/
recover(kratingdaeng,80).
recover(pizza,40).
recover(tolakangin,30).
recover(madurasa,15).


/*BAG*/
bag(kresek,5).
bag(totebag,8).
bag(backpack,10).

/*TILE*/
terrainLabel(a,'Kandom').
terrainLabel(b,'Class room').
terrainLabel(c,'Garden').
terrainLabel(d,'Annex').
terrainLabel(k,'Engi\' Kitchen').

/*SIGN*/
sign(Object,'W') :- weapon(Object).
sign(Object,'A') :- armor(Object).
sign(Object,'M') :- medicine(Object).
sign(Object,'O') :- magazine(Object,_).
sign(Object,'B') :- bag(Object,_).

/*RANDOM*/
dropChance(15).
resizeChance(10).
dropRandomBase(5).
dropRandomMax(9).