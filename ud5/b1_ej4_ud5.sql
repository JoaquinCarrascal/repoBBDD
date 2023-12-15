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

/*SELECT c.nombre,c.apellido1,c.apellido2, sa.nombre, sa.ciudad, SUM(precio * (1 - COALESCE(descuento,0)/100)) AS "dinerogastado"
FROM cliente c JOIN reserva USING(id_cliente)
	JOIN vuelo v1 USING(id_vuelo)
	JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
GROUP BY c.nombre,c.apellido1,c.apellido2, sa.nombre, sa.ciudad,v1.precio,v1.descuento,v1.desde
HAVING SUM(precio * (1 - COALESCE(descuento,0)/100)) >= ALL (
													SELECT SUM(precio * (1 - COALESCE(descuento,0)/100)) AS "dinerogastado"
													FROM cliente c JOIN reserva USING(id_cliente)
														JOIN vuelo v2 USING(id_vuelo)
														JOIN aeropuerto sa ON(sa.id_aeropuerto = desde)
													WHERE v1.desde = v2.desde
													GROUP BY id_cliente,v2.precio,v2.descuento
															);*/
															
SELECT c.nombre, c.apellido1, c.apellido2,
        a.nombre, a.ciudad,  
        SUM(precio * (1 - (COALESCE(descuento,0)/100)))
FROM vuelo v1 JOIN reserva USING (id_vuelo)
        JOIN cliente c USING (id_cliente)
        JOIN aeropuerto a ON (desde = id_aeropuerto)
GROUP BY c.nombre, c.apellido1, c.apellido2,
        a.nombre, a.ciudad, v1.desde
HAVING SUM(precio *
           (1 - (COALESCE(descuento,0)/100))) >= ALL (
           SELECT SUM(precio * (1 -
                    (COALESCE(descuento,0)/100)))
           FROM vuelo v2 JOIN reserva USING (id_vuelo)
           WHERE v1.desde = v2.desde
           GROUP BY id_cliente
        );														
/*
3.- Seleccionar el piso que se ha vendido más caro de cada provincia. 
Debe aparecer la provincia, el nombre del comprador, la fecha de la operación y la cuantía.
*/

/*SELECT provincia,c.nombre,fecha_operacion,precio_final
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
ORDER BY provincia;*/

SELECT provincia, c.nombre,
        fecha_operacion, precio_final
FROM operacion JOIN inmueble i1 USING (id_inmueble)
        JOIN tipo ON (tipo_inmueble = id_tipo)
        JOIN comprador c USING (id_cliente)
WHERE tipo.nombre = 'Piso'
  AND tipo_operacion = 'Venta'
  AND precio_final >= ALL (
        SELECT precio_final
        FROM operacion JOIN
              inmueble i2 USING (id_inmueble)
            JOIN tipo ON (tipo_inmueble = id_tipo)
        WHERE tipo.nombre = 'Piso'
          AND i1.provincia = i2.provincia
              AND tipo_operacion = 'Venta'      
);

/*
4.- Seleccionar los alquileres más baratos de cada provincia y mes 
(da igual el día y el año). Debe aparecer el nombre de la provincia, 
el nombre del mes, el resto de atributos de la tabla inmueble y el precio final del alquiler. 
*/
/*SELECT id_inmueble,fecha_alta,tipo_inmueble,tipo_operacion,provincia,
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
ORDER BY provincia,EXTRACT(month FROM o1.fecha_operacion);*/
															
SELECT id_inmueble,fecha_alta,tipo_inmueble,tipo_operacion,provincia,
		superficie,precio,precio_final,TO_CHAR(o1.fecha_operacion,'Month')
FROM inmueble i JOIN operacion o1 USING(id_inmueble)
WHERE tipo_operacion = 'Alquiler'
	AND precio_final <= ALL(
				SELECT MIN(precio_final)
				FROM inmueble i2 JOIN operacion o2 USING(id_inmueble)
				WHERE tipo_operacion = 'Alquiler'
					AND i2.provincia = i.provincia
					AND EXTRACT(month FROM o1.fecha_operacion) = EXTRACT(month FROM o2.fecha_operacion)
							)
ORDER BY provincia,EXTRACT(month FROM o1.fecha_operacion);

