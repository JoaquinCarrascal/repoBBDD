/*vuelos2*/
/*seleccionar la media de vuelos que sale cada dia, 
independientemente del aeropuerto que salga el vuelo*/

SELECT dow , ROUND(AVG(cant),2)
FROM(
	SELECT TO_CHAR(salida , 'day') as "dow", salida::date, 
			COUNT(*) as "cant",EXTRACT(isodow FROM salida) as "numdia"
	FROM vuelo
	GROUP BY dow, salida::date,numdia
	ORDER BY numdia
	)
	GROUP BY dow,numdia
	ORDER BY numdia;
	
/*demografía*/
/*la provincia y el año con el mayor 
número de habitantes para cada provincia*/
SELECT provincia, anio, hombres + mujeres AS "suma"
FROM demografia_basica db1
WHERE hombres + mujeres >= ALL(
	SELECT hombres + mujeres
	FROM demografia_basica db2
	WHERE db1.provincia = db2.provincia
							)
ORDER BY provincia;

/*northwind*/
/*seleccionar el producto de cada
categoria del que mas unidades
se han vendido, debe aparecer, nombre categoria,
nombre producto y nºtotal de unidades*/

SELECT category_name, product_name, SUM(quantity)
FROM categories c JOIN products USING (category_id)
	JOIN order_details USING (product_id)
GROUP BY category_name ,product_name
HAVING SUM(quantity) >= ALL(
			SELECT SUM(quantity)
			FROM categories c2 JOIN products USING (category_id)
			JOIN order_details USING (product_id)
			WHERE c.category_name = c2.category_name
			GROUP BY category_name ,product_name
							);
	
/*HR*/
SELECT /* * , */ ROUND(AVG(maxsalary),2)
FROM(SELECT department_name, MAX(salary) as "maxsalary"
FROM departments JOIN employees USING (department_id)
GROUP BY department_name);

/*Seleccionar el numero medio de empleados que tiene cada departamento*/

SELECT ROUND(AVG(empleados),0)
FROM (
	SELECT COUNT(*) as "empleados"
	FROM employees
	GROUP BY department_id
	);
	
SELECT *
FROM employees
WHERE salary > ALL (/*en este caso sería mayor que 
					cualquiera(los compara todos)*/ 
			SELECT salary
			FROM employees JOIN departments
					USING (department_id)
			WHERE department_name = 'Purchasing'
					);

