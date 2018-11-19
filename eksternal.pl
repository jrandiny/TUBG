/* KELOMPOK SAVE */
saveLoc(Stream) :-
    locX(X),locY(Y),format(Stream,'locX(%d).',[X]),nl(Stream),format(Stream,'locY(%d).',[Y]),nl(Stream).

savePetaSize(Stream) :-
    petaSize(X),format(Stream,'petaSize(%d).',[X]),nl(Stream).

savePeta(Stream) :-
    peta(X),write(Stream,'peta('),write(Stream,X),write(Stream,').'),nl(Stream).

saveBenda(Stream) :-
    benda(A,B,C,D),format(Stream,'benda(\'%s\',%s,%d,%d).',[A,B,C,D]),nl(Stream),fail
    ;true.

saveInventori(Stream) :-
    pInventori(X),format(Stream,'pInventori(%s).',[X]),nl(Stream),fail
    ;true.

savePlayer(Stream) :-
    pHealth(Health),pArmor(Armor),pWeapon(Weapon),pInventoriAmmo(IAmmo),pCurrAmmo(CurrAmmo),
    format(Stream,'pHealth(%d).',[Health]),nl(Stream),
    format(Stream,'pArmor(%d).',[Armor]),nl(Stream),
    format(Stream,'pWeapon(%s).',[Weapon]),nl(Stream),
    format(Stream,'pInventoriAmmo(%d).',[IAmmo]),nl(Stream),
    format(Stream,'pCurrAmmo(%d).',[CurrAmmo]),nl(Stream).

saveMaxInventori(Stream) :-
    maxInventori(Max),format(Stream,'maxInventori(%d).',[Max]),nl(Stream).

saveEnemy(Stream) :-
    enemy(A,B,C,D,E),format(Stream,'enemy(\'%s\',%s,%d,%d,%d).',[A,B,C,D,E]),nl(Stream),fail
    ;true.

saveAll(NamaFile) :- open(NamaFile,write,Stream),
           (
               saveLoc(Stream),savePetaSize(Stream),saveBenda(Stream),savePeta(Stream),saveInventori(Stream),savePlayer(Stream),saveMaxInventori(Stream),saveEnemy(Stream)
           ),
           close(Stream).

/* KELOMPOK LOAD */
removeAll :-
    retractall(locX(_)),retractall(locY(_)),retractall(petaSize(_)),retractall(peta(_)),retractall(benda(_,_,_,_)),
    retractall(pHealth(_)),retractall(pArmor(_)),retractall(pWeapon(_)),retractall(pInventoriAmmo(_)),retractall(pCurrAmmo(_)),
    retractall(pInventori(_)),retractall(enemy(_,_,_,_,_)).

readAll(Stream) :- at_end_of_stream(Stream).
readAll(Stream) :- \+(at_end_of_stream(Stream)),
                   read(Stream,X),assertz(X),readAll(Stream).

loadAll(NamaFile) :- open(NamaFile, read, Stream),(
           removeAll,readAll(Stream)
           ),
           close(Stream).
    
