SELECT *
FROM climatologia;

--ejercicio 1
SELECT ROUND(AVG(precipitacion_total), 2)
FROM climatologia
WHERE estacion IN('Huesca' , 'Zaragoza' , 'Teruel')
	AND precipitacion_total < 20
	AND fecha::text ILIKE '2019-06%';
	
--ejercicio 2
SELECT *, precipitacion_0_a_6 || '+' || precipitacion_6_a_12 || '+' || precipitacion_12_a_18 || '+' || precipitacion_18_a_24 || '=' || 
			(precipitacion_0_a_6 + precipitacion_6_a_12 + precipitacion_12_a_18 + precipitacion_18_a_24) AS "comprobación de suma total"
FROM climatologia
WHERE (estacion ILIKE '%f%' OR estacion ILIKE '%t%' OR estacion ILIKE '%x%')
	AND fecha::text ILIKE '2019-02%';
	
--ejercicio 3
SELECT *
FROM climatologia
WHERE LEFT(estacion, 2) = 'Ba'
	AND temperatura_maxima BETWEEN 25 AND 30
	AND temperatura_minima < 15
	AND LEFT(fecha::text, 7) IN ('2019-09' , '2019-10');

--ejercicio 4
SELECT estacion, provincia, fecha, racha_viento,
	CASE
		WHEN racha_viento > 25 AND racha_viento <= 40 THEN 'Ventoso'
		WHEN racha_viento > 40 AND racha_viento <= 60 THEN 'Muy ventoso'
		WHEN racha_viento > 60 THEN 'Huracanado'
		ELSE 'Calmado/poco viento'
	END AS "Informacion adicional del viento"
FROM climatologia
WHERE racha_viento > 25
	AND hora_racha_viento ILIKE '15:00'
	AND LEFT(fecha::text,7) IN ('2019-03' , '2019-04')
	AND temperatura_maxima > 23
ORDER BY racha_viento DESC;

--ejercicio 5
SELECT provincia, estacion, fecha, velocidad_maxima_viento, racha_viento,
	ROUND((((temperatura_maxima - temperatura_minima)*100) / temperatura_maxima), 2) || '%' AS "Diferencia temp_min temp_max"
FROM climatologia
WHERE (((temperatura_maxima - temperatura_minima)*100) / temperatura_maxima)::numeric BETWEEN 20 AND 30
	AND temperatura_minima > 10
ORDER BY provincia DESC, estacion DESC, fecha;

	
	