/*
Si suponemos que nuestro margen de beneficio con los productos es de un 25% (es decir, el 25% de su precio, son beneficios, y el 75% son costes), calcular la cantidad de beneficio que hemos obtenido, agrupado por categoría y producto. Las cantidades deben redondearse a dos decimales.
Selecciona aquellos clientes (CUSTOMERS) para los que todos los envíos que ha recibido (sí, todos) los haya transportado (SHIPPERS) la empresa United Package.
*/

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

/*
3.- Seleccionar la categoría que tiene más productos 
diferentes solicitados en pedidos. Mostrar el nombre 
de la categoría y dicho número.
*/
SELECT DISTINCT category_name,COUNT(p.*)
FROM categories JOIN products p USING(category_id)
	JOIN order_details USING(product_id)
GROUP BY category_name
ORDER BY COUNT(p.*) DESC
LIMIT 1;
