/*EJERCICIO 5
Las consultas se deben ejecutar sobre la base de datos VUELOS (varias tablas):

Selecciona el tráfico de pasajeros (es decir, personas que han llegado en un vuelo o personas que han salido en un vuelo) agrupado por mes (independiente del año) y aeropuerto. 
INVESTIGA: Tienes que hacer uso de la cláusula UNION, y piensa en hacer primero el tráfico de salida, después el de llegada (en consultas diferentes pero casi idénticas) y posteriormente en sumarlo.
Suponiendo que el 30% del precio de cada billete son beneficios (y el 70% son gastos), ¿cuál es el trayecto que más rendimiento económico da? Es decir, ¿en qué trayecto estamos ganando más dinero? ¿Y con el que menos? Lo puedes hacer en consultas diferentes usando WITH
Seleccionar el nombre y apellidos de los clientes que no han hecho ninguna reserva para un vuelo que salga en el tercer trimestre desde Sevilla.
Selecciona el nombre y apellidos de aquellos clientes cuyo gasto en reservas de vuelos con origen en España (Sevilla, Málaga, Madrid, Bilbao y Barcelona) ha sido superior a la media total de gasto de vuelos con origen fuera de España.
*/

/*
1.- Selecciona la media, agrupada por nombre de aeropuerto de salida, 
del % de ocupación de los vuelos. PISTA: tendrás que incluir una 
subconsulta dentro de otra y, en la interior, usar una subconsulta 
en el select :S (o bien usar WITH)
*/
SELECT 
