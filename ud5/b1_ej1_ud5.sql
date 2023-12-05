

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
WHERE salary < 5000
GROUP BY department_name
ORDER BY MIN(salary) DESC;

/*3.- Seleccionar el número de empleados que trabajan en cada 
oficina, mostrando el STREET_ADDRESS y dicho número; 
hay que ordenar la salida de mayor a menor.*/

SELECT street_address, COUNT(employee_id)
FROM locations JOIN departments USING(location_id)
	JOIN employees USING(department_id)
GROUP BY street_address
ORDER BY COUNT(employee_id) DESC;

/*4.- Modificar la consulta anterior para que muestre 
las localizaciones que no tienen ningún empleado.*/

SELECT street_address, COUNT(employee_id)
FROM locations LEFT JOIN departments USING(location_id)
	JOIN employees USING(department_id)
GROUP BY street_address
ORDER BY COUNT(employee_id) DESC;

/*5.- Seleccionar el salario que es cobrado a la vez 
por más personas. Mostrar dicho salario y el número de personas.*/

SELECT salary, COUNT(employee_id)
FROM departments JOIN employees USING(department_id)
GROUP BY salary
ORDER BY COUNT(employee_id) DESC
LIMIT 1;

/*6.- Seleccionar el número de empleados que empezaron a 
trabajar cada año, ordenando la salida por el año.*/

SELECT EXTRACT(year FROM hire_date) AS "anio", COUNT(employee_id)
FROM employees
GROUP BY anio
ORDER BY anio;

