/*1.- Selecciona los datos del inmueble sobre el que se 
ha realizado una operación un lunes de febrero o un 
viernes de marzo, que tenga más de 200 metros cuadrados 
y donde el nombre del vendedor contenga una A mayúscula 
o minúscula.*/

SELECT i.*
FROM inmueble i JOIN operacion o USING(id_inmueble)
	JOIN vendedor v USING(id_vendedor)
WHERE (((date_part('DOW' , o.fecha_operacion)) = 1 AND (date_part('Month' , o.fecha_operacion)) = 2) 
	   OR((date_part('DOW' , o.fecha_operacion)) = 5 AND (date_part('Month' , o.fecha_operacion)) = 3))
	   AND i.superficie > 200
	   AND UPPER(v.nombre) = 'A';
	   
/*2.- Selecciona el precio medio por metro cuadrado de los
alquileres de viviendas en los meses de marzo y abril de
cualquier año para las provincias costeras de Andalucía.*/

SELECT ROUND(AVG(i.precio/i.superficie),2)
FROM inmueble i JOIN tipo t ON(i.tipo_inmueble = t.id_tipo)
WHERE t.nombre IN ('Piso' , 'Casa')
	AND i.tipo_operacion = 'Alquiler'
	AND date_part('Month' , i.fecha_alta) IN (3 , 4)
	AND i.provincia IN ('Cádiz','Málaga','Almería','Huelva','Granada');
	
	
/*3.- ¿Cuál es la media del porcentaje de diferencia entre 
el precio inicial (en la tabla inmueble) y el precio final 
(en la tabla operación) para aquellas operaciones de alquiler 
realizadas en enero de cualquier año, donde el tipo del inmueble 
es Oficina, Local o Suelo?*/

SELECT ROUND (AVG((i.precio/o.precio_final)),2)
FROM inmueble i JOIN operacion o  USING (id_inmueble)
	JOIN tipo t ON (tipo_inmueble=t.id_tipo)
WHERE TO_CHAR(o.fecha_operacion,'MM') IN ('01')
	AND t.nombre IN ('Oficina','Local','Suelo');
	

	
/*4.- Seleccionar el nombre de aquellos compradores de Casa o 
Piso en las provincias de Jaén o Córdoba, donde el precio 
final de inmueble esté entre 150.000 y 200.000€, para aquellos 
inmuebles que han tardado entre 3 y 4 meses en venderse.*/

SELECT c.nombre
FROM inmueble i JOIN tipo t ON (tipo_inmueble=t.id_tipo)
				JOIN  operacion o USING (id_inmueble)
				JOIN comprador c USING (id_cliente)
WHERE tipo_operacion = 'Venta'
	AND provincia IN ('Jaén','Córdoba')
	AND t.nombre IN ('Casa','Piso')
	AND precio_final BETWEEN 150000 AND 200000
	AND fecha_operacion-fecha_alta BETWEEN 90 AND 120;

/*5.- Selecciona la media del precio inicial (en la tabla inmueble), 
del precio final (en la tabla operación) y de la diferencia en porcentaje
entre ellas de aquellas viviendas (Casa o Piso) en alquiler que tengan 
menos de 100 metros cuadrados y que hayan tardado un año o más en alquilarse.*/

SELECT ROUND(AVG (i.precio),2) AS "i.med_prec_fin", 
    ROUND(AVG (o.precio_final),2) AS "o.media_precio_final",
    ROUND(AVG ((i.precio / o.precio_final)*100),2) AS "porcentaje_precio"
FROM inmueble i JOIN operacion o USING (id_inmueble)
        JOIN tipo t ON (i.tipo_inmueble = t.id_tipo)
WHERE  t.nombre IN ('Casa','Piso')
  AND i.superficie > 100
  AND fecha_operacion-fecha_alta BETWEEN 365 AND 700000;

/*Selecciona el alquiler de vivienda (Casa o Piso) más caro 
realizado en Julio o Agosto de cualquier año en la provincia de Huelva.*/

SELECT MAX (o.precio_final)
FROM operacion o  JOIN inmueble i USING (id_inmueble)
WHERE TO_CHAR(fecha_operacion,'MM') IN ('08','09')
	AND provincia = 'Huelva';
	
