%--Punto 1--Modelar la base de conocimiento para incluir estos datos, agregar alguna persona y vivienda más

%ciudadano(hash-md5,trabajo,[gustos],[esBueno],[historialCriminal])
%Se utilizaron los ultimos 5 caracteres del hash para identifica a cada ciudadano

ciudadano(ab570,ingenieraMecanica,[fuego,destruccion],[armadoBombas],[]).
ciudadano(ce234,aviacionMilitar,[],[conduceAutos],[roboAeronaves,fraude,tenenciaCafeina]).
ciudadano(f2682,hackerInformatico,[prolog,haskell],[matematica],[hackear]).
ciudadano(a76cc,estudiante,[dormir,comer,leer,entrenar],[dormir,matematica,tiroAlBlanco],[faltarAClases]).
ciudadano(7b013,inteligenciaMilitar,[ajedrez,juegosAzar,tiroAlBlanco],[tiroAlBlanco],[falsificacionVacunas,fraude]).


trabajosMilitares([aviacionMilitar,inteligenciaMilitar]).
habilidadMilitar([armadoBombas,tiroAlBlanco]).

%viveEn(ciudadano,vivienda)
viveEn(ab570,laSeverino).
viveEn(ba4d9,laSeverino).
viveEn(ce234,laSeverino).
viveEn(7a013,comisaria48).
viveEn(a76cc,comisaria48).

esCiudadano(Persona):-
ciudadano(Persona,_,_,_,_).

%casas(Nombre,cuartoSecreto(Lado),tunel(Cant,Long),pasadizo(Cant),pasadizoSinTerminar(Cant))
%%%%%%Aclaracion: Si bien este modelado funcionaba con lo que se pedia, se replantea el modelado para los ambientes de una forma 
%mas apropiada, para que el calculo de los metros cuadrados sea más genérico y para que los ambientes de las casas puedan diferir.


%%Se comenta lo anterior para aplicar la solucion mas conveniente
%casa(laSeverino,cuartoSecreto(4,8),tunel([8,5,1]),pasadizo(4),pasadizoSinTerminar(2)).
%casa(comisaria48,cuartoSecreto(20,20),tunel([10]),pasadizo(1),pasadizoSinTerminar(4)).
%casa(monsterHouse,cuartoSecreto(10,1),tunel([2,2]),pasadizo(1),pasadizoSinTerminar(4)).
%casa(casaRosada,cuartoSecreto(3,1),tunel([1,2]),pasadizo(10),pasadizoSinTerminar(5)).

%casa(Nombre,[Ambientes]).

casa(laSeverino,[cuartoSecreto(4,8),tunel([8,5,1]),pasadizo(1)]).
casa(comisaria48,[cuartoSecreto(20,20),tunel([10]),pasadizo(1),pasadizoSinTerminar(4)]).
casa(monsterHouse,[cuartoSecreto(10,1),tunel([2,2]),pasadizoSinTerminar(4)]).
casa(casaRosada,[cuartoSecreto(3,1),pasadizo(10),pasadizoSinTerminar(5),bunker(2)]).



%No tener gustos registrados en sistema, tener más de 3
cantGustos(Ciudadano,Cant):-
ciudadano(Ciudadano,_,ListaGustos,_,_),
length(ListaGustos,Cant).

noTieneGustos(Ciudadano):-
cantGustos(Ciudadano,0).

masDeTresGustos(Ciudadano):-
cantGustos(Ciudadano,Cant),
Cant > 3.

gustoRaro(Ciudadano):-noTieneGustos(Ciudadano).
gustoRaro(Ciudadano):-masDeTresGustos(Ciudadano).
gustoRaro(Ciudadano):-gusteHabilidad(Ciudadano).

%guste aquello en lo que es bueno.
gusteHabilidad(Ciudadano):-
esCiudadano(Ciudadano),
habilidades(Ciudadano,Sabe),
gustos(Ciudadano,Sabe).

habilidades(Ciudadano,Habilidad):-
ciudadano(Ciudadano,_,_,Habilidades,_),
member(Habilidad,Habilidades).

gustos(Ciudadano,Gusto):-
ciudadano(Ciudadano,_,Gustos,_,_),
member(Gusto,Gustos).

%Tiene más de un registro en su historial criminal o vive junto con alguien que sí lo tiene.

criminal(Persona):-
ciudadano(Persona,_,_,_,Ilicitos),
length(Ilicitos,Cant),
Cant>0.

viveCon(Persona1,Persona2):-
viveEn(Persona1,Casa),
viveEn(Persona2,Casa),
Persona1\=Persona2.


criCriminal(Persona1):-criminal(Persona1).
criCriminal(Persona1):-
viveCon(Persona1,Persona2),
criminal(Persona2).

