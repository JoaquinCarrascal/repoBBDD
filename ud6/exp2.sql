CREATE TABLE producto_serial(
	id_producto SERIAL,
	nombre TEXT
);

INSERT INTO producto_serial (nombre)
VALUES ('MacBook Pro'),('Dell XPS');

SELECT *
FROM producto_serial;

SELECT *
FROM prueba_01;

CREATE TABLE prueba_01(
	id_producto serial,
	nombre_producto text,
	precio_producto decimal,
	estado bool
);

INSERT INTO prueba_01 (nombre_producto,precio_producto,estado)
VALUES ('Lechuga',2.3,TRUE),('Patatas',3.1,TRUE),('Garbanzos',1.2,FALSE);

SELECT *
FROM alumno;

CREATE TABLE alumno (
	cod_alumno 		  SERIAL,
	nombre			  varchar(150),
	apellido1 		  varchar(150),
	apellido2 		  varchar(150),
	nombre_completo	  varchar(450) GENERATED ALWAYS AS (nombre || ' ' || apellido1 || ' ' || apellido2 || '.') STORED,
	fecha_nacimiento  date,
	edad_31_diciembre smallint,
	email 			  varchar
);

INSERT INTO alumno (nombre, apellido1,apellido2,fecha_nacimiento,edad_31_diciembre,email)
VALUES ('Joaquín','Carrascal','Franco','23-04-2002',22,'j.carrascalfranco@gmail.com');

DROP TABLE alumno;
