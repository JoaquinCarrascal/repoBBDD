/*
EJERCICIO 4
Las consultas se deben ejecutar sobre las bases de datos VUELOS (con varias tablas) e INMO, según correspondan.
Seleccionar el cliente que más ha gastado en vuelos que salen del mismo aeropuerto. Debe aparecer el nombre del cliente, el nombre y la ciudad del aeropuerto y la cuantía de dinero que ha gastado.
Seleccionar el piso que se ha vendido más caro de cada provincia. Debe aparecer la provincia, el nombre del comprador, la fecha de la operación y la cuantía.
Seleccionar los alquileres más baratos de cada provincia y mes (da igual el día y el año). Debe aparecer el nombre de la provincia, el nombre del mes, el resto de atributos de la tabla inmueble y el precio final del alquiler.
*/

/*
1.- Seleccionar el vuelo más largo (con mayor duración) de cada día de la semana. 
Debe aparecer el nombre del aeropuerto de salida, el de llegada, 
la fecha y hora de salida y llegada y la duración.
*/

SELECT TO_CHAR(salida, 'day'),sa.nombre, la.nombre,salida,llegada,llegada-salida
FROM vuelo JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
	JOIN aeropuerto la ON(la.id_aeropuerto = hasta)
WHERE llegada - salida >= (
					SELECT MAX(llegada-salida)
					FROM vuelo JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
						JOIN aeropuerto la ON(la.id_aeropuerto = hasta)
					GROUP BY TO_CHAR(salida, 'day')
							);
