
/*
1.- Seleccionar el número de pedidos atendidos por
cada empleado, sí y sólo si dicho número está entre 
100 y 150.
*/
SELECT e.first_name, e.last_name,employee_id, COUNT(order_id)
FROM employees e JOIN orders USING(employee_id)
GROUP BY e.first_name, e.last_name,employee_id
HAVING COUNT(order_id) BETWEEN 100 AND 150;

/*
2.- Seleccionar el nombre de las empresas que no han 
realizado ningún pedido.
*/
SELECT company_name
FROM customers LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL;

--lo mismo pero con subconsulta (mejor)
SELECT company_name
FROM customers
WHERE customer_id NOT IN(
			SELECT DISTINCT customer_id
			FROM orders
			);

/*
3.- Seleccionar la categoría que tiene más productos 
diferentes solicitados en pedidos. Mostrar el nombre 
de la categoría y dicho número.
*/
--El DISTINCT hay que ponerselo al producto!!!!
SELECT category_name,COUNT(DISTINCT p.*)
FROM categories JOIN products p USING(category_id)
	JOIN order_details USING(product_id)
GROUP BY category_name
ORDER BY COUNT(DISTINCT p.*) DESC
LIMIT 1;

/*
4.- Si suponemos que nuestro margen de beneficio con 
los productos es de un 25% (es decir, el 25% de su 
precio, son beneficios, y el 75% son costes), calcular 
la cantidad de beneficio que hemos obtenido, agrupado 
por categoría y producto. Las cantidades deben 
redondearse a dos decimales.
*/

--SELECT category_name,product_name, ROUND(unit_price::numeric*units_in_stock::numeric*25/100,2)
--FROM products JOIN categories USING(category_id)
--GROUP BY category_name,product_name,ROUND(unit_price::numeric*units_in_stock::numeric*25/100,2)
--ORDER BY category_name;
SELECT category_name, product_name,
	ROUND(SUM(
			(od.unit_price * quantity * (1 - discount))::numeric*0.25
			),2) as "beneficio"
FROM order_details od JOIN products USING(product_id)
	JOIN categories USING (category_id)
	GROUP BY category_name,product_name;
	
/*100€
25%
100€ - 100€ *25/100
100€ - 100€ * 0.25
100€ * 1 - 100€ * 0.25
100€ * (1 - 0.25)
precio * (1 - descuento)*/

/*
5.- Selecciona aquellos clientes (CUSTOMERS) para 
los que todos los envíos que ha recibido (sí, todos) 
los haya transportado (SHIPPERS) la empresa United Package.
*/

SELECT DISTINCT c.company_name
FROM customers c JOIN orders USING(customer_id)
	JOIN shippers s ON(shipper_id=ship_via) --ESTA MAL!
WHERE s.company_name = 'United Package'
GROUP BY c.company_name;

SELECT DISTINCT c.company_name
FROM customers c JOIN orders USING(customer_id)
	JOIN shippers s ON(shipper_id=ship_via)
WHERE customer_id NOT IN (
            SELECT customer_id
            FROM orders JOIN shippers
                ON (shipper_id=ship_via)
            WHERE company_name != 'United Package'
    					);
