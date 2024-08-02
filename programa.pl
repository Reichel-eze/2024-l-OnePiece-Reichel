% Practica Integradora: One Piece

% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart).

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto

impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).

impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).

impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).

impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).

impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).

impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).

impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo, 240000000).
impactoEnRecompensa(law, dressrosa, 60000000).

impactoEnRecompensa(bepo,sabaody,500).

impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).

impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

% Consideraciones generales:
% - Todos los predicados principales deben ser inversibles.
% - Es importante no repetir lógica, desarrollar soluciones declarativas y con buenas abstracciones.

% --------------------------------------------------------------------------------------------------- %

% PUNTO 1) 
% Relacionar a dos tripulaciones y un evento si ambas participaron 
% del mismo, lo cual sucede si dicho evento impactó en
% la recompensa de al menos un pirata de cada tripulación. Por ejemplo:
% - Debería cumplirse para las tripulaciones heart y sombreroDePaja 
% siendo dressrosa el evento del cual participaron ambas tripulaciones.
% - No deberían haber dos tripulaciones que participen de 
% llegadaAEastBlue, sólo los piratasDeArlong participaron de ese evento.

participaronDelMismoEvento(UnaTripulacion, OtraTripulacion, Evento) :-
    participoDeEvento(UnaTripulacion, Evento),
    participoDeEvento(OtraTripulacion, Evento),
    UnaTripulacion \= OtraTripulacion.

participoDeEvento(Tripulacion, Evento) :-
    tripulante(Personaje, Tripulacion),
    impactoEnRecompensa(Personaje, Evento, _).

% PUNTO 2)
% Saber quién fue el pirata que más se destacó en un evento, 
% en base al impacto que haya tenido su recompensa.
% En el caso del evento de dressrosa sería Zoro, porque su recompensa 
% subió en $200.000.000.

pirataMasDestacado(Pirata, Evento) :-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    forall((impactoEnRecompensa(OtroPirata, Evento, OtraRecompensa), Pirata \= OtroPirata),
    Recompensa >= OtraRecompensa).
    
%mayorMonto(Pirata1, Pirata2, Evento) :-
%    impactoEnRecompensa(Pirata1, Evento, Recompensa1),
%    impactoEnRecompensa(Pirata2, Evento, Recompensa2),
%    Pirata1 \= Pirata2,
%    Recompensa1 > Recompensa2.

pirataMasDestacadoNOT(Pirata, Evento) :-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    not((impactoEnRecompensa(OtroPirata, Evento, OtraRecompensa), 
    Pirata \= OtroPirata, OtraRecompensa > Recompensa)).

% PUNTO 3)
% Saber si un pirata pasó desapercibido en un evento, que se cumple 
% si su recompensa no se vio impactada por dicho evento a pesar de 
% que su tripulación participó del mismo.
% Por ejemplo esto sería cierto para Bepo para el evento dressrosa, 
% pero no para el evento sabaody por el cual su recompensa aumentó, 
% ni para eniesLobby porque su tripulación no participó.

pasoDesapercibido(Pirata, Evento) :-
    tripulante(Pirata, Tripulacion),             % existe el pirata, que pertenece a una tripulacion 
    participoDeEvento(Tripulacion, Evento),      % la tripulacion participa del evento
    not(impactoEnRecompensa(Pirata, Evento, _)). % PERO no existe una recompensa sobre ese Pirata con ese Evento

% PUNTO 4)
% Saber cuál es la recompensa total de una tripulación, que es 
% la suma de las recompensas actuales de sus miembros

recompensaTotal(Tripulacion, RecompensaTotal) :-
    tripulante(_, Tripulacion),   % para la Tripulacion ligada (por ej sombreroDePaja, busco las recompensas de cada uno de sus tripulantes)                                      % o participoDeEvento(Tripulacion, _),
    findall(RecompensaActual, (tripulante(Pirata, Tripulacion), recompensaActual(Pirata, RecompensaActual)), RecompensasTripulantes),
    sum_list(RecompensasTripulantes, RecompensaTotal).
    
recompensaActual(Pirata, RecompensaCaptura) :-
    tripulante(Pirata, _),
    findall(Recompensa, impactoEnRecompensa(Pirata, _, Recompensa), RecompensasEventos),
    sum_list(RecompensasEventos, RecompensaCaptura).

% Version mas simple, pero sin abstraccion (sin predicados auxiliares) --> SUMO TODO DE UNA
recompensaTotalV2(Tripulacion, RecompensaTotal) :-  
    tripulante(_, Tripulacion),                                      
    findall(Recompensa, (tripulante(Pirata, Tripulacion), impactoEnRecompensa(Pirata, _, Recompensa)), RecompensasTripulantes),
    sum_list(RecompensasTripulantes, RecompensaTotal).

% PUNTO 5)
% Saber si una tripulación es temible. Lo es si todos sus integrantes 
% son peligrosos o si la recompensa total de la tripulación supera 
% los $500.000.000. Consideramos peligrosos a piratas cuya recompensa 
% actual supere los $100.000.000

