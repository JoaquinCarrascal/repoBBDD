--1.- Seleccionar el nombre, apellidos y email de los empleados 
--que pertenecen a un departamento que tenga sede en United Kingdom.

SELECT e.first_name,e.last_name,e.email
FROM employees e JOIN departments d USING (department_id)
	JOIN locations l USING (location_id)
	JOIN countries c USING (country_id)
WHERE c.country_name = 'United Kingdom';

--2.- Seleccionar el nombre de aquellos departamentos en los que 
--trabaja un empleado que fue contratado a lo largo del año 1993.

SELECT DISTINCT d.department_name
FROM departments d JOIN employees e USING (department_id)
WHERE LEFT(e.hire_date::text, 4)::numeric = 1993;

--3.- Seleccionar la región de los empleados con un salario inferior a 10000$

SELECT DISTINCT r.region_name
FROM departments d JOIN employees e USING (department_id)
	JOIN locations l USING (location_id)
	JOIN countries c USING (country_id)
	JOIN regions r USING (region_id)
WHERE e.salary < 10000;

--4.- Seleccionar el nombre de aquellos empleados cuyo jefe directo tenga un apellido que empiece por D, H o S.

SELECT e.first_name, e.last_name
FROM employees e JOIN employees j ON (e.manager_id = j.employee_id)
WHERE LEFT(UPPER(j.last_name), 1) IN ('D', 'H', 'S');

--5.- Seleccionar el número de familiares (dependents) que son hijos de algún 
--miembro de los departamentos de Marketing, Administration e IT.

SELECT COUNT(*)
FROM dependents JOIN employees USING(employee_id)
	   JOIN departments USING (department_id)
WHERE relationship = 'Child'
	   AND department_name IN ('Marketing','Administration','IT');


