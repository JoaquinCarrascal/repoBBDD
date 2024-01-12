/*CREATE DATABASE teatro
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;*/
	
DROP TABLE IF EXISTS Invitado CASCADE;
DROP TABLE IF EXISTS Teatro CASCADE;
DROP TABLE IF EXISTS Obra CASCADE;
DROP TABLE IF EXISTS Exhibe CASCADE;
DROP TABLE IF EXISTS Tipo_asiento CASCADE;
DROP TABLE IF EXISTS Asiento_tipo CASCADE;
DROP TABLE IF EXISTS Precio CASCADE;
DROP TABLE IF EXISTS Entrada CASCADE;
	
CREATE TABLE Invitado(
num_invitado SERIAL,
nombre_inv VARCHAR(250),
categoria VARCHAR(50),
origen VARCHAR(80),
CONSTRAINT pk_invitado PRIMARY KEY(num_invitado)
);

CREATE TABLE Teatro (
cod_teatro INTEGER,
nombre VARCHAR(150),
direccion VARCHAR(90),
num_asientos SMALLINT,
CONSTRAINT pk_teatro PRIMARY KEY(cod_teatro)
);
CREATE TABLE Obra (
cod_obra INTEGER,
nombre VARCHAR(250),
autor VARCHAR(250),
CONSTRAINT pk_obra PRIMARY KEY(cod_obra)
);  
CREATE TABLE Exhibe (
cod_teatro INTEGER,
fecha DATE,
cod_obra INTEGER NOT NULL,
CONSTRAINT pk_exhibe PRIMARY KEY(cod_teatro,fecha)
);
CREATE TABLE Tipo_asiento (
tipo VARCHAR(100),
nombre VARCHAR(80),
descripcion VARCHAR(100),
CONSTRAINT pk_tipo_asiento PRIMARY KEY(tipo)
);
CREATE TABLE Asiento_tipo(
num_asiento INTEGER,
tipo VARCHAR (100) NOT NULL,
CONSTRAINT pk_asiento_tipo PRIMARY KEY(num_asiento)
);
CREATE TABLE Precio(
cod_teatro INTEGER,
fecha DATE,
tipo VARCHAR(100),
precio SMALLINT,
CONSTRAINT pk_precio PRIMARY KEY(cod_teatro,fecha,tipo)
);
CREATE TABLE Entrada(
cod_teatro INTEGER,
fecha DATE,
num_asiento INTEGER,
num_invitado INTEGER NOT NULL,
CONSTRAINT pk_entrada PRIMARY KEY(cod_teatro,fecha,num_asiento)
);

ALTER TABLE Exhibe ADD CONSTRAINT fk_exhibe_teatro FOREIGN KEY (cod_teatro) REFERENCES Teatro;
ALTER TABLE Exhibe ADD CONSTRAINT fk_exhibe_obra FOREIGN KEY (cod_obra) REFERENCES Obra;
ALTER TABLE Asiento_tipo ADD CONSTRAINT fk_asiento_tipo_tipo_asiento FOREIGN KEY (tipo) REFERENCES Tipo_asiento;
ALTER TABLE Precio ADD CONSTRAINT fk_precio_exhibe FOREIGN KEY (cod_teatro,fecha) REFERENCES Exhibe;
ALTER TABLE Precio ADD CONSTRAINT fk_precio_tipo_asiento FOREIGN KEY (tipo) REFERENCES Tipo_asiento;
ALTER TABLE Entrada ADD CONSTRAINT fk_entrada_exhibe FOREIGN KEY (cod_teatro,fecha) REFERENCES Exhibe;
ALTER TABLE Entrada ADD CONSTRAINT fk_entrada_asiento_tipo FOREIGN KEY (num_asiento) REFERENCES Asiento_tipo;
ALTER TABLE Entrada ADD CONSTRAINT fk_entrada_invitado FOREIGN KEY (num_invitado) REFERENCES Invitado;