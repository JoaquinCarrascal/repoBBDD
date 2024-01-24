--SOLAMENTE PARA TESTEAR
DROP TABLE IF EXISTS empleado CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS venta CASCADE;
DROP TABLE IF EXISTS linea_venta CASCADE;
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;

CREATE TABLE empleado(
	num_empleado SERIAL,
	nombre VARCHAR(150) NOT NULL,
	apellidos VARCHAR(200) NOT NULL,
	email VARCHAR(320), --TODO CHECK 
	cuenta_corriente VARCHAR(24) NOT NULL, --TODO CHECK ^2
	pass VARCHAR(8) NOT NULL, --TODO CHECK 
	CONSTRAINT pk_empleado PRIMARY KEY (num_empleado)
);

CREATE TABLE cliente (
	dni VARCHAR(10),
	nombre VARCHAR(150) NOT NULL,
	apellidos VARCHAR(200) NOT NULL,
	email VARCHAR(320) NOT NULL, --TODO CHECK
	direccion VARCHAR(100),
	fecha_alta DATE,
	CONSTRAINT pk_cliente PRIMARY KEY (dni)
);

CREATE TABLE venta (
	id_venta BIGSERIAL,
	fecha DATE NOT NULL,
	empleado INTEGER NOT NULL, --TODO fk_empleado
	cliente VARCHAR(10) NOT NULL, --TODO fk_cliente
	CONSTRAINT pk_venta PRIMARY KEY (id_venta)
);

CREATE TABLE linea_venta (
	id_venta BIGINT,--TODO fk_venta
	id_linea BIGSERIAL,
	cantidad SMALLINT NOT NULL, --TODO check cantidad
	producto VARCHAR(10) NOT NULL, --TODO fk_producto
	precio NUMERIC(6,2) DEFAULT 9.99 NOT NULL,
	CONSTRAINT pk_linea_venta PRIMARY KEY (id_venta,id_linea)
);

CREATE TABLE producto (
	cup VARCHAR(10),
	nombre VARCHAR(150) NOT NULL,
	descripcion VARCHAR(350),
	pvp NUMERIC(6,2) NOT NULL,
	categoria INTEGER NOT NULL, --TODO fk_categoria
	CONSTRAINT pk_producto PRIMARY KEY (cup)
);

CREATE TABLE categoria (
	id_categoria SERIAL,
	nombre VARCHAR(150) NOT NULL,
	descripcion VARCHAR(350),
	CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
);

ALTER TABLE empleado ADD CONSTRAINT ck_empleado_email CHECK (email ILIKE '%@%');
ALTER TABLE empleado ADD CONSTRAINT ck_empleado_cuenta_corriente_length CHECK (LENGTH(cuenta_corriente) = 24);
ALTER TABLE empleado ADD CONSTRAINT ck_empleado_cuenta_corriente_start CHECK (cuenta_corriente LIKE 'ES%');
ALTER TABLE empleado ADD CONSTRAINT ck_empleado_pass_blank CHECK (pass NOT LIKE '% %');
ALTER TABLE cliente ADD CONSTRAINT ck_cliente_email CHECK (email ILIKE '%@%');
ALTER TABLE linea_venta ADD CONSTRAINT ck_linea_venta_cantidad_trigger CHECK (cantidad > 0);

ALTER TABLE venta ADD CONSTRAINT fk_venta_empleado FOREIGN KEY (empleado) REFERENCES empleado ON DELETE SET NULL; --quiero que se guarden aunque se borren los empleados
ALTER TABLE venta ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente) REFERENCES cliente ON DELETE NO ACTION; --primeron deben borrar las lineas
ALTER TABLE linea_venta ADD CONSTRAINT fk_linea_venta_producto FOREIGN KEY (producto) REFERENCES producto ON DELETE NO ACTION;--idem que arriba
ALTER TABLE linea_venta ADD CONSTRAINT fk_linea_venta_venta FOREIGN KEY (id_venta) REFERENCES venta ON DELETE CASCADE;--si borro una venta que se borren sus lineas también
ALTER TABLE producto ADD CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria) REFERENCES categoria ON DELETE NO ACTION; --primero borrar todos los productos luego la categoria


INSERT INTO categoria (nombre,descripcion) 
VALUES ('Apple' , 'Esta es la categoría de productos de Apple');
--SELECT * FROM categoria;

INSERT INTO cliente (dni,nombre,apellidos,email,direccion,fecha_alta)
VALUES ('45996467D' , 'Jesús', 'Casanova','jesus.casanova@mitienda.com','c/ ave del paraiso nº22', CURRENT_DATE),
		('45596463E', 'Rafael', 'Villar' , 'rafael.villar@correo.com','c/ Rue del Percebe, 13', CURRENT_DATE);
--SELECT * FROM cliente;

INSERT INTO empleado (nombre,apellidos,email,cuenta_corriente,pass)
VALUES ('Miguel' , 'Campos','mcampos@mitienda.com','ES1200000000000012345678','hola123')
		('Angel','Naranjo','anaranjo@mitienda.com','ES2100000000000087654321','321aloh');
--SELECT * FROM empleado;

INSERT INTO producto (cup,nombre,descripcion,pvp,categoria)
VALUES ('PROD123','Mac Mini M2','Mac Mini M2 de 256 GB',799,1),
		('PR094','Apple Watch Nike+','Reloj normal y corriente de cuerda',440,1);
--SELECT * FROM producto;

INSERT INTO venta(fecha,empleado,cliente)
VALUES (CURRENT_DATE,1,'45996467D'),
		(CURRENT_DATE,2,'45596463E');
--SELECT * FROM venta;

INSERT INTO linea_venta(id_venta, cantidad, producto, precio)
VALUES (2, 1,'PROD123', 799),
		(3,1,'PR094',440);
--SELECT * FROM linea_venta;

UPDATE producto SET pvp = pvp * 0.90;










