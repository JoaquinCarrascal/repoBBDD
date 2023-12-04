--Seleccionar el FIRST_NAME y LAST_NAME de los empleados 
--del departamento de IT o Finance cuya fecha de alta 
--(HIRE_DATE) fuera un día cualquiera de Abril o Junio.

SELECT first_name, last_name
FROM employees e JOIN departments d USING (department_id)
WHERE d.department_name IN ('IT' , 'Finance')
	AND SUBSTR(e.hire_date::text,6,2)::int IN (4,6);

--Seleccionar el FIRST_NAME y LAST_NAME de los managers de los empleados del departamento de Administration.

SELECT DISTINCT m.first_name, m.last_name
FROM employees m JOIN employees e ON(m.employee_id=e.manager_id)
	JOIN departments d ON(e.department_id=d.department_id)
WHERE department_name = 'Administration';

--Seleccionar el COUNTRY_NAME donde tiene localización el departamento de Public Relations

SELECT c.country_name
FROM departments d JOIN locations l USING(location_id)
	JOIN countries c USING(country_id)
WHERE d.department_name = 'Public Relations';

--Seleccionar aquellos empleados que trabajen en oficinas de América.

SELECT e.*
FROM employees e JOIN departments d USING (department_id)
	JOIN locations l USING (location_id)
	JOIN countries c USING (country_id)
	JOIN regions r USING (region_id)
WHERE r.region_name = 'Americas';

--Seleccionar el nombre y apellidos de los hijos, así como el nombre y apellidos de 
--sus padres, para aquellos empleados que trabajen en oficinas de América. Ordena la 
--salida por orden alfabético del país 

SELECT de.first_name AS "Hijo", de.last_name AS "Hijo", 
	e.first_name AS "Padre", e.last_name AS "Padre"
FROM employees e JOIN dependents de USING(employee_id)
	JOIN departments d USING (department_id)
	JOIN locations l USING (location_id)
	JOIN countries c USING (country_id)
	JOIN regions r USING (region_id)
WHERE r.region_name = 'Americas'
	AND de.relationship = 'Child'
ORDER BY c.country_name;

--Diseña una consulta (incluyendo su solución) para la base de datos 
--HR que contenga los siguientes elementos.
--La salida del select no será SELECT *
--Debe realizar el JOIN de al menos 3 tablas.
--Uno de los JOINs debe, obligatoriamente, ser un JOIN ON
--Al menos, tendrá dos condiciones en el WHERE (conectadas con AND u OR)
--Debe ordenar la salida por algún criterio.

SELECT e.first_name
FROM employees e JOIN departments d USING(department_id)
	JOIN locations l USING(location_id)
WHERE LEFT(l.postal_code,1)= '9'
	AND d.department_name IN ('Marketing' , 'Purchasing');

