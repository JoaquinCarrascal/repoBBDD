/*
CREATE DATABASE ejemplo_clase_2
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
*/

DROP TABLE IF EXISTS producto CASCADE;

CREATE TABLE producto (
	num_producto SERIAL,
	nombre TEXT,
	precio NUMERIC,
	CONSTRAINT pk_productos PRIMARY KEY (num_producto)
);
INSERT INTO producto (nombre,precio)
VALUES('Lechuga',5),
		('Fuet espetec',2.7),
		('Coliflor',1.24);
		
ALTER SEQUENCE producto_num_producto_seq
RESTART WITH 1000;
--esto sirve para hacer que la secuencia comience por 1000

INSERT INTO producto (nombre,precio)
VALUES('Agua mineral',2),
		('Pizza campesina',3.7);

UPDATE producto
SET precio = 1.5
WHERE num_producto = 1;

UPDATE producto
SET nombre = 'Agua del monte',
precio = 2.4
WHERE precio = 2;

UPDATE producto
SET precio = precio - (precio *(20.0/100))
WHERE num_producto IN (
	SELECT num_producto
	FROM producto
	ORDER BY precio DESC
	LIMIT 2
);

SELECT *
FROM producto;