/*
EJERCICIO 3
*/

/*
1.- Seleccionar los 3 aeropuertos que menos tráfico de llegada 
(menos personas llegando a ellos en un vuelo) han registrado 
en un mes de Enero, Febrero o Marzo
*/
SELECT alleg.nombre, alleg.id_aeropuerto, COUNT(id_reserva)
FROM vuelo JOIN aeropuerto alleg ON(hasta = id_aeropuerto)
	JOIN reserva USING(id_vuelo)
WHERE EXTRACT(month FROM llegada) IN (1,2,3)
GROUP BY alleg.nombre, alleg.id_aeropuerto
ORDER BY COUNT(id_reserva)
LIMIT 3;

/*
2.- Selecciona los clientes que han comprado casas en 
Almería, siendo el precio final mayor que el precio 
medio de las casas vendidas en Almería.
*/
SELECT DISTINCT c.*
FROM inmueble i JOIN tipo t ON(id_tipo = tipo_inmueble)
	JOIN operacion USING(id_inmueble)
	JOIN comprador c USING(id_cliente)
WHERE t.nombre = 'Casa' 
	AND i.tipo_operacion = 'Venta' 
	AND provincia = 'Almería'
	AND precio_final > (
		SELECT AVG(precio_final)
		FROM inmueble i JOIN tipo t ON(id_tipo = tipo_inmueble)
			JOIN operacion USING(id_inmueble)
		WHERE t.nombre = 'Casa' 
		AND i.tipo_operacion = 'Venta' 
		AND provincia = 'Almería'
						);

/*
3.- Selecciona de todos los vendedores a aquellos que 
solo vendieron inmuebles de tipo Parking
*/
SELECT v.*
FROM vendedor v
WHERE id_vendedor NOT IN (
			SELECT DISTINCT id_vendedor
			FROM vendedor JOIN operacion USING(id_vendedor)
					JOIN inmueble i USING(id_inmueble)
					JOIN tipo t ON(id_tipo = tipo_inmueble)
			WHERE i.tipo_operacion = 'Venta'
				AND t.nombre != 'Parking'
				);
				
/*
4.- Selecciona el origen y el destino de los 10 vuelos con 
una duración menor. Debes realizarlo usando subconsultas.
*/
SELECT DISTINCT id_vuelo, asalida.nombre AS "salida" ,allegada.nombre AS "llegada"
		--MAKE_TIME(EXTRACT(hour FROM llegada)::numeric,
		--EXTRACT(min FROM llegada)::numeric, (( intento fallido ): ))
		--EXTRACT(sec FROM llegada)::numeric) AS "duracion"
FROM vuelo JOIN aeropuerto asalida ON(desde = asalida.id_aeropuerto)
		   JOIN aeropuerto allegada ON(hasta = allegada.id_aeropuerto)
WHERE id_vuelo IN (
		SELECT id_vuelo
	FROM vuelo JOIN aeropuerto asalida ON(desde = asalida.id_aeropuerto)
		   JOIN aeropuerto allegada ON(hasta = allegada.id_aeropuerto)
	ORDER BY llegada-salida
	LIMIT 10
				);
				
/*
5.- Selecciona el importe que la aerolínea de la base de datos 
de vuelos ha ingresado por cada uno de los vuelos que se han 
realizado en fin de semana (es decir, que han salido entre 
viernes y domingo) en los meses de Julio y Agosto (da igual el año).
*/
SELECT SUM(preciofinal)||'€' AS "dinero ganado total"
FROM(
	SELECT id_vuelo,precio,COUNT(id_reserva),precio*COUNT(id_reserva)*(1-COALESCE(descuento/100,0)) AS "preciofinal"
	FROM vuelo JOIN reserva USING(id_vuelo)
	WHERE EXTRACT(isodow FROM salida) IN (5,6,7) --no era lo que se pedía
	AND EXTRACT(mon FROM salida) IN (7,8)
	GROUP BY id_vuelo,precio
	);
	
SELECT id_vuelo,
    SUM(precio * (1 - COALESCE(descuento,0)/100))
FROM vuelo JOIN reserva USING(id_vuelo)
WHERE EXTRACT(isodow FROM salida) IN (5,6,7)
  AND EXTRACT(month FROM salida) IN (7,8)
GROUP BY id_vuelo;




