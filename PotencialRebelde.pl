module ParcialFuncional where

import Data.List
import Text.Show.Functions

data Persona = UnaPersona{
nombre :: String,
tema :: [Gusto],
miedo :: [CosasMiedo],
est :: Int
} deriving Show

type CosasMiedo = (String,Int)
type Gusto = String
type Influencer = Persona->Persona

maria = UnaPersona "maria" ["mecanica"] [("extraterrestres",600),("desempleo",300)] 85
juanCa = UnaPersona "juanCa" ["maquillaje","trenes"] [("insectos",100),("coronavirus",10),("vacunas",20)] 50
juanCarlos = UnaPersona "juanCarlos" ["maquillaje","trenes"] [("insectos",100),("coronavirus",10),("vacunas",20)] 45
juanIgnacio = UnaPersona "Nacho" ["maquillaje","trenes"] [("insectos",100),("coronavirus",10),("vacunas",20)] 45
mario = UnaPersona "mario" ["mecanica","mecanica","mecanica","mecanica"] [("extraterrestres",900),("desempleo",300)] 85
mariana = UnaPersona "mariana" ["chocolate"] [("extraterrestres",600),("desempleo",300)] 15
marisa = UnaPersona "marisa" ["chocolate"] [("extraterrestres",600),("desempleo",300)] 25

--Que una persona se vuelva miedosa a algo en cierta medida, 
--agregándole el nuevo miedo o aumentando su medida, en caso de ya tener ese miedo previamente.

miedoso::CosasMiedo->Persona->Persona
miedoso (nuevoMiedo,medida) persona | (yaTieneMiedo (nuevoMiedo,medida) persona) = persona{miedo=miedo persona ++[(nuevoMiedo,medida)]}
                               | otherwise = persona{miedo=miedo persona ++[(nuevoMiedo,medida)]}


yaTieneMiedo::CosasMiedo->Persona->Bool
yaTieneMiedo (nuevoMiedo,_) persona = elem nuevoMiedo (miedoPersona persona)

miedoPersona::Persona->[String]
miedoPersona persona = map fst (miedo persona)

--Que una persona pierda pierda el miedo a algo,
--lo que independiente de en qué medida lo tuviera, lo deja de tener. (En caso de no tener ese miedo, no cambia nada)

pierdeMiedo::CosasMiedo->Persona->Persona
pierdeMiedo (nuevoMiedo,medida) persona = persona{miedo= filter (\(a,_) -> a /= nuevoMiedo) (miedo persona)}


--Que una persona pueda variar su estabilidad en una cierta proporción dada, pero sin salirse de los límites de la escala.

variaEstabilidad::Float->Persona->Persona
variaEstabilidad prop persona | ((prop*fromIntegral(est persona)<=100) && (prop*fromIntegral(est persona)>=0)) = persona{est = round(prop*fromIntegral(est persona))}
                              | otherwise = persona

sumaEstabilidad::Int->Persona->Persona
sumaEstabilidad suma persona | (suma+(est persona)<=100) && (suma+(est persona)>=0) = persona{est = suma+(est persona)}
                              | otherwise = persona
--Que una persona se vuelva fan de otra persona, en ese caso asume como propios
--todos los gustos de la otra persona (si ya tenía previamente alguno de esos gustos, lo va a tener repetido)

fanDe::Persona->Persona->Persona
fanDe persona influencer = persona{tema= tema persona++(tema influencer)}

--Averiguar si una persona es fanática de un gusto dado, que es cuando tiene más de tres veces dicho gusto.

fanaticaDe::Gusto->Persona->Bool
fanaticaDe gusto persona = (length (filter (==gusto) (tema persona)))>3

--Averiguar si una persona es miedosa, cuando el total de la medida de todos sus miedos sumados supera 1000.
esMiedosa::Persona->Bool
esMiedosa persona = (sum (medidasMiedos persona))>1000

medidasMiedos::Persona->[Int]
medidasMiedos persona = map snd (miedo persona)

--Hay uno, llamado luisitoComunica, que podría intervenirle la televisión a María para hacerle creer
-- que los extraterrestres están instalando una falsa pandemia. El impacto sería que se disminuya su estabilidad en 20 unidades,
-- que tenga miedo a los extraterrestres en 100 y al coronavirus en 50.


-------Corregido el Issue que se reportó en Git

--luisitoComunica::Persona->Persona
--luisitoComunica  persona | (nombre persona == "maria") = afectaAMaria persona
--                         | otherwise = persona

--afectaAMaria::Persona->Persona
--afectaAMaria  = miedoso ("extraterrestres",100). miedoso("coronavirus",50).(sumaEstabilidad (-20))


luisitoComunica::Persona->Persona
luisitoComunica = miedoso ("extraterrestres",100). miedoso("coronavirus",50).(sumaEstabilidad (-20))


--Hay otro que hace que una persona le de miedo a la corrupción en 10, le pierda el miedo a convertirse en Venezuela
-- y que agrega el gusto por escuchar.

maduro::Persona->Persona
maduro = miedoso("corrupcion",100).pierdeMiedo("Ser Venezuela",100).agregaGusto "escuchar"

agregaGusto::String->Persona->Persona
agregaGusto gusto persona = persona{tema= (tema persona)++[gusto]}

--El community manager de un artista es un influencer que hace que la gente se haga fan de dicho artista.

communityManager::Persona->Persona->Persona
communityManager artista persona = fanDe artista persona

--Está el influencer inutil, que no lograr alterar nada.

inutil::Persona->Persona
inutil persona = persona

