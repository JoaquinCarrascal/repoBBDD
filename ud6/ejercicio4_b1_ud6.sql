/*CREATE DATABASE tribici
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;*/
	
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Estacion CASCADE;
DROP TABLE IF EXISTS Bicicleta CASCADE;
DROP TABLE IF EXISTS Uso CASCADE;
	
CREATE TABLE Usuario(
dni VARCHAR(9),
nombre VARCHAR(100) NOT NULL,
apellido1 VARCHAR(50) NOT NULL,
apellido2 VARCHAR(50) NOT NULL,
direccion VARCHAR(100),
telefono VARCHAR(13) NOT NULL,
email VARCHAR(100) NOT NULL,
contrasenya VARCHAR(8),--TODO add check^2
saldo_disponible NUMERIC NOT NULL DEFAULT 0.0,
CONSTRAINT pk_usuario PRIMARY KEY(dni)
);

CREATE TABLE Estacion (
cod_estacion VARCHAR(30),--TODO comienza por E
num_estacion SERIAL NOT NULL,
direccion VARCHAR(100) NOT NULL,
latitud NUMERIC(6) NOT NULL,
longitud NUMERIC(6) NOT NULL,
CONSTRAINT pk_estacion PRIMARY KEY(cod_estacion)
);

CREATE TABLE Bicicleta(
cod_bicicleta SERIAL,
marca VARCHAR(50) NOT NULL,
modelo VARCHAR (50) NOT NULL,
fecha_alta DATE NOT NULL,
CONSTRAINT pk_bicicleta PRIMARY KEY(cod_bicicleta)
);

CREATE TABLE Uso(
estacion_salida VARCHAR(30),
fecha_salida TIMESTAMP,
dni_usuario VARCHAR(9),
cod_bicicleta INTEGER,
estacion_llegada VARCHAR(30),
fecha_llegada TIMESTAMP NOT NULL,
CONSTRAINT pk_uso PRIMARY KEY (estacion_salida,fecha_salida,dni_usuario
							   ,cod_bicicleta,estacion_llegada)
);

ALTER TABLE Usuario ADD CONSTRAINT check_longitud_pass CHECK (CHAR_LENGTH(contrasenya) >=4 
															  AND CHAR_LENGTH(contrasenya) <=8);
ALTER TABLE Usuario ADD CONSTRAINT check_espacios_pass CHECK (POSITION(' ' IN contrasenya) = 0);
ALTER TABLE Estacion ADD CONSTRAINT check_empieza_e_cod_estacion CHECK (SUBSTRING(cod_estacion, 1, 1) = 'E');
ALTER TABLE Uso ADD CONSTRAINT fk_uso_estacion_salida FOREIGN KEY(estacion_salida) REFERENCES Estacion;
ALTER TABLE Uso ADD CONSTRAINT fk_uso_usuario FOREIGN KEY(dni_usuario) REFERENCES Usuario;
ALTER TABLE Uso ADD CONSTRAINT fk_uso_bicicleta FOREIGN KEY(cod_bicicleta) REFERENCES Bicicleta;
ALTER TABLE Uso ADD CONSTRAINT fk_uso_estacion_llegada FOREIGN KEY(estacion_llegada) REFERENCES Estacion;
ALTER TABLE Usuario ADD COLUMN fecha_baja TIMESTAMP;

SELECT us1.dni, us1.nombre, us1.apellido1, 
	SUM((fecha_llegada - fecha_salida) * 1440 * 0.001) AS "coste_acumulado"
FROM Usuario us1 JOIN Uso u2 ON (us1.dni = u2.dni_usuario)
GROUP BY us1.dni, us1.nombre, us1.apellido1;

															  
