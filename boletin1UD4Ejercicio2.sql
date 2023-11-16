--Seleccionar el FIRST_NAME y LAST_NAME de los empleados 
--del departamento de IT o Finance cuya fecha de alta 
--(HIRE_DATE) fuera un día cualquiera de Abril o Junio.

SELECT first_name, last_name
FROM employees e JOIN departments d USING (department_id)
WHERE d.department_name IN ('IT' , 'Finance')
	AND SUBSTR(e.hire_date::text,6,2)::int IN (4,6);
	