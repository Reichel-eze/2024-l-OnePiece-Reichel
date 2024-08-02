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