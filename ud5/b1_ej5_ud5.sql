/*
EJERCICIO 5
*/

/*
1.- Selecciona la media, agrupada por nombre de aeropuerto de salida, 
del % de ocupación de los vuelos. PISTA: tendrás que incluir una 
subconsulta dentro de otra y, en la interior, usar una subconsulta 
en el select :S (o bien usar WITH)
*/
WITH porcentocup AS (
	SELECT id_vuelo, COUNT(id_reserva) AS "ocup"
	FROM avion JOIN vuelo USING(id_avion) 
		JOIN reserva USING(id_vuelo)
	GROUP BY id_vuelo,max_pasajeros
), porcentajecalc AS (
	SELECT id_vuelo,ocup*100/max_pasajeros AS "calc"
	FROM avion JOIN vuelo USING(id_avion) 
		JOIN reserva USING(id_vuelo)
		JOIN porcentocup USING (id_vuelo)
	GROUP BY id_vuelo,max_pasajeros,ocup
						)

SELECT o.nombre, ROUND(AVG(calc),2)||'%'
FROM vuelo JOIN aeropuerto o ON(o.id_aeropuerto = desde)
	JOIN porcentajecalc USING(id_vuelo)
GROUP BY o.nombre;

/*
2.- Selecciona el tráfico de pasajeros (es decir, personas 
que han llegado en un vuelo o personas que han salido en un 
vuelo) agrupado por mes (independiente del año) y aeropuerto. 
INVESTIGA: Tienes que hacer uso de la cláusula UNION, y 
piensa en hacer primero el tráfico de salida, después 
el de llegada (en consultas diferentes pero casi idénticas) 
y posteriormente en sumarlo.
*/

SELECT ciudad, SUM(trafico)
FROM (
    SELECT ciudad, EXTRACT(month FROM llegada),
            COUNT(*) as "trafico"
    FROM reserva JOIN vuelo USING (id_vuelo)
            JOIN aeropuerto ON (hasta = id_aeropuerto)
    GROUP BY ciudad, EXTRACT(month FROM llegada)
    UNION
    SELECT ciudad, EXTRACT(month FROM salida),
            COUNT(*) as "trafico"
    FROM reserva JOIN vuelo USING (id_vuelo)
            JOIN aeropuerto ON (desde = id_aeropuerto)
    GROUP BY ciudad, EXTRACT(month FROM salida)
)
GROUP BY ciudad;
/*
3.- Suponiendo que el 30% del precio de cada billete son beneficios 
(y el 70% son gastos), ¿cuál es el trayecto que más rendimiento 
económico da? Es decir, ¿en qué trayecto estamos ganando más dinero? 
¿Y con el que menos? Lo puedes hacer en consultas diferentes usando WITH
*/
/*WITH beneficio AS (
	SELECT id_vuelo,precio * (1 - COALESCE(descuento,0)/100) * 30 / 100 AS "maxim"
	FROM vuelo JOIN aeropuerto o ON (o.id_aeropuerto = desde)
		JOIN aeropuerto d ON (d.id_aeropuerto = hasta)
	GROUP BY o.nombre,d.nombre,precio,descuento,id_vuelo
					)
	
SELECT DISTINCT o.nombre,d.nombre,  ROUND(maxim,2)
FROM vuelo JOIN aeropuerto o ON (o.id_aeropuerto = desde)
	JOIN aeropuerto d ON (d.id_aeropuerto = hasta) 
	JOIN beneficio USING(id_vuelo)
WHERE maxim <= ALL(
			SELECT maxim FROM beneficio
					)
	OR maxim >= ALL(
			SELECT maxim FROM beneficio
					);*/
					
WITH rendimiento_por_trayecto AS (
    SELECT s.ciudad, ll.ciudad,
        ROUND(0.3 * SUM(precio * (1 -
                (COALESCE(descuento,0)/100.0))),2) AS "rendimiento"
    FROM vuelo JOIN reserva USING (id_vuelo)
            JOIN aeropuerto s ON (desde = s.id_aeropuerto)
            JOIN aeropuerto ll ON (hasta = ll.id_aeropuerto)
    GROUP BY s.ciudad, ll.ciudad
), rendimiento_maximo AS (
    SELECT MAX(rendimiento) as "maximo"
    FROM rendimiento_por_trayecto
), agrupador AS (
	SELECT 
)
SELECT *
FROM rendimiento_por_trayecto
WHERE rendimiento = (
                        SELECT maximo
                        FROM rendimiento_maximo
                    );
					
					--con union
