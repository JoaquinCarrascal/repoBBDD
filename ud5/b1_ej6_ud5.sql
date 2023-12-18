/*
EJERCICIO 6
*/

/*
1.- Selecciona, agrupando por vendedor, el precio final medio de 
pisos y casas que se han vendido en cada provincia. Debe 
aparecer el nombre del vendedor, la provincia y el precio medio.
*/
SELECT provincia, v.nombre, ROUND(AVG(precio_final), 2)
FROM vendedor v JOIN operacion USING(id_vendedor)
	JOIN inmueble USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE t.nombre IN ('Casa','Piso')
	AND tipo_operacion = 'Venta'
GROUP BY provincia, v.nombre
ORDER BY provincia;

/*
2.- Seleccionar la suma del precio final, agrupado por provincia,
de aquellos locales donde su precio sea superior al producto del 
número de metros cuadrados de ese local por el precio medio del 
metro cuadrado de los locales de esa provincia.
*/
WITH precio_medio_m2 AS (
	SELECT provincia, AVG(precio/superficie) AS "calc"
	FROM inmueble JOIN tipo t ON(tipo_inmueble = id_tipo)
	WHERE t.nombre = 'Local'
	GROUP BY provincia
)

SELECT provincia, SUM(precio_final)
FROM inmueble JOIN operacion USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
	JOIN precio_medio_m2 USING(provincia)
WHERE t.nombre = 'Local'
	AND precio_final > calc * superficie
GROUP BY provincia;

/*
3.- Selecciona la media de pisos vendidos al día que se han vendido 
en cada provincia. Es decir, debes calcular primero el número de 
pisos que se han vendido cada día de la semana en cada provincia, 
y después, sobre eso, calcular la media por provincia.
*/
WITH "contador_pisos" AS (
		SELECT i1.provincia, TO_CHAR(o1.fecha_operacion, 'Day') AS "dia_semana2", COUNT(*) AS "cuenta_pisos"
		FROM operacion o1 JOIN inmueble i1 USING(id_inmueble)
			JOIN tipo t ON(tipo_inmueble = id_tipo)	
		WHERE t.nombre = 'Piso'
			AND tipo_operacion = 'Venta'
		GROUP BY i1.provincia, dia_semana2
			)

SELECT i.provincia, TO_CHAR(o.fecha_operacion, 'Day') AS "dia_semana", ROUND(AVG(cuenta_pisos),2)
FROM operacion o JOIN inmueble i USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
	JOIN contador_pisos ON(contador_pisos.provincia=i.provincia)
WHERE t.nombre = 'Piso'
	AND contador_pisos.dia_semana2 = TO_CHAR(o.fecha_operacion, 'Day')
	AND tipo_operacion = 'Venta'
GROUP BY i.provincia, dia_semana;

/*
4.- Selecciona el cliente que ha comprado más barato cada tipo de 
inmueble (casa, piso, local, …). Debe aparecer el nombre del cliente, 
la provincia del inmueble, la fecha de operación, el precio final y 
el nombre del tipo de inmueble. ¿Te ves capaz de modificar la consulta 
para que en lugar de que salga el más barato, salgan los 3 más baratos?
*/
/*SELECT c.nombre, provincia, fecha_operacion,precio_final,t.nombre
FROM inmueble JOIN operacion USING (id_inmueble)
	JOIN tipo t ON (id_tipo=tipo_inmueble)
	JOIN comprador c USING (id_cliente)
WHERE precio_final IN (SELECT MIN(precio_final)
						FROM inmueble JOIN operacion o2 USING (id_inmueble)
							JOIN tipo t ON (id_tipo=tipo_inmueble)
					   WHERE tipo_operacion = 'Venta'
						GROUP BY t.nombre
					   	ORDER BY MIN(o2.precio_final)
					  	) AND tipo_operacion = 'Venta'
ORDER BY precio_final;*/ --Este es para 1 solo.