%Tener una habilidad en algo considerado terrorista sin tener un trabajo de índole militar.

habilidadTerrorista(Habilidad):-
habilidadMilitar(Lista),
member(Habilidad,Lista).

tieneHabilidadTerrorista(Persona):-
esCiudadano(Persona),
habilidades(Persona,Habilidad),
habilidadTerrorista(Habilidad).

tieneTrabajoMilitar(Persona):-
ciudadano(Persona,Trabajo,_,_,_),
trabajosMilitares(TrabajosMilitares),
member(Trabajo,TrabajosMilitares).

%%---Punto 2---Poder saber quiénes son posibles disidentes. 
%esDisidiente
esDisidiente(Persona):-
tieneHabilidadTerrorista(Persona),
not(tieneTrabajoMilitar(Persona)),
gustoRaro(Persona),
criCriminal(Persona).


%---Punto 3 ---Detectar si en una vivienda: 
%No vive nadie 
%Todos los que viven tienen al menos un gusto en común.

casaSola(Casa):-
casa(Casa,_),
not(viveEn(_,Casa)).

gustosEnComun(Casa):-
viveEn(Persona1,Casa),
forall(viveEn(Persona2,Casa),not(gustosDisgustos(Persona1,Persona2))).

gustosDisgustos(Persona1,Persona2):-
gustos(Persona1,Gusto1),
gustos(Persona2,Gusto2),
Persona1\=Persona2,
Gusto1\=Gusto2.

%PotencialRebelde si vive en ella algún disidente y su superficie destinada 
%a actividad clandestinas supera 50 metros cuadrados, lo que se calcula de la siguiente forma:

%Para los cuartos secretos, que siempre se consideran rectangulares, la superficie cubierta
%Para los túneles, el doble de su longitud, excepto cuando están en construcción, que no se consideran.
%Los pasadizos siempre tienen un metro cuadrado de superficie

%Se comenta esta solucion para implementar la mas conveniente:
%metrosCuadradosCasa(Casa,MetrosCuadrados):-
%casa(Casa,cuartoSecreto(LargoCuarto,AnchoCuarto),tunel(Tuneles),pasadizo(CantPasadizos),pasadizoSinTerminar(_)),
%sumlist(Tuneles,MetrosTunel),
%MetrosCuadrados is (LargoCuarto*AnchoCuarto) + MetrosTunel*2 + CantPasadizos.


casaGrande(Casa):-
metrosCuadradosCasa(Casa,MetrosCuadrados),
MetrosCuadrados>50.

metrosCuadradosCasa(Casa,Metros):-
findall(Metro,(ambienteCasa(Casa,Ambiente),metrosCuadradosAmbiente(Ambiente,Metro)),MetrosParciales),
sum_list(MetrosParciales,Metros).

ambienteCasa(Casa,Ambiente):-
casa(Casa,Ambientes),
member(Ambiente,Ambientes).

metrosCuadradosAmbiente(cuartoSecreto(Lado1,Lado2),Metro):-Metro is Lado1 * Lado2.
metrosCuadradosAmbiente(tunel(Tuneles),Metro):-sumlist(Tuneles,MetrosTunel),Metro is MetrosTunel * 2.
metrosCuadradosAmbiente(pasadizo(Cant),Metro):-Metro is Cant.

%Bunker, cantidad de entradas por 8
metrosCuadradosAmbiente(bunker(Cant),Metro):-Metro is Cant*8.

%Si se desea agregar un ambiente adicional solo se deberá definir el predicado en donde se especifique la forma de calcular los metros cuadrados.

%---Punto 4 ---Encontrar todas las viviendas que tengan potencial rebelde. 

potencialRebelde(Casa):-
casa(Casa,_),
viveEn(Persona,Casa),
esDisidiente(Persona),
casaGrande(Casa).

%--Punto 5 ---Ejemplos de Consultas
%
%
%Se probara el funcionamiento de los siguientes predicados
%
%%%%%    gustoRaro(a76cc).     %%%%%%
%true ;
%true ;
% Si evaluamos el nombre del estudiante, vemos que nos devuelve dos veces true, ya que cumple con dos de las condiciones de 
%gustos raros, tiene mas de tres gustos y le gusta algo en lo que es bueno

%%%%%%%    criCriminal/1     %%%%%%
%criCriminal(Quien).
%Quien = ce234 ;
%Quien = f2682 ;
%Quien = a76cc ;
%Quien = ab570 ;
%Quien = ba4d9 ;

%Si colocamos una variable libre como argumento, el predicado criCriminal/1 nos devolverá a las personas consideradas criminales
%o las que viven con un criminal


%%%%%%   esDisidiente/1     %%%%%%

