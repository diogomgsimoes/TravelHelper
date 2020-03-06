
menu:-
    repeat,
    write('------------------------------------------'),nl,
    write('  MENU 1: Gestão da base de conhecimento  '),nl,
    write('------------------------------------------'),nl,
    write('   1.1 Adicionar local                    '),nl,
    write('   1.2 Adicionar meio  de transporte      '),nl,
    write('   1.3 Adicionar foco  de interesse       '),nl,
    write('   1.4 Adicionar ligação entre locais     '),nl,
    write('   1.5 Alterar local                      '),nl,
    write('   1.6 Alterar meio de transporte         '),nl,
    write('   1.7 Alterar foco de interesse          '),nl,
    write('   1.8 Alterar ligação entre locais       '),nl,
    write('   1.9 Remover local                      '),nl,
    write('   1.10 Remover meio de transporte        '),nl,
    write('   1.11 Remover foco de interesse         '),nl,
    write('   1.12 Remover ligação entre locais      '),nl,
    write('   1.13 Consulta à base de conhecimento   '),nl,
    write('   1.14 Sair                              '),nl,
    write('------------------------------------------'),nl,
    write('O que pretende fazer?                     '),nl,
    read(Choice), Choice>0, Choice =<14,
    doit(Choice), Choice=14, !.

secondary_menu:-
    repeat,
    write('-----------------------------------------------------------------------------------------'),nl,
    write('  MENU 2: Consultas à base de conhecimento                                               '),nl,
    write('-----------------------------------------------------------------------------------------'),nl,
    write('  2.15 Listar cidades                                                                    '),nl,
    write('  2.16 Listar cidades por país                                                           '),nl,
    write('  2.17 Listar cidades por foco de interesse                                              '),nl,
    write('  2.18 Listar ligações e transportes entre cidades                                       '),nl,
    write('  2.19 Listar itinerários entre cidades                                                  '),nl,
    write('  2.20 Obter ininerário entre cidades com menor distância e respetivo preço              '),nl,
    write('  2.21 Obter itinerário entre cidades com maior distância e respetivo preço              '),nl,
    write('  2.22 Obter itinerário entre cidades com passagem por uma cidade                        '),nl,
    write('  2.23 Obter itinerário entre cidades com passagem por duas cidade                       '),nl,
    write('  2.24 Obter itinerário entre cidades com menor custo de deslocação e respetiva distância'),nl,
    write('  2.25 Obter itinerário passando pelo atributo pedido                                    '),nl,
    write('  2.26 Listar itinerários entre cidades com o número de escalas escolhido                '),nl,
    write('  2.27 Voltar ao Menu 1                                                                  '),nl,
    write('-----------------------------------------------------------------------------------------'),nl,
    write('O que pretende fazer?                                                                    '),nl,
    read(Choice), Choice>14, Choice =<27,
    doit(Choice), Choice=27, !.

doit(1) :-
    add_place.

doit(2) :-
    add_transport.

doit(3) :-
    add_poi.

doit(4) :-
    add_connection.

doit(5) :-
    alter_place.

doit(6) :-
    alter_transport.

doit(7) :-
    alter_poi.

doit(8) :-
    alter_connection.

doit(9) :-
    remove_place.

doit(10) :-
    remove_transport.

doit(11) :-
   remove_poi.

doit(12) :-
    remove_connection.

doit(13) :-
    secondary_menu.

doit(14) :-
    writeln('Programa vai terminar. Obrigado!'),
    abort().

doit(15) :-
    list_cities.

doit(16) :-
    list_cities_by_country.

doit(17) :-
    list_cities_by_attributes.

doit(18) :-
    list_trips.

doit(19) :-
    list_iteneraries.

doit(20) :-
    list_iteneraries_min.

doit(21) :-
    list_iteneraries_max.

doit(22) :-
    create_iti.

doit(23) :-
    create_iti2.

doit(24) :-
    list_iteneraries_min_price.

doit(25) :-
    create_iti_poi.

doit(26) :-
    list_iteneraries_by_scales.

doit(27) :-
    menu.

% FUNCTIONS HERE

% ADDS

add_place :-
    writeln('Qual o tipo do local que pretende adicionar?'),
    read(Type),
    writeln('Qual o país do local que pretende adicionar?'),
    read(Country),
    writeln('Qual o nome do local que pretende adicionar?'),
    read(Name),
    writeln('Quais os focos de interesse deste local? (Entre [])'),
    read(Focos),
    assert(places(Type, Country, Name, Focos)),
    write('Local adicionado.'),nl.

