/*FAKTA*/

/* MAXIMUM */
maxpHealth(100).
maxpArmor(100).
maxWeapon(15).
maxMagazine(15).
maxArmor(15).
maxMedicine(15).
maxEnemy(9).
maxAmmoPack(10).
maxBag(10).

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
damage(awp,100).

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
medicine(bandage).
medicine(medkit).
medicine(firstaidkit).

/*RECOVER*/
recover(bandage,20).
recover(medkit,50).
recover(firstaidkit,90).

/*BAG*/
bag(baglv1,5).
bag(baglv2,8).
bag(baglv3,10).

/*TILE*/
terrainLabel(a,'ITB').
terrainLabel(b,'open field').
terrainLabel(c,'garden').
terrainLabel(d,'anex').

/*SIGN*/
sign(Object,'W') :- weapon(Object).
sign(Object,'A') :- armor(Object).
sign(Object,'M') :- medicine(Object).
sign(Object,'O') :- magazine(Object,_).
sign(Object,'B') :- bag(Object,_).

/*RANDOM*/
dropChance(10).
resizeChance(50).
dropRandomBase(5).
dropRandomMax(9).