--Agregá uno a tu elección, pero que tambien realice uno o más cambios en una persona.
--Este influencer hace que sus fans se identifiquen con el apodo "minion" delante de su nombre, le agrega el miedo a pensar en 100
ejercitoMinion::Persona->Persona
ejercitoMinion persona = miedoso("pensar",100) persona{nombre = "minion"++nombre persona}

--Implementar las funciones que permitan:

--Hacer una campaña de marketing básica,
--que dado un conjunto de personas hace que todas ellas sean influenciadas por un influencer dado.

--Saber qué influencer es más generador de miedo: dada una lista de personas y dos influencer,
--saber cuál de ellos provoca que más personas se vuelvan miedosas.


campaniaMarketing::[Persona]->Influencer->[Persona]
campaniaMarketing listapersonas influencer = map influencer listapersonas

daMasMiedo::[Persona]->Influencer->Influencer->Bool
daMasMiedo listapersonas influencer1 influencer2 = cantidadMiedosos(campaniaMarketing listapersonas influencer1) > cantidadMiedosos(campaniaMarketing listapersonas influencer2) 

cantidadMiedosos::[Persona]->Int
cantidadMiedosos = length.filter(esMiedosa)

--producto se saben dos cosas: el gusto que se necesita que tenga la persona para comprarlo y una condición adicional específica de ese producto.

--Por ejemplo:

--El desodorante Acks necesita que a la gente le guste el chocolate pero además que la estabilidad de la persona sea menor a 50.
--El llavero de plato volador necesita que a la persona le gusten los extraterrestres pero que no sea miedosa.
--El pollo frito Ca Efe Se necesita que a la persona le guste lo frito y que sea fanática del pollo.

data Producto=UnProducto{

    gustoProd :: Persona->Bool,
    necesita :: Persona->Bool
} deriving Show

desodoranteAcks = UnProducto (leGusta "chocolate") estabilidadMenor50
llaveroPlatoVolador = UnProducto (leGusta "extraterrestres") (not.esMiedosa)
polloKFC = UnProducto (leGusta "frito") (fanaticaDe "pollo")

estabilidadMenor50::Persona->Bool
estabilidadMenor50 persona = est persona < 50

leGusta::Gusto->Persona->Bool
leGusta gustoProdu persona = (elem gustoProdu (tema persona))

--Calcular la eficiencia de un campaña de marketing con un influencer para un producto en particular. Es el porcentaje de variación de la
--cantidad de gente que antes de la campaña no hubiera comprado el producto, pero luego sí.

afinidadProducto::Producto->Persona->Bool
afinidadProducto producto persona = ((gustoProd producto persona) && (necesita producto persona))

eficienciaCampania::[Persona]->Influencer->Producto->Int
eficienciaCampania listapersonas influencer producto = (cantidadAficionados (campaniaMarketing listapersonas influencer) producto)-(cantidadAficionados listapersonas producto)

cantidadAficionados::[Persona]->Producto->Int
cantidadAficionados listaDePersonas productoA = (length (filter (==True) (map (afinidadProducto productoA) listaDePersonas)))

--Analizar qué sucede en caso de utilizar una lista infinita. Mostrar formas de utilizar algunas de las funciones hechas de manera que:

--Se quede iterando infinitamente sin arrojar un resultado.
--Si queremos conocer la cantidad de miedosos (Con cantidadMiedosos) de una lista infinita, no tendremos un resultado finito,
--ya que tiene que recorrer toda la lista para darnos una respuesta.

mara = [UnaPersona "marisa" ["chocolate"] [("extraterrestres",x),("desempleo",x)] 25| x <-[10..]]

--Se obtenga una respuesta finita.
--Si utilizo un take (Valor finito) en la función esMiedosa usando como argumento "mara", obtendré una lista finita (Tendra como longitud el argumento de take)
--con el resultado de la funcion aplicada

--La respuesta que se obtiene sea a su vez infinita.
--Si aplico una Camapaña de Marketing sobre la lista infinita de personas (Se utilizó a mara como ejemplo), al usar evaluación
--diferida o lazy, va calculando sobre las personas a medida que lo necesita, no es necesario que recorra toda la lista
--para dar una respuesta

--Explicar la utilidad del concepto de aplicación parcial en la resolución realizada dando un ejemplo concreto donde se lo usó
--Aplicacion parcial se utiliza en las funciones que utilizan a los distintos influencers, el influencer básico es una función que
--recibe una Persona y devuelve otra persona

--type Influencer = Persona->Persona

--Sin embargo, hay influencer como el communityManager que necesita un argumento adicional, para poder utilizarlo en funciones como 
--campaniaMarketing, hay que pasarle el argumento adicional, es decir darle parcialmente el argumento para que luego pueda aplicarse la funcion
--resultante a la lista de personas

--Pruebas varias:

--Afinidad a un producto:
--afinidadProducto desodoranteAcks mariana
--True
--Como a mariana le gusta el chocolate y tiene una estabilidad menor a 50, tiene afinidad con el desodoranteAcks 

--No pasa lo mismo con juanCa
--afinidadProducto desodoranteAcks juanCa 
--False

--ejercitoMinion
--Vemos que al aplicar ejercitoMinion a maria, se le modifica el nombre y se le agrega el miedo a pensar
--ejercitoMinion maria
--UnaPersona {nombre = "minionmaria", tema = ["mecanica"], miedo = [("extraterrestres",600),("desempleo",300),("pensar",100)], est = 85}

--La eficiencia la medimos sobre cantidad de gente con nueva afinidad al producto menos la cantidad de gente sin afinidad previa,
--Indica cuantos nuevos consumidores hay
--eficienciaCampania [juanCa,juanIgnacio,juanCarlos] (communityManager mariana) desodoranteAcks 
--3
--En ese caso, hay 3 nuevos consumidores de producto
