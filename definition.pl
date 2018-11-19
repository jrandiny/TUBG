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
weapon(deagle).
weapon(ak47).
weapon(m4a1).
weapon(shotgun).
weapon(uzi).
weapon(awp).

/*AMMO*/
ammoMax(deagle,7).
ammoMax(ak47,30).
ammoMax(m4a1,30).
ammoMax(shotgun,8).
ammoMax(uzi,30).
ammoMax(awp,10).

/*DAMAGE*/
damage(deagle,10).
damage(ak47,25).
damage(m4a1,20).
damage(shotgun,45).
damage(uzi,15).
damage(awp,60).

/*MAGAZINE*/
magazine(magazinelv1,5).
magazine(magazinelv2,8).
magazine(magazinelv3,10).

/*ARMOR*/
armor(armorlv1).
armor(armorlv2).
armor(armorlv3).
armor(helmetlv1).
armor(helmetlv2).
armor(helmetlv3).

/*ARMORHEALTH*/
armorHealth(armorlv1,10).
armorHealth(armorlv2,25).
armorHealth(armorlv3,50).
armorHealth(helmetlv1,10).
armorHealth(helmetlv2,25).
armorHealth(helmetlv3,50).

/*MEDICINE*/
medicine(tolakangin).
medicine(madurasa).
medicine(airminum600ml).

/*RECOVER*/
recover(tolakangin,20).
recover(madurasa,50).
recover(airminum600ml,90).

/*BAG*/
bag(baglv1,5).
bag(baglv2,8).
bag(baglv3,10).

/*TILE*/
terrainLabel(a,'ITB').
terrainLabel(b,'open field').
terrainLabel(c,'garden').
terrainLabel(d,'anex').
terrainLabel(k,'kantin engi').

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