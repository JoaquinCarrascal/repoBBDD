/*
EJERCICIO 4
*/

/*
1.- Seleccionar el vuelo más largo (con mayor duración) de cada día de la semana. 
Debe aparecer el nombre del aeropuerto de salida, el de llegada, 
la fecha y hora de salida y llegada y la duración.
*/

/*SELECT TO_CHAR(salida, 'day') AS "diasemanal",sa.nombre, la.nombre,salida,llegada,llegada-salida AS "duracion"
FROM vuelo v1 JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
	JOIN aeropuerto la ON(la.id_aeropuerto = hasta)
GROUP BY diasemanal,sa.nombre, la.nombre,salida,llegada,llegada-salida
HAVING llegada - salida >= ALL(		--define saturación con una consulta de SQL
					SELECT v2.llegada - v2.salida
					FROM vuelo v2 JOIN aeropuerto sa2 ON(sa2.id_aeropuerto = desde)
					WHERE TO_CHAR(v1.salida, 'day') = TO_CHAR(v2.salida, 'day')
								)
ORDER BY diasemanal;*/

SELECT TO_CHAR(salida, 'day') AS "diasemanal",sa.nombre, la.nombre,
		salida,llegada,llegada-salida AS "duracion"
FROM vuelo v1 JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
	JOIN aeropuerto la ON(la.id_aeropuerto = hasta)
WHERE llegada - salida >= ALL(
					SELECT v2.llegada - v2.salida
					FROM vuelo v2
					WHERE TO_CHAR(v1.salida, 'day') = TO_CHAR(v2.salida, 'day')
								)
GROUP BY diasemanal,sa.nombre, la.nombre,
		salida,llegada,duracion
ORDER BY EXTRACT(day FROM v1.salida) DESC;

/*
2.- Seleccionar el cliente que más ha gastado en vuelos que salen del mismo 
aeropuerto. Debe aparecer el nombre del cliente, el nombre y la 
ciudad del aeropuerto y la cuantía de dinero que ha gastado.
*/

SELECT c.nombre,c.apellido1,c.apellido2, sa.nombre, sa.ciudad, precio * COUNT(sa.id_aeropuerto) * (1 - COALESCE(descuento,0)) AS "dinerogastado"
FROM cliente c JOIN reserva USING(id_cliente)
	JOIN vuelo USING(id_vuelo)
	JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
GROUP BY c.nombre,c.apellido1,c.apellido2, sa.nombre, sa.ciudad,precio,descuento
HAVING precio * COUNT(sa.id_aeropuerto) * (1 - COALESCE(descuento,0)) >= ALL (
													SELECT precio * COUNT(sa.id_aeropuerto) * (1 - COALESCE(descuento,0)) AS "dinerogastado"
													FROM cliente c JOIN reserva USING(id_cliente)
														JOIN vuelo USING(id_vuelo)
														JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
													GROUP BY c.nombre,c.apellido1,c.apellido2, sa.nombre, sa.ciudad,precio,descuento						 
													ORDER BY dinerogastado DESC,c.nombre,c.apellido1,c.apellido2
															);
															
/*
3.- Seleccionar el piso que se ha vendido más caro de cada provincia. 
Debe aparecer la provincia, el nombre del comprador, la fecha de la operación y la cuantía.
*/
SELECT provincia,c.nombre,fecha_operacion,precio_final
FROM inmueble i JOIN operacion USING(id_inmueble)
	JOIN tipo t ON (id_tipo = tipo_inmueble)
	JOIN comprador c USING(id_cliente)
WHERE tipo_operacion = 'Venta'
	AND t.nombre = 'Piso'
GROUP BY provincia,c.nombre,fecha_operacion,precio_final
HAVING precio_final >= ALL(
				SELECT MAX(precio_final)
				FROM inmueble i2 JOIN operacion USING(id_inmueble)
					JOIN tipo t ON (id_tipo = tipo_inmueble)
				WHERE tipo_operacion = 'Venta'
					AND t.nombre = 'Piso'
					AND i2.provincia = i.provincia
							)
ORDER BY provincia;

/*
4.- Seleccionar los alquileres más baratos de cada provincia y mes 
(da igual el día y el año). Debe aparecer el nombre de la provincia, 
el nombre del mes, el resto de atributos de la tabla inmueble y el precio final del alquiler. 
*/
SELECT id_inmueble,fecha_alta,tipo_inmueble,tipo_operacion,provincia,
		superficie,precio,precio_final,TO_CHAR(o1.fecha_operacion,'Month')
FROM inmueble i JOIN operacion o1 USING(id_inmueble)
WHERE tipo_operacion = 'Alquiler'
GROUP BY id_inmueble,fecha_alta,tipo_inmueble,tipo_operacion,provincia,
		superficie,precio,precio_final,TO_CHAR(o1.fecha_operacion,'Month'),
		o1.fecha_operacion
HAVING precio_final <= ALL(
				SELECT MIN(precio_final)
				FROM inmueble i2 JOIN operacion o2 USING(id_inmueble)
				WHERE tipo_operacion = 'Alquiler'
					AND i2.provincia = i.provincia
					AND EXTRACT(month FROM o1.fecha_operacion) = EXTRACT(month FROM o2.fecha_operacion)
							)
ORDER BY provincia,EXTRACT(month FROM o1.fecha_operacion);
															