add_transport :-
    writeln('Qual o meio de transporte que pretende adicionar?'),
    read(Transport),
    findall((TRANSPORT), transport(Transport, _), TRANSPORT),
    length(TRANSPORT, 0) ->
    (
        writeln('Quantos lugares tem este meio de transporte?'),
        read(Number_of_seats),
        assert(transport(Transport, Number_of_seats)),
        writeln('Meio de transporte adicionado.')
    );
    writeln('Esse transporte já existe.').

add_poi :-
    writeln('Qual o foco de interesse que pretende adicionar?'),
    read(Poi),
    writeln('A que país?'),
    read(Country),
    writeln('A que lugar?'),
    read(Place),
    places(Type, Country, Place, Focos),
    append(Focos, [Poi], List),
    retract(places(_, Country, Place, _)),
    assert(places(Type, Country, Place, List)),
    writeln('Ponto de interesse adicionado.').

add_connection :-
    writeln('Qual o lugar de partida?'),
    read(Departure),
    findall((NOME), places(_, _, NOME, _), X),
    findall((TRANSPORTE), transport(TRANSPORTE, _), Y),
    writeln('Qual o destino?'),
    read(Destination),
    (member(Departure, X), member(Destination, X))  ->
    (
       writeln('Qual o meio de transporte?'),
       read(Transport),
       (member(Transport, Y)) ->
       (
          writeln('Qual a distância entre os locais?'),
          read(Distance),
          writeln('A que hora parte?'),
          read(Start_Time),
          writeln('A que horas chega?'),
          read(End_Time),
          writeln('Qual o preço da viagem?'),
          read(Price),
          assert(connections(Departure, Destination, Transport, Distance, Start_Time, End_Time, Price)),
          writeln('Ligação adicionada.')
       )
       ;
       writeln('O transporte pretendido não existe.')
    ), !;
    writeln('Os locais introduzidos poderão não existir.').

% EDITS

alter_place :-
    writeln('Qual o país do local que pretende alterar?'),
    read(Country),
    writeln('Qual a nome do local que pretende alterar?'),
    read(Name),
    places(_, Country, Name, Poi),
    findall((COUNTRIES), places(_, Country, _, _), COUNTRIES),
    findall((NAMES), places(_, _, Name, _), NAMES),
    (not(length(COUNTRIES, 0)), not(length(NAMES, 0))) ->
    (
        writeln('Qual o novo tipo do local que pretende alterar?'),
        read(Type),
        retract(places(_, Country, Name,_)),
        assert(places(Type, Country, Name, Poi)),
        writeln('Local alterado.'),
        write('Tipo: '), writeln(Type)
    );
    writeln('A cidade ou país que introduziu poderão não existir.').

alter_transport :-
    writeln('Qual o meio de transporte que pretende alterar?'),
    read(Transport),
    findall((TRANSPORTS), transport(Transport, _), TRANSPORTS),
    not(length(TRANSPORTS, 0)) ->
    (
        writeln('Qual o novo número de lugares que irá ter?'),
        read(Number_of_seats),
        retract(transport(Transport, _)),
        assert(transport(Transport, Number_of_seats)),
        writeln('Meio de transporte alterado.'),
        write('Número de lugares: '), writeln(Number_of_seats)
    );
    writeln('O transporte que introduziu não existe.').

alter_poi :-
    writeln('Qual o país do local que pretende alterar os focos de interesse?'),
    read(Country),
    writeln('Qual o nome do local que pretende alterar os focos de interesse?'),
    read(Name),
    findall((COUNTRIES), places(_, Country, _, _), COUNTRIES),
    findall((NAMES), places(_, _, Name, _), NAMES),
    (not(length(COUNTRIES, 0)), not(length(NAMES, 0))) -> (
        writeln('Qual o foco de interesse que pretende alterar?'),
        read(Old),
        findall(Name,(places(_,_,Name, Atributtes), member(Old, Atributtes)), CityList),
        member(Name, CityList) -> (
            writeln('Qual o novo foco de interesse?'),
            read(New),
            places(Type, Country, Name, X),
            del(Old, X, Z),
            append(Z, [New], Result),
            retract(places(_, Country, Name, _)),
            assert(places(Type, Country, Name, Result)),
            writeln('Foco de interesse alterado.'),
            writeln('Foco de interesse: '), write(Result)
        );
        writeln('O foco de interesse que inseriu não existe.')
    );
    writeln('A cidade ou país que introduziu poderão não existir.').


