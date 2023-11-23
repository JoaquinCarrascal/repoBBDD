/*
1.- Seleccionar el COMPANY_NAME y CONTACT_NAME de aquellos 
CUSTOMERS que hayan hecho pedidos (ORDERS).

2.- Seleccionar el número de pedidos que hemos enviado en 
la década de los 90 con las empresas Federal Shipping o United Package.

3.- Seleccionar el nombre de aquellos productos que han sido solicitados en algún pedido.

4.- Seleccionar la suma de los importes "cobrados" en todos los pedidos realizados en el año 96.

5.- Seleccionar el nombre de contacto del cliente y el del empleado
para aquellos clientes y empleados que han participado en pedidos 
donde la diferencia entre la fecha de envío y la fecha de requisito sea menos de 20 días

6.- Diseña una consulta (incluyendo su solución) para la base de datos 
NORTHWIND que contenga los siguientes elementos.
-La salida del select no será SELECT *
-Debe realizar el JOIN de al menos 4 tablas.
-Uno de los JOINs debe, obligatoriamente, ser un JOIN ON
-Al menos, tendrá cuatro condiciones en el WHERE (conectadas con AND u OR)
-Debe ordenar la salida por algún criterio.
*/

--1.-
SELECT DISTINCT company_name, contact_name
FROM customers JOIN orders USING(customer_id);

--2.-
SELECT COUNT(*)
FROM orders JOIN shippers ON (ship_via = shipper_id)
WHERE DATE_PART('year', shipped_date) BETWEEN 1990 AND 1999
	AND company_name IN ('Federal Shipping' , 'United Package');
	
--3.-
SELECT DISTINCT p.product_name
FROM orders JOIN order_details od USING(order_id)
	JOIN products p USING(product_id)
WHERE od.quantity != 0;

--4.-
SELECT ROUND(SUM((od.unit_price*od.quantity)
				  -((od.unit_price*od.quantity)
					*COALESCE(od.discount, 0)))::numeric , 2)
FROM orders o JOIN order_details od USING(order_id)
WHERE TO_CHAR(order_date, 'YY') = '96';

--5.-
SELECT DISTINCT c.contact_name AS "Nombre de contacto del cliente", e.first_name || ' ' || e.last_name AS "Nombre del empleado"
FROM customers c JOIN orders o USING(customer_id)
	JOIN employees e USING(employee_id)
WHERE AGE(o.shipped_date , o.required_date) BETWEEN -('19 day'::interval) AND ('19 day'::interval);

--6.-
--Seleciona el id de envío de los pedidos en los cuales sólamente
--haya productos con id's pares, hayan sido enviados por un empleado
--que tenga 5 reportes, a la ciudad de Torino, London , Rio de Janeiro
--o bien que el código postal de envío, terminase en 0
SELECT order_id
FROM employees e JOIN employees rep ON(rep.employee_id = e.reports_to)
	JOIN orders o ON (e.employee_id = o.employee_id)
	JOIN order_details USING(order_id)
	JOIN products USING(product_id)
WHERE product_id%2 = 0
	AND e.reports_to = 5
	AND (o.ship_city IN ('Torino' , 'London' , 'Rio de Janeiro')
	OR ship_postal_code ILIKE '%0')
ORDER BY e.first_name;

	