WITH rendimiento_por_trayecto AS (
    SELECT s.ciudad, ll.ciudad,
        ROUND(0.3 * SUM(precio * (1 -
                (COALESCE(descuento,0)/100.0))),2) AS "rendimiento"
    FROM vuelo JOIN reserva USING (id_vuelo)
            JOIN aeropuerto s ON (desde = s.id_aeropuerto)
            JOIN aeropuerto ll ON (hasta = ll.id_aeropuerto)
    GROUP BY s.ciudad, ll.ciudad
), rendimiento_maximo AS (
    SELECT MAX(rendimiento) as "maximo"
    FROM rendimiento_por_trayecto
), rendimiento_minimo AS (
    SELECT MIN(rendimiento) as "minimo"
    FROM rendimiento_por_trayecto
)
SELECT *, 'max' as "valor"
FROM rendimiento_por_trayecto
WHERE rendimiento = (
                        SELECT maximo
                        FROM rendimiento_maximo
                    )
UNION
SELECT *, 'min'
FROM rendimiento_por_trayecto
WHERE rendimiento = (
                        SELECT minimo
                        FROM rendimiento_minimo
                    );

/*
4.- Seleccionar el nombre y apellidos de los clientes que no 
han hecho ninguna reserva para un vuelo que salga en el tercer 
trimestre desde Sevilla.
*/
SELECT DISTINCT c.nombre, c.apellido1,c.apellido2--,o.ciudad
FROM cliente c JOIN reserva USING(id_cliente)
	JOIN vuelo USING (id_vuelo)
	JOIN aeropuerto o ON (o.id_aeropuerto = desde)
WHERE id_cliente NOT IN (
		SELECT id_cliente
		FROM reserva JOIN vuelo USING (id_vuelo)
			JOIN aeropuerto o1 ON (o1.id_aeropuerto = desde)
		WHERE o1.ciudad = 'Sevilla'
		AND EXTRACT(mon FROM salida) BETWEEN 7 AND 9
							);
							--este era innecesario
SELECT DISTINCT c.nombre, c.apellido1,c.apellido2,o.ciudad
FROM cliente c JOIN reserva USING(id_cliente)
	JOIN vuelo USING (id_vuelo)
	JOIN aeropuerto o ON (o.id_aeropuerto = desde)
WHERE id_cliente NOT IN (
		SELECT id_cliente
		FROM cliente c JOIN reserva USING(id_cliente)
			JOIN vuelo USING (id_vuelo)
			JOIN aeropuerto o1 ON (o1.id_aeropuerto = desde)
		WHERE o1.ciudad = 'Sevilla'
		AND EXTRACT(mon FROM salida) BETWEEN 7 AND 9
							)
							
/*
5.- Selecciona el nombre y apellidos de aquellos clientes cuyo 
gasto en reservas de vuelos con origen en España (Sevilla, 
Málaga, Madrid, Bilbao y Barcelona) ha sido superior a la 
media total de gasto de vuelos con origen fuera de España.
*/						
SELECT DISTINCT c.nombre, c.apellido1,c.apellido2
FROM cliente c JOIN reserva USING(id_cliente)
	JOIN vuelo USING (id_vuelo)
	JOIN aeropuerto o ON (o.id_aeropuerto = desde)
WHERE o.ciudad IN ('Sevilla','Málaga','Madrid','Bilbao','Barcelona')
	AND precio * (1 - COALESCE(descuento,0)/100) > (
					SELECT AVG(precio * (1 - COALESCE(descuento,0)/100))
					FROM cliente c JOIN reserva USING(id_cliente)
						JOIN vuelo USING (id_vuelo)
						JOIN aeropuerto o1 ON (o1.id_aeropuerto = desde)
					WHERE o1.ciudad NOT IN ('Sevilla','Málaga','Madrid','Bilbao','Barcelona')
									)
									
--EJERCICIO EXTRA
WITH por_cliente AS (
    SELECT customer_id, SUM(unit_price * quantity * (1 - discount)) as "importe"
    FROM orders JOIN order_details USING (order_id)
    GROUP BY customer_id
), media_ventas AS (
    SELECT AVG(importe) as "media"
    FROM por_cliente
)
SELECT company_name, importe,
    (select media from media_ventas),
	CASE
		WHEN importe < 40*(select media from media_ventas)/100 THEN 'Poco gasto'
		WHEN importe >= 40*(select media from media_ventas)/100 
			AND importe <= 60*(select media from media_ventas)/100 THEN 'Gasto normal'
		WHEN importe > 60*(select media from media_ventas)/100 THEN 'Mucho gasto'
		ELSE 'No podemos evaluar estos datos'
	END
FROM customers JOIN por_cliente USING (customer_id);

	
														




	