alter_connection :-
    writeln('Qual o local de partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    writeln('Qual o meio de transporte?'),
    read(Transport),
    writeln('A que hora parte?'),
    read(Start_Time),
    writeln('A que horas chega?'),
    read(End_Time),
    connections(Departure, Destination, Transport, Distance, Start_Time, End_Time, X),
    not(length(X, 0)) ->
    (
       writeln('Qual o novo preço da viagem?'),
       read(Price),
       retract(connections(Departure, Destination, Transport, _, Start_Time, End_Time, _)),
       assert(connections(Departure, Destination, Transport, Distance, Start_Time, End_Time, Price)),
       writeln('Ligação adicionada.')
    );
    writeln('Não existe a ligação pretendida.').

% REMOVES HERE

remove_place :-
    writeln('Qual o local que pretende remover?'),
    read(City_removal),
    writeln('A que país pertence?'),
    read(Country_removal),
    findall((COUNTRIES), places(_, Country_removal, _, _), COUNTRIES),
    findall((NAMES), places(_, _, City_removal, _), NAMES),
    (not(length(NAMES, 0)), not(length(COUNTRIES, 0))) ->
    (
        retract(places(_, Country_removal, City_removal, _)),
        writeln('Local removido.')
    );
    writeln('A cidade ou país inseridos podem não existir.').

remove_transport :-
    writeln('Qual o meio de transporte que pretende remover?'),
    read(Transport_removal),
    findall((TRANSPORTS), transport(Transport_removal, _), TRANSPORTS),
    not(length(TRANSPORTS, 0)) ->
    (
        retract(transport(Transport_removal, _)),
        writeln('Transporte removido.')
    );
    write('O transporte que pretende remover não existe.').

remove_poi :-
    writeln('Qual o local que pretende alterar?'),
    read(Name),
    writeln('Qual o seu país?'),
    read(Country),
    findall((COUNTRIES), places(_, Country, _, _), COUNTRIES),
    findall((NAMES), places(_, _, Name, _), NAMES),
    (not(length(COUNTRIES, 0)), not(length(NAMES, 0))) -> (
        writeln('Qual o foco de interesse que pretende remover?'),
        read(Focos_removal),
        findall(Name,(places(_,_,Name, Atributtes), member(Focos_removal, Atributtes)), CityList),
        member(Name, CityList) -> (
            places(Type, Country, Name, X),
            writeln(X),
            del(Focos_removal, X, Y),
            writeln(Y),
            retract(places(_, Country, Name, _)),
            assert(places(Type, Country, Name, Y)),
            writeln('Foco de interesse removido.')
        );
        writeln('O local introduzido não possui esse foco de interesse.')
    );
    writeln('A cidade ou país que introduziu poderão não existir.').

remove_connection :-
    writeln('Qual o local de partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    writeln('Qual o meio de transporte?'),
    read(Transport),
    writeln('A que hora parte?'),
    read(Start_Time),
    writeln('A que horas chega?'),
    read(End_Time),
    connections(Departure, Destination, Transport, _, Start_Time, End_Time, X),
    not(length(X, 0)) ->
    (
        retract(connections(Departure, Destination, Transport, _, Start_Time, End_Time, _)),
        writeln('Ligação removida.')
    );
    writeln('A ligação que pretende remover não existe.').

% QUERY FUNCTIONS

list_cities :-
    listing(places).

list_cities_by_country :-
    writeln('Qual o país ?'),
    read(Country),
    listing(places(_, Country, _, _)).

list_cities_by_attributes :-
    writeln('Qual o atributo?'),
    read(Attribute),
    forall(
      (
        places(_, _, Name, Attributes),
        member(Attribute, Attributes)
      ),
    writeln(Name)).

list_trips :-
   writeln('Qual o local de partida?'),
   read(Departure),
   writeln('Qual o destino?'),
   read(Destination),
   listing(connections(Departure, Destination, _, _, _, _, _)).

bi_connections(Departure, Destination, Distance, Price) :-
    connections(Departure, Destination, _, Distance, _, _, Price)
        ;
    connections(Destination, Departure, _, Distance, _, _, Price).

iti(Departure, Destination, Scales, Itenerary, Distance, Price, Target, Start):-
    bi_connections(Departure, Destination, Distance, Price),
    \+ member((Departure, Destination), Scales),
    \+ member((Destination, Departure), Scales),
    \+ member((_, Target), Scales),
    \+ member((_, Start), Scales),
   Itenerary = [(Departure, Destination, Distance, Price)].

iti(Departure, Destination, Scales, Itenerary, Distance, Price, Target, Start):-
    bi_connections(Departure, Z, Distance2, Price2),
    \+ member((Departure, Z), Scales),
    \+ member((Z, Departure), Scales),
    iti(Z, Destination, [(Departure, Z) | Scales], It2, Distance, Price, Target, Start),
    append([(Departure, Z, Distance2, Price2)], It2, Itenerary).

list_iteneraries :-
    writeln('Qual a partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    forall(
        iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
        (
            calc_dist(Itenerary, D),
            calc_price(Itenerary, P),
            assert(temp(Itenerary, D, P)),
            format('~w~w~w~w~w~w~w~w ', ['Itinerário: ', Itenerary, ' Distancia: ', D, ' km.', ' Custo: ', P, ' euros.']),nl,nl
        )
    ), !;
    writeln('Itinerário indisponível').

list_iteneraries_min :-
    writeln('Qual a partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    forall(
        iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
        (
            calc_dist(Itenerary, D),
            calc_price(Itenerary, P),
            assert(temp(Itenerary, D, P))
        )
    ), show_result_min, !;
    writeln('Itinerário indisponível').

list_iteneraries_max :-
    writeln('Qual a partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    forall(
        iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
        (
            calc_dist(Itenerary, D),
            calc_price(Itenerary, P),
            assert(temp(Itenerary, D, P))
        )
    ), show_result_max, !;
    writeln('Itinerário indisponível').

show_result_min :-
    findall((DISTANCES), temp(_, DISTANCES, _), Y),
    cal_min(Y, X),
    temp(Itenerary, X, Price),
    format('~w~w~w~w~w~w~w~w ', ['Itinerário com menor distância: ', Itenerary, ' Distancia: ', X, ' km.', ' Custo: ', Price, ' euros.']),nl,nl,
    retractall(temp(_, _, _)).

show_result_max :-
    findall((DISTANCES), temp(_, DISTANCES, _), Y),
    cal_max(Y, X),
    temp(Itenerary, X, Price),
    forall(temp(Itenerary, X, Price),
    (   format('~w~w~w~w~w~w~w~w ', ['Itinerário com maior distância: ', Itenerary, ' Distancia: ', X, ' km.', ' Custo: ', Price, ' euros.']),nl,nl)),
    retractall(temp(_, _, _)).

create_iti :-
    writeln('Qual o local de partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    writeln('Por que cidade pretende passar?'),
    read(City1),
    forall(
        (
           iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
           member((_, City1, _, _), Itenerary)
        ),
        writeln(Itenerary)
    ), !;
    writeln('Itinerário indisponível').

create_iti2 :-
    writeln('Qual o local de partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    writeln('Primeira escala:'),
    read(City1),
    writeln('Segunda escala:'),
    read(City2),
    forall(
       (
          iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
          (member((City1, _, _, _), Itenerary) , member((City2, _, _, _), Itenerary))
       ),
       writeln(Itenerary)
    ), !;
    writeln('Itinerário indisponível').

create_iti_poi :-
    retractall(temp1(_)),
    writeln('Qual o local de partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    writeln('Qual o foco de interesse?'),
    read(Poi),
    findall(Name,(places(_,_,Name, Atributtes), member(Poi, Atributtes)), CityList),
    forall(
       iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
       (
          recursive_scales(Itenerary, ScalesList),
          contained_in(ScalesList, CityList)
       ) -> (writeln(Itenerary), assert(temp1(Itenerary)))
    ), !;
    findall((ID), temp1(ID), X), length(X, 0) -> writeln('Itinerário indisponível.').

contained_in(L1, L2) :- maplist(contains(L2), L1).
contains(L, X) :- member(X, L).

recursive_scales([], []).
recursive_scales([(D1, D2,_ , _) | R], ScalesList) :-
    recursive_scales(R, A),
    append([D1, D2], A, ScalesList).

recursive_scales([(D1, D2,_ , _)], ScalesList):-
    ScalesList = [D1, D2].

list_iteneraries_min_price :-
    writeln('Qual a partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    forall(
        iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
        (
            calc_dist(Itenerary, D),
            calc_price(Itenerary, P),
            assert(temp(Itenerary, D, P))
        )
    ), show_min_price, !;
    writeln('Itinerário indisponível').

show_min_price :-
    findall((Prices), temp(_, _, Prices), Y),
    cal_min(Y, X),
    %temp(Itenerary, X, Price)
    forall(temp(Itenerary, Distance, X),
    (   format('~w~w~w~w~w~w~w~w ', ['Itinerário com menor custo: ', Itenerary, ' Distancia: ', Distance, ' km.', ' Custo: ', X, ' euros.']),nl,nl)),
    retractall(temp(_, _, _)).

list_iteneraries_by_scales :-
    writeln('Qual a partida?'),
    read(Departure),
    writeln('Qual o destino?'),
    read(Destination),
    writeln('Quantas escalas pretende fazer?'),
    read(ScalesNumber),
    NumberOfTravels is ScalesNumber + 1,
    forall((
        iti(Departure, Destination, [], Itenerary, _, _, Destination, Departure),
        length(Itenerary, NumberOfTravels)),
        writeln(Itenerary)
    ).

calc_dist([],0).
calc_dist([(_, _, D1, _) | R], Dtot):-
    calc_dist(R, D2),
    Dtot is D1 + D2.

calc_price([],0).
calc_price([(_, _, _, P1) | R], Ptot):-
    calc_price(R, P2),
    Ptot is P1 + P2.

minimo([], MinActual, MinFinal):-
    MinFinal = MinActual.

minimo([X|L], MinActual, MinFinal):-
    X < MinActual,
    minimo(L, X, MinFinal).

minimo([X|L], MinActual, MinFinal):-
    X >= MinActual,
    minimo(L, MinActual, MinFinal).

cal_min([X|L], Min):-
    minimo(L,X,Min).

% ---------------------------------

maximo([], MaxActual, MaxFinal):-
    MaxFinal = MaxActual.

maximo([X|L], MaxActual, MaxFinal):-
    X > MaxActual,
    maximo(L, X, MaxFinal).

maximo([X|L], MaxActual, MaxFinal):-
    X =< MaxActual,
    maximo(L, MaxActual, MaxFinal).

cal_max([X|L], Max):-
    maximo(L,X,Max).

% AUX SCRIPTS

% DELETE SCRIPT

del(Y, [Y], []).
del(X, [X|LIST1], LIST1).
del(X, [Y|LIST], [Y|LIST1]) :- del(X, LIST, LIST1).

% ADD ELEMENTS OF A LIST

sum([H|T], N):-
    sum(T, X),
    N is X + H.

% VALUES
:- dynamic places/4.

places(cidade, portugal, alverca, [comida, calor]).
places(cidade, portugal, beja, [comida, calor]).
places(cidade, portugal, almada, [roubos]).
places(cidade, portugal, algarve, [comida, praia, calor]).

:- dynamic transport/2.

transport(carro, 5).
transport(barco, 50).
transport(comboio, 150).

:- dynamic connections/7.

connections(alverca, beja, carro, 300, 12:00, 15:00, 25).
connections(beja, algarve, carro, 100, 15:00, 16:00, 30).
connections(alverca, algarve, carro, 350, 15:00, 18:30, 50).
connections(alverca, almada, carro, 50, 12:00, 15:00, 15).
connections(almada, algarve, carro, 250, 15:00, 16:00, 30).
connections(algarve, marrocos, barco, 200, 19:00, 22:00, 100).
connections(alverca, porto, carro, 320, 14:00, 17:00, 35).
connections(porto, madrird, aviao, 600, 10:00, 13:00, 120).
connections(madrird, paris, aviao, 500, 14:00, 17:00, 130).
connections(paris, oslo, aviao, 1200, 18:00, 23:00, 220).
connections(alverca, serra_da_estrela, carro, 150, 14:30, 16:00, 40).
connections(serra_da_estrela, beja, carro, 400, 13:00, 17:00, 70).
connections(beja, vila_real, carro, 150, 14:00, 16:00, 60).
connections(vila_real, algarve, carro, 90, 16:00, 17:00, 20).