tripulacionTemible(Tripulacion) :-
    tripulante(_, Tripulacion),     % tengo que ligar Tripulacion, antes que se meta al forall!!
    forall(tripulante(Pirata, Tripulacion), peligroso(Pirata)).

tripulacionTemible(Tripulacion) :-
    recompensaTotal(Tripulacion, RecompensaTotal),  % recompensaTotal ya es inversible jeje!!
    RecompensaTotal > 500000000.

peligroso(Pirata) :-
    recompensaActual(Pirata, RecompensaActual),  % recompensaActual ya es inversible jeje!!
    RecompensaActual > 100000000.

% PUNTO 6)
% a) Necesitamos modificar la funcionalidad anterior, 
% porque ahora hay otra forma en la cual una persona puede 
% considerarse peligrosa: alguien que comió una fruta peligrosa 
% se considera peligroso, independientemente de cuál sea el precio
% sobre su cabeza.

% EXTENSION DEL PREDICADO PELIGROSO!!

peligroso(Pirata) :-
    comio(Pirata, Fruta),
    frutaPeligrosa(Fruta).

%comio(Pirata, FrutaQueComio).
%comio(Pirata, TipoFruta()).
comio(luffy, paramecia(gomugomu)).
comio(buggy, paramecia(barabara)).
comio(law, paramecia(opeope)).
comio(chopper, zoan(hitohito, humano)).
comio(lucci, zoan(nekoneko, leopardo)).
comio(smoker, logia(mokumoku, humo)).

%frutaPeligrosa(Fruta).
frutaPeligrosa(paramecia(opeope)).                          % es un hecho, esta fruta de este tipo es peligrosa!!
frutaPeligrosa(zoan(_, Especie)) :- especieFeroz(Especie).  % para ser peligrosa tiene que convertirse en una especie feroz!!
frutaPeligrosa(logia(_,_)).                                 % solo por ser una fruta de tipo logia es peligrosa!!

especioFeroz(lobo).
especieFeroz(leopardo).
especieFeroz(anaconda).

% ESTO NO SE PIDE:
nombreDeLaFruta(paramecia(Nombre), Nombre).
nombreDeLaFruta(zoan(Nombre, _), Nombre).
nombreDeLaFruta(logia(Nombre, _), Nombre).

% Sabemos que:
% - Luffy comió la fruta gomugomu de tipo paramecia, que no se considera peligrosa.
% - Buggy comió la fruta barabara de tipo paramecia, que no se considera peligrosa.
% - Law comió la fruta opeope de tipo paramecia, que se considera peligrosa.
% - Chopper comió una fruta hitohito de tipo zoan que lo convierte en humano.
% - Nami, Zoro, Ussop, Sanji, Bepo, Arlong y Hatchan no comieron frutas del diablo.  --> NO AGREGO NADA DEBIDO AL UNIVERSO CERRADO ES FALSO!!
% - Lucci comió una fruta nekoneko de tipo zoan que lo convierte en leopardo.
% - Smoker comió la fruta mokumoku de tipo logia que le permite transformarse en humo.

% b) Justificar las decisiones de modelado tomadas para cumplir con 
% lo pedido, tanto desde el punto de vista de la definición como del 
% uso de los nuevos predicados.

% Empezando con el predicado peligroso/1, queriamos saber si un Pirata
% comio una Fruta y dicha Fruta es Peligrosa. 

% Independientemente de la forma que tenga la fruta, 
% el predicado frutaPeligrosa me puedo decir si es o no 
% peligrosa dicha fruta, este mismo NO es necesario que sea inversible.
% Le puedo preguntar si una fruta es peligrosa o NO, pero no puedo
% preguntar Que Frutas son peligrosas como incognita/variable

% Se puede ver el polimorfismo aplicado en comio/2 y 
% en frutaPeligrosa/1. Tambien en especioFeroz con un patterMatching

% Los piratas que no comieron frutas, no son representados en la base
% de conocimientos, gracias al concepto de universo cerrado, en el cual
% solo explicitamos aquellas cosas que son ciertas/verdaderas!!. Ademas
% tambien lo podemos observar en aquellas frutas que NO son peligrosas,
% las cuales tampoco fueron explicitadas en el codigo

% PUNTO 7)
% Saber si una tripulación es de piratas de asfalto, 
% que se cumple si ninguno de sus miembros puede nadar.

esDePiratasDeAsfalto(Tripulacion) :-
    tripulante(_, Tripulacion),         % pa quie sea inversible
    forall(tripulante(Tripulante, Tripulacion), not(puedeNadar(Tripulante))).

esDePiratasDeAsfaltoNOT(Tripulacion) :-
    tripulante(_, Tripulacion),
    not((tripulante(Tripulante, Tripulacion), puedeNadar(Tripulante))). % NO existe ningun tripulante de la tripulacion que pueda nadar!!

puedeNadar(Pirata) :-        % un Pirata puedeNadar si no consumio ninguna fruta!!
    tripulante(Pirata, _),   % pa que sea inversible jeje!!
    not(comio(Pirata,_)).