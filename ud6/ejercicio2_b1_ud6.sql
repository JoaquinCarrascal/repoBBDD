/*CREATE DATABASE libreria
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;*/
--Por si necesita también la sentencia de creación de la BBDD
	
DROP TABLE IF EXISTS Libro CASCADE;
DROP TABLE IF EXISTS Autor CASCADE;
DROP TABLE IF EXISTS Editorial CASCADE;
DROP TABLE IF EXISTS Edicion CASCADE;
DROP TABLE IF EXISTS Genero CASCADE;


CREATE TABLE Autor(
dni VARCHAR(9),
nombre VARCHAR(150) NOT NULL,
nacionalidad VARCHAR(100),
CONSTRAINT pk_autor PRIMARY KEY (dni)
);

CREATE TABLE Editorial(
cod_editorial SERIAL,
nombre VARCHAR(150) NOT NULL,
direccion VARCHAR(200),
poblacion VARCHAR(100),
CONSTRAINT pk_editorial PRIMARY KEY (cod_editorial)
);

CREATE TABLE Genero(
id_genero SERIAL,
nombre VARCHAR(150) NOT NULL,
descripcion VARCHAR(500),
CONSTRAINT pk_genero PRIMARY KEY (id_genero)
);

CREATE TABLE Libro (
isbn VARCHAR(13),
titulo VARCHAR(200) NOT NULL,
dni_autor VARCHAR(9) NOT NULL,
cod_genero SMALLINT NOT NULL,
cod_editorial SMALLINT NOT NULL,
CONSTRAINT pk_libro PRIMARY KEY (isbn),
CONSTRAINT fk_libro_autor FOREIGN KEY (dni_autor) REFERENCES Autor,
CONSTRAINT fk_libro_genero FOREIGN KEY (cod_genero) REFERENCES Genero,
CONSTRAINT fk_libro_editorial FOREIGN KEY (cod_editorial) REFERENCES Editorial
);

CREATE TABLE Edicion(
isbn VARCHAR(13),
fecha_publicacion DATE,
cantidad INTEGER,
CONSTRAINT pk_edicion PRIMARY KEY (isbn,fecha_publicacion),
CONSTRAINT stock_check CHECK (cantidad > 0),
CONSTRAINT fk_edicion_libro FOREIGN KEY (isbn) REFERENCES Libro
);

------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Libro CASCADE;
DROP TABLE IF EXISTS Autor CASCADE;
DROP TABLE IF EXISTS Editorial CASCADE;
DROP TABLE IF EXISTS Edicion CASCADE;
DROP TABLE IF EXISTS Genero CASCADE;


CREATE TABLE Autor(
dni VARCHAR(9),
nombre VARCHAR(150) NOT NULL,
nacionalidad VARCHAR(100),
CONSTRAINT pk_autor PRIMARY KEY (dni)
);

CREATE TABLE Editorial(
cod_editorial SERIAL,
nombre VARCHAR(150) NOT NULL,
direccion VARCHAR(200),
poblacion VARCHAR(100),
CONSTRAINT pk_editorial PRIMARY KEY (cod_editorial)
);

CREATE TABLE Genero(
id_genero SERIAL,
nombre VARCHAR(150) NOT NULL,
descripcion VARCHAR(500),
CONSTRAINT pk_genero PRIMARY KEY (id_genero)
);

CREATE TABLE Libro (
isbn VARCHAR(13),
titulo VARCHAR(200) NOT NULL,
dni_autor VARCHAR(9) NOT NULL,
cod_genero SMALLINT NOT NULL,
cod_editorial SMALLINT NOT NULL,
CONSTRAINT pk_libro PRIMARY KEY (isbn),
CONSTRAINT fk_libro_autor FOREIGN KEY (dni_autor) REFERENCES Autor,
CONSTRAINT fk_libro_genero FOREIGN KEY (cod_genero) REFERENCES Genero,
CONSTRAINT fk_libro_editorial FOREIGN KEY (cod_editorial) REFERENCES Editorial
);

CREATE TABLE Edicion(
isbn VARCHAR(13),
fecha_publicacion DATE,
cantidad INTEGER,
CONSTRAINT pk_edicion PRIMARY KEY (isbn,fecha_publicacion),
CONSTRAINT stock_check CHECK (cantidad > 0),
CONSTRAINT fk_edicion_libro FOREIGN KEY (isbn) REFERENCES Libro
);

