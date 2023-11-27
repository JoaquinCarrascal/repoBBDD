/*(HR) Selecciona el número de empleados que fueron contratados en el año 1997 en la que trabajen en una oficina situada en Bélgica.
(HR) Selecciona la media de salario máximo de los trabajadores de Administration en Asia.
(INMO) Selecciona el nombre del comprador, el nombre del vendedor, la provincia y la fecha de operación de las viviendas (casa y piso) alquiladas en el tercer trimestre de año en las provincias de Huelva, Sevilla y Almería. Ordena la salida por fecha de operación descendentemente.
(INMO) Modifica la consulta anterior para que las viviendas que fueran vendidas en un plazo de entre 35 y 45 días desde que se dieron de alta en la inmobiliaria.
(INMO) Calcula el precio máximo y precio mínimo por metro cuadrado de venta de inmuebles que no sean viviendas (no sean Piso o Casa) en provincias que contengan una n (mayúscula o minúscula), siempre que los inmuebles se hayan vendido en un mes que escrito de forma completa en inglés tenga entre 5 y 7 caracteres.
(VUELOS) ¿Cuál es el descuento medio obtenido en vuelos donde el origen sea España y el destino fuera de España, siempre que estos vuelos no se hayan realizado en fin de semana (contaremos como fin de semana los Viernes a partir de las 15:00)?
*/

--1.-(HR) Selecciona el número de empleados que fueron 
--contratados en el año 1997 en la que trabajen en una oficina situada en Bélgica.
SELECT COUNT(e.*)
FROM employees e RIGHT JOIN departments USING(department_id)
	RIGHT JOIN locations USING(location_id)
	RIGHT JOIN countries USING(country_id)
WHERE country_name = 'Belgium'
	AND DATE_PART('month' , hire_date) = 1997;
	
--2.-(HR) Selecciona la media de salario máximo 
--de los trabajadores de Administration en Asia.
SELECT AVG(max_salary)
FROM employees e JOIN jobs USING(job_id)
	JOIN departments USING(department_id)
	JOIN locations USING(location_id)
	JOIN countries USING(country_id)
	JOIN regions USING(region_id)
WHERE region_name = 'Asia'
	AND department_name = 'Administration';

--3.-(INMO) Selecciona el nombre del comprador, el nombre del vendedor, la provincia 
--y la fecha de operación de las viviendas (casa y piso) alquiladas en el tercer 
--trimestre de año en las provincias de Huelva, Sevilla y Almería. Ordena la 
--salida por fecha de operación descendentemente.
SELECT c.nombre,v.nombre,provincia,fecha_operacion
FROM comprador c JOIN operacion USING(id_cliente)
	JOIN vendedor v USING(id_vendedor)
	JOIN inmueble i USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE t.nombre IN ('Casa' , 'Piso')
	AND i.tipo_operacion = 'Alquiler'
	AND provincia IN ('Huelva' , 'Sevilla' , 'Almería')
	AND DATE_PART('month', fecha_operacion) IN (7,8,9)
	--AND TO_CHAR(fecha_operacion, 'Q') = '3'
ORDER BY fecha_operacion DESC;

--4.-(INMO) Modifica la consulta anterior para que las viviendas que 
--fueran vendidas en un plazo de entre 35 y 45 días desde que se 
--dieron de alta en la inmobiliaria.
SELECT c.nombre,v.nombre,provincia,fecha_operacion
FROM comprador c JOIN operacion USING(id_cliente)
	JOIN vendedor v USING(id_vendedor)
	JOIN inmueble i USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE t.nombre IN ('Casa' , 'Piso')
	AND i.tipo_operacion = 'Alquiler'
	AND provincia IN ('Huelva' , 'Sevilla' , 'Almería')
	AND DATE_PART('month', fecha_operacion) IN (7,8,9)
	AND AGE(fecha_alta , fecha_operacion) BETWEEN '35 day'::interval AND '45 day'::interval
	--AND fecha_operacion BETWEEN fecha_alta + 35 AND fecha_alta + 45
ORDER BY fecha_operacion DESC;

--5.-(INMO) Calcula el precio máximo y precio mínimo por metro cuadrado 
--de venta de inmuebles que no sean viviendas (no sean Piso o Casa) en 
--provincias que contengan una n (mayúscula o minúscula), siempre que los 
--inmuebles se hayan vendido en un mes que escrito de forma completa en inglés tenga entre 5 y 7 caracteres.
SELECT ROUND(MAX(precio/superficie), 2), ROUND(MIN(precio/superficie), 2)
FROM operacion JOIN inmueble i USING(id_inmueble)
	JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE t.nombre NOT IN ('Casa' , 'Piso')
	AND tipo_operacion = 'Venta'
	AND provincia ILIKE '%n%'
	AND LENGTH(RTRIM(TO_CHAR(fecha_operacion , '/*FM*/Month'),' ')) BETWEEN 5 AND 7;

--6.- (VUELOS) ¿Cuál es el descuento medio obtenido en vuelos donde el origen sea 
--España y el destino fuera de España, siempre que estos vuelos no se hayan 
--realizado en fin de semana (contaremos como fin de semana los Viernes a partir de las 15:00)?

SELECT ROUND(AVG(COALESCE(descuento , 0)), 2) || '€' AS "Precio medio de descuento"
FROM vuelo JOIN aeropuerto s ON(desde = s.id_aeropuerto)
	JOIN aeropuerto l ON(hasta = l.id_aeropuerto)
WHERE s.ciudad IN ('Sevilla' , 'Bilbao' , 'Barcelona' , 'Madrid', 'Málaga')
	AND l.ciudad NOT IN ('Sevilla' , 'Bilbao' , 'Barcelona' , 'Madrid', 'Málaga')
	AND ((DATE_PART('DOW' , salida) < 5 AND DATE_PART('DOW' , salida) > 0)
		OR (DATE_PART('DOW' , salida) = 5 AND DATE_PART('hour' , salida) < 15))
	AND ((DATE_PART('DOW' , llegada) < 5 AND DATE_PART('DOW' , llegada) > 0)
		OR (DATE_PART('DOW' , llegada) = 5 AND DATE_PART('hour' , llegada) < 15));
