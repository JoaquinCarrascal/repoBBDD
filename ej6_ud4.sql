
/*
1.- Selecciona el top 3 de pisos vendidos más caros 
en Sevilla a lo largo del año 2019 
(puedes investigar el uso de LIMIT para hacerlo)
*/

SELECT i.*
FROM inmueble i JOIN tipo t ON(id_tipo = tipo_inmueble)
	JOIN operacion USING(id_inmueble)
WHERE EXTRACT(year FROM fecha_operacion) = 2019
	AND provincia = 'Sevilla'
	AND t.nombre = 'Piso'
	AND tipo_operacion = 'Venta'
ORDER BY precio_final DESC
LIMIT 3;

/*
2.- Selecciona el precio medio de los alquileres 
en Málaga en los meses de Julio y 
Agosto (da igual de qué año).
*/

SELECT ROUND(AVG(precio_final),2) || '€' AS "Precio medio de los alquileres en Málaga"
FROM inmueble i JOIN operacion USING(id_inmueble)
WHERE provincia = 'Málaga'
	AND DATE_PART('month',fecha_operacion) IN (7,8)
	AND tipo_operacion = 'Alquiler';
	
/*
3.- Selecciona los inmuebles que se han vendido en 
Jaén y Córdoba en los últimos 3 meses del año 2019 o 2020.
*/

SELECT *
FROM inmueble JOIN operacion USING(id_inmueble)
WHERE tipo_operacion = 'Venta'
	AND provincia IN ('Jaén' , 'Córdoba')
	AND EXTRACT(year FROM fecha_operacion) IN (2019 , 2020)
	AND TO_CHAR(fecha_operacion, 'Q') = '4';
	
/*
4.- Selecciona el precio medio de las ventas de Parking 
en la provincia de Huelva para aquellas operaciones 
que se realizaran entre semana (de Lunes a Viernes).
*/

SELECT ROUND(AVG(precio_final),2) || '€' 
FROM inmueble i JOIN operacion USING(id_inmueble)
	JOIN tipo t ON(id_tipo = tipo_inmueble)
WHERE tipo_operacion = 'Venta'
	AND t.nombre = 'Parking'
	AND provincia = 'Huelva'
	AND DATE_PART('DOW',fecha_operacion) BETWEEN 1 AND 5;
	
/*
5.- Selecciona aquellos pisos que han tardado 
en venderse entre 3 y 6 meses en la provincia de Granada.
*/

SELECT i.*,fecha_operacion
FROM inmueble i JOIN operacion USING(id_inmueble)
	JOIN tipo t ON(id_tipo = tipo_inmueble)
WHERE provincia = 'Granada'
	AND fecha_operacion BETWEEN fecha_alta + '3 month'::interval AND fecha_alta + '6 month'::interval
	AND t.nombre = 'Piso'
	AND tipo_operacion = 'Venta';
	
/*
Selecciona el precio medio de los alquileres de pisos
en la provincia de Málaga que no fuesen gestionados por la
vendedora Carmen, en el año 2021.
*/

SELECT ROUND(AVG(precio_final))
FROM inmueble i JOIN tipo t ON(id_tipo = tipo_inmueble)
	JOIN operacion USING(id_inmueble)
	JOIN vendedor v USING(id_vendedor)
WHERE EXTRACT(year FROM fecha_operacion) = 2021
	AND provincia = 'Málaga'
	AND t.nombre = 'Piso'
	AND tipo_operacion = 'Alquiler'
	AND v.nombre != 'Carmen';