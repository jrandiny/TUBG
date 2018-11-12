/* RULES */
setupGame:- consult('definition.pl'),
            consult('print.pl'),
            consult('movement.pl'),
            setupPemain,
            setupPeta,
            asserta(maxInventori(10)),
            set_seed(1).

setupPemain:-   asserta(pHealth(100)),
                asserta(pArmor(100)),
                asserta(pweapon(none)),
                random(2,11,_RandX),
                random(2,11,_RandY),
                asserta(locX(_RandX)),
                asserta(locY(_RandY)).
            
setupPeta:- asserta(peta([[-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-], 
                        [-,-,-,-,-,-,-,-,-,-]])),
            asserta(petaSize(10)).

getJo(X):-petaSize(X).    
/*
setupRandomObject:- petaSize(Size),
                    Base is 12-Size,
                    Max is (Base+Size)-1,
                    random(Base,Max,Rand). */
/*
while_randomObject(N):- N > 0,
                        asserta()    .
                        
                        */