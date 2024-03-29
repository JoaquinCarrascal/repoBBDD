
/*1.- Seleccionar los nombres de los productos que hayan sido solicitados 
en pedidos que hayan sido enviados por la empresa United Package.*/
SELECT DISTINCT product_name
FROM products JOIN order_details USING(product_id)
	JOIN orders USING(order_id)
	JOIN shippers s ON (ship_via = shipper_id)
WHERE s.company_name = 'United Package';

/*2.- Seleccionar el nombre del producto y el de su categoría que 
se hayan incluido en algún pedido, para todos aquellos 
pedidos solicitados en un día de Agosto*/
SELECT DISTINCT product_name, category_name
FROM products JOIN order_details USING(product_id)
	JOIN orders USING(order_id)
	JOIN categories USING(category_id)
WHERE TO_CHAR(order_date,'MM') = '08';

/*3.- Seleccionar el nombre de todas las empresas 
que sean clientes, hayan realizado pedidos o no.*/
SELECT company_name
FROM customers;

/*4.- Seleccionar el nombre de los empleados que han 
atendido pedidos realizados por clientes de Brasil (Brazil).*/
SELECT DISTINCT e.first_name|| ' ' ||e.last_name as "Nombres de los empleados"
FROM employees e JOIN orders USING(employee_id)
	JOIN customers c USING(customer_id)
WHERE UPPER(c.country) IN ('BRASIL' , 'BRAZIL');

/*5.- Seleccionar el nombre de la categoría y los productos 
que se han pedido en aquellos pedidos que han sido 
atendidos por Janet Leverling (EMPLOYEE).*/

SELECT DISTINCT product_name, category_name
FROM categories JOIN products USING(category_id)
	JOIN order_details USING(product_id)
	JOIN orders USING(order_id)
	JOIN employees e USING(employee_id)
WHERE e.first_name = 'Janet' 
	AND e.last_name = 'Leverling';
	
/*
Diseña una consulta (incluyendo su solución) para la base de datos NORTHWIND que contenga los siguientes elementos.
La salida del select no será SELECT *
Debe realizar el JOIN de al menos 3 tablas.
Uno de los JOINs debe, obligatoriamente, ser un JOIN ON
Al menos uno de los JOINs debe ser lateral
Al menos, tendrá tres condiciones en el WHERE (conectadas con AND u OR)
Debe ordenar la salida por algún criterio.
*/
--Selecciona los pedidos que han sido enviados a Alemania(Germany) 
--o Francia(France) por la empresa Speedy Express
SELECT DISTINCT product_id, product_name
FROM products JOIN order_details USING(product_id)
	JOIN orders USING(order_id)
	JOIN shippers s ON (ship_via = shipper_id)
WHERE s.company_name = 'Speedy Express'
	AND (ship_country = 'France' OR ship_country = 'Germany');
	