--Esta es para los 3 menores
SELECT c.nombre, i.provincia,fecha_operacion,precio_final,t.nombre
FROM comprador c JOIN operacion USING(id_cliente)
	JOIN inmueble i USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE tipo_operacion = 'Venta'
GROUP BY c.nombre, i.provincia,fecha_operacion,precio_final,t.nombre
HAVING precio_final IN (
		SELECT precio_final
		FROM comprador c2 JOIN operacion USING(id_cliente)
			JOIN inmueble i USING(id_inmueble)
			JOIN tipo t2 ON(tipo_inmueble = id_tipo)
		WHERE tipo_operacion = 'Venta'
			AND t.nombre = t2.nombre
		ORDER BY precio_final
		LIMIT 3
							)
ORDER BY t.nombre,precio_final;

/*
5.- De entre todos los clientes que han comprado un piso en 
Sevilla, selecciona a los que no han realizado ninguna 
compra en fin de semana.
*/
SELECT c.nombre
FROM comprador c JOIN operacion USING(id_cliente)
	JOIN inmueble USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE provincia = 'Sevilla'
	AND tipo_operacion = 'Venta'
	AND t.nombre = 'Piso'
	AND c.nombre NOT IN (
		SELECT c1.nombre
		FROM comprador c1 JOIN operacion o1 USING(id_cliente)
			JOIN inmueble USING(id_inmueble)
		WHERE EXTRACT(isodow FROM fecha_operacion) IN (6,7)
			AND tipo_operacion = 'Venta'
						);

/*
6.- El responsable de la inmobiliaria quiere saber el rendimiento 
de operaciones de alquiler que realiza cada vendedor durante 
los días de la semana (de lunes a sábado). Se debe mostrar el 
nombre del vendedor, el % del número de operaciones de alquiler 
que ha realizado en ese día de la semana ese vendedor y el precio 
medio por metro cuadrado de las operaciones de alquiler que ha 
realizado ese vendedor en ese día de la semana.
*/
WITH calculo_vendedor AS (SELECT id_vendedor, COUNT(*)::numeric/7::numeric AS "calculo", TO_CHAR(fecha_operacion, 'Day')
							 FROM vendedor JOIN operacion USING (id_vendedor)
							 	JOIN inmueble USING (id_inmueble)
							  WHERE EXTRACT(ISODOW from fecha_operacion) !=7
							  	AND tipo_operacion = 'Alquiler'
							 GROUP BY id_vendedor,TO_CHAR(fecha_operacion, 'Day')
							 ORDER BY id_vendedor
							 )
							 
SELECT v.nombre, ROUND(calculo,2), ROUND(AVG(precio_final/superficie),2)
FROM operacion o JOIN inmueble i USING (id_inmueble) 
	JOIN tipo t ON (i.tipo_inmueble = t.id_tipo)
	JOIN vendedor v USING (id_vendedor)
	JOIN calculo_vendedor USING (id_vendedor)
GROUP BY v.nombre,calculo;

/*
Elabora el enunciado de una consulta que incluya una su consulta 
correlacionada o que sea ideal para resolver con el operador WITH
*/
/*
Selecciona de cada provincia la fecha de operacion y el precio 
final de la venta de la casa mas barata.
*/
SELECT provincia,fecha_operacion, 
	precio_final
FROM operacion JOIN inmueble i1 USING (id_inmueble)
        JOIN tipo ON (tipo_inmueble = id_tipo)
        JOIN comprador c USING (id_cliente)
WHERE tipo.nombre = 'Casa'
  AND tipo_operacion = 'Venta'
  AND precio_final <= ALL (
        SELECT precio_final
        FROM operacion JOIN
              inmueble i2 USING (id_inmueble)
            JOIN tipo ON (tipo_inmueble = id_tipo)
        WHERE tipo.nombre = 'Casa'
          AND i1.provincia = i2.provincia
              AND tipo_operacion = 'Venta'      
);
