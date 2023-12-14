SELECT department_name,
	(
		SELECT COUNT(*)
		FROM employees
		WHERE department_id = d.department_id
	)
FROM departments d;

SELECT employee_id,first_name,last_name,
	(
		SELECT COUNT(*)
		FROM employees
		WHERE employee_id = e.manager_id
	)
FROM employees e
