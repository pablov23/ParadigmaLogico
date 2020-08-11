# ParadigmaLogico


## Potencial rebelde


Es el año 2220 en un lugar muy lejano al planeta Tierra. El líder supremo, de nombre impronunciable e imposible de escribir, gobierna su planeta a puño de hierro. Su población es mayormente mano de obra esclava que utiliza para fabricar gran cantidad de naves con las que planea dominar toda la galaxia. 

Para poder mantenerse en el poder destina una parte importante de sus recursos a monitorear a sus habitantes y detectar tanto crímenes como posibles focos de disidencia. Para esto cuenta con un programa hecho en Prolog que tiene información sobre todos y cada uno de los habitantes. Si bien parece contener millones y millones de líneas de código, nuestro objetivo va a ser reimplementar ciertas partes centrales del sistema para entender cómo funcionan y, en un futuro, lanzar una ofensiva para rescatar a toda la población.

Para un mayor control de los ciudadanos, los nombres en el planeta fueron reemplazados por un hash md5 de su nombre anterior. Hicimos un ataque de intermediario y logramos conseguir algunas fichas de los ciudadanos, que asumimos se utilizaron para generar la base de conocimientos del sistema:
 


Nombre: 912ec803b2ce49e4a541068d495ab570
Trabaja de ingeniera mecánica en la Universidad Tecnológica Intergaláctica. Le gusta el fuego y la destrucción. Es buena armando bombas y vive en la misma casa con 1f5364c58947e14f9afa445bdf1ba4d9 y 2e416649e6ca0a1cbf9a1210cf4ce234. A esa casa le suelen decir “La Severino”. No tiene historial criminal.


Nombre: 2e416649e6ca0a1cbf9a1210cf4ce234
Trabaja en la aviación militar. No parece tener gustos, pero se sabe que es bueno conduciendo autos. Su historial criminal es extenso: robo de aeronaves, fraude, tenencia de cafeína. 

Nombre: f55840c38474c1909ce742172a77a013
Trabaja en inteligencia militar. Vive en la Comisaría 48 y es el único que vive allí. Es muy bueno en tiro al blanco; ama los juegos de azar, el ajedrez y tambien el tiro al blanco. En su historial criminal se encuentra la falsificación de vacunas y fraude.

Nombre 42fc1cd45335ad42d603657e5d0f2682
(inventale su info)

¡Agregate vos!

La actividad política se encuentra fuertemente restringida, con lo que las agrupación que pretenden modificar el orden reinante debieron volverse clandestinas y son buscadas intensamente. Para llevar a cabo sus actividades utilizan pasadizos y túneles ocultos en las viviendas, utilizando nanotecnología para esconderse.
Por lo que vimos en su base de datos, de cada vivienda se conoce cómo es. A modo de de ejemplo:

Vivienda
La Severino
Descripción
Por lo que se investigó, tiene un cuarto secreto de 4 x 8, un pasadizo y 3 túneles secretos: uno de 8 metros de largo, uno de 5 metros de largo y uno de 1 metro de largo que parecía estar aún en construcción. 

Uno de nuestros objetivos es encontrar viviendas que sean utilizadas como guaridas de potenciales rebeliones, antes que lo hagan las fuerzas del régimen. Por nuestras estimaciones, se consideran viviendas con potencial rebelde si vive en ella algún posible disidente y su superficie destinada a actividad clandestinas supera 50 metros cuadrados, lo que se calcula sumando los metros de cada cuarto, calculados de la siguiente forma:
Para los cuartos secretos, que siempre se consideran rectangulares, la superficie cubierta
Para los túneles, el doble de su longitud, excepto cuando están en construcción, que no se consideran.
Los pasadizos siempre tienen un metro cuadrado de superficie

Se pide:
Modelar la base de conocimiento para incluir estos datos, agregar alguna persona y vivienda más.
Poder saber quiénes son posibles disidentes. Una persona se considera posible disidente si cumple todos estos requisitos:
Tener una habilidad en algo considerado terrorista sin tener un trabajo de índole militar.
No tener gustos registrados en sistema, tener más de 3, o que le guste aquello en lo que es bueno.
Tiene más de un registro en su historial criminal o vive junto con alguien que sí lo tiene.
Detectar si en una vivienda: 
No vive nadie 
Todos los que viven tienen al menos un gusto en común.
Encontrar todas las viviendas que tengan potencial rebelde. 
Mostrar ejemplos de consulta y respuesta.
Analizar la inversibilidad de los predicados, de manera de encontrar alguno de los realizados que sea totalmente inversible y otro que no. Justificar. 
Si en algún momento se agregara algún tipo nuevo de ambiente en las viviendas, por ejemplo bunkers donde se esconden secretos o entradas a cuevas donde se puede viajar en el tiempo 
¿Qué pasaría con la actual solución? 
¿Qué se podría hacerse si se quisiera contemplar su superficie para determinar la superficie total de la casa? Implementar una solución con una lógica simple
Justificar
