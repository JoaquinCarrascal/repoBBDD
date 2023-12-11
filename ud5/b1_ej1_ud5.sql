

/*1.- Seleccionar el salario máximo de cada departamento, 
mostrando el nombre del departamento y dicha cantidad.*/

SELECT department_name, MAX(salary)
FROM departments JOIN employees USING(department_id)
GROUP BY department_name
ORDER BY MAX(salary) DESC;

/*2.- Seleccionar el salario mínimo de cada departamento, 
para aquellos departamentos cuyo salario mínimo 
sea menor que 5000$.*/

SELECT department_name, MIN(salary)
FROM departments JOIN employees USING(department_id)
GROUP BY department_name
HAVING MIN(salary) < 5000 --Cuando la condición es de un operador casi seguramente va en el having
ORDER BY MIN(salary) DESC;

/*3.- Seleccionar el número de empleados que trabajan en cada 
oficina, mostrando el STREET_ADDRESS y dicho número; 
hay que ordenar la salida de mayor a menor.*/

SELECT street_address, COUNT(employee_id)
FROM locations JOIN departments USING(location_id)
	JOIN employees USING(department_id)
GROUP BY street_address
ORDER BY COUNT(employee_id) DESC;

--departamento sin empleado
SELECT department_name, COALESCE(COUNT(employee_id),0)
FROM employees RIGHT JOIN departments USING(department_id)
	JOIN locations USING(location_id)
WHERE employee_id IS NULL
GROUP BY department_name
ORDER BY COUNT(employee_id) DESC;

/*4.- Modificar la consulta anterior para que muestre 
las localizaciones que no tienen ningún empleado.*/

SELECT COALESCE(street_address, 'Sin ubicación'),
                count(employee_id) as "num_empleados"
FROM employees FULL JOIN departments
        USING (department_id)
        FULL JOIN locations USING (location_id)
GROUP BY street_address
ORDER BY num_empleados DESC;

/*5.- Seleccionar el salario que es cobrado a la vez 
por más personas. Mostrar dicho salario y el número de personas.*/

SELECT salary, COUNT(employee_id)
FROM employees
GROUP BY salary
ORDER BY COUNT(employee_id) DESC
LIMIT 1;

/*6.- Seleccionar el número de empleados que empezaron a 
trabajar cada año, ordenando la salida por el año.*/

SELECT EXTRACT(year FROM hire_date) AS "anio", COUNT(employee_id)
FROM employees
GROUP BY anio
ORDER BY anio;