%esDisidiente(a76cc).
%true .

%Si evaluamos a a76cc en esDisidiente/1 obtenemos true, ya que cumple con todas las condiciones:
%Tener una habilidad en algo considerado terrorista sin tener un trabajo de índole militar.
%No tener gustos registrados en sistema, tener más de 3, o que le guste aquello en lo que es bueno.
%Tiene más de un registro en su historial criminal o vive junto con alguien que sí lo tiene.



%%%%% PotencialRebelde

%% Sabemos que a76cc es Disidiente, si vive en una casa con mas de 30 cuadrados, la misma se considerará Potencial Rebelde.
%% a76cc vive en la Comisaria48.

%casaGrande(comisaria48).
%true.

%Se considera casa grande, por lo tanto si evaluamos a comisaria4 en PotencialRebelde nos deberia dar true.

%potencialRebelde(comisaria48).
%true ;


%%---Punto 6 --- Inversibilidad

%La inversibilidad es una de las características que distinguen al paradigma logico, la inversibilidad nos permite usar argumentos en el predicado como
%entradas o como salidas. 

%En principio todo predicado es inversible salvo que caiga en un caso de no inversibilidad.

%Los casos de no inversibilidad mas tipicos son cuando utilizamos lo siguiente:

%Hechos con variables
%Comparacion por distinto
%Negación
%>, >=, <, =<
%is/2


%%% Analizaremos un predicado inversible:

%viveCon/2

%El mismo esta definido de la siguiente forma

%viveCon(Persona1,Persona2):-
%viveEn(Persona1,Casa),
%viveEn(Persona2,Casa),
%Persona1\=Persona2.

%La evaluacion del distinto se hace a lo último.

%viveCon(Persona1,Persona2).
%Persona1 = ab570,
%Persona2 = ba4d9 ;
%Persona1 = ab570,
%Persona2 = ce234

%Y es inversible para los dos argumentos,

%Si ahora modificamos el predicamo, y ubicamos al principio la comparación, el predicado pierde su caracter de inversible.

%viveCon(Persona1,Persona2):-
%Persona1\=Persona2,
%viveEn(Persona1,Casa),
%viveEn(Persona2,Casa).

%viveCon(Persona1,Persona2).
%false.

%---Punto 7 ----
%Si en algún momento se agregara algún tipo nuevo de ambiente en las viviendas, por ejemplo bunkers donde se esconden secretos o entradas a cuevas donde se puede viajar en el tiempo 
%¿Qué pasaría con la actual solución? 
%¿Qué se podría hacerse si se quisiera contemplar su superficie para determinar la superficie total de la casa? Implementar una solución con una lógica simple
%Justificar


%Con nuestro planteo inicial, al tener fijas la cantidad de ambientes en la vivienda,

%casas(Nombre,cuartoSecreto(Lado),tunel(Cant,Long),pasadizo(Cant),pasadizoSinTerminar(Cant)).
% Y al evaluar los metros cuadrados con una casa con mas ambientes fallaria, ya que se agregarían campos que no estan contemplados,

%podemos modificar la solucion, y colocar los functores en listas, no como campos fijos, de esta forma, haciendo uso de polimorfismo
%podriamos definir metrosCuadradosAmbiente/2, para que calcule las dimensiones de cada ambiente, y luego con otro predicado 
%adicional metrosTotalesCasa/2 , recorrer la lista e ir calculando el area por separado, luego sumando esto ultimo.

%Nos quedaria:
%casas(Nombre,[ListaAmbientes]).

%metrosTotalesCasa(Casa,Metros):-
%ambienteCasa(Casa,Ambiente),
%findall(Metro,metrosCuadradosAmbiente(Ambiente,Metro),MetrosParciales),
%sumlist(MetrosParciales,Metros).

%ambienteCasa(Casa,Ambiente):-
%casas(Casa,Ambientes),
%member(Ambiente,Ambientes).

%Para el calculo del área de cada ambiente en particular debemos definir la funcion metrosCuadradosAmbiente/2, a diferencia de 
%nuestra solucion inicial es mas sencilla de modificar si se agrega un nuevo ambiente.

%metrosCuadradosAmbiente(cuartoSecreto(Lado1,Lado2),Metro):-
%Metro is Lado1 * Lado2.

%metrosCuadradosAmbiente(tunel(Tuneles),Metro):-
%sumlist(Tuneles,MetrosTunel),
%Metro is MetrosTunel * 2.

%metrosCuadradosAmbiente(pasadizo(Cant),Metro):-
%Cant is Metro.


%Esta forma de plantear el problema es mejor que la pensada inicialmente, se modifica con lo especificado en el planteo, se plantea el ejemplo de bunker
%Sus metros totales son cantidad de entradas por 8.
