/*
CREATE DATABASE academia
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
*/

DROP TABLE IF EXISTS empresa CASCADE;
DROP TABLE IF EXISTS alumno CASCADE;
DROP TABLE IF EXISTS alumno_asiste CASCADE;
DROP TABLE IF EXISTS curso CASCADE;
DROP TABLE IF EXISTS profesor CASCADE;
DROP TABLE IF EXISTS tipo_curso CASCADE;

CREATE TABLE empresa (
    cif VARCHAR(9),
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(13) NOT NULL,
    CONSTRAINT pk_empresa PRIMARY KEY (cif)
);


CREATE TABLE alumno (
    dni VARCHAR(9),
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(13) NOT NULL,
    edad SMALLINT NOT NULL,
    empresa VARCHAR(9),/*como se le dan clases a trabajadores y no trabajadores esta DEBE PODER SER NULA*/
    CONSTRAINT pk_alumno PRIMARY KEY (dni)
);

CREATE TABLE tipo_curso (
    cod_curso SERIAL,
    duracion INT NOT NULL,
    programa VARCHAR(300),
    titulo VARCHAR(150) NOT NULL,
    CONSTRAINT pk_tipo_curso PRIMARY KEY (cod_curso)
);

CREATE TABLE alumno_asiste (
    dni VARCHAR(9),
    num_concreto INT NOT NULL,
	nota_obtenida float4,
    CONSTRAINT pk_alumnos_asisten PRIMARY KEY (dni,num_concreto)
);


CREATE TABLE curso (
    num_concreto SERIAL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dni_profesor VARCHAR(9) NOT NULL,
    tipo_curso INT NOT NULL,
    CONSTRAINT pk_cursos PRIMARY KEY (num_concreto)
);

CREATE TABLE profesor(
    dni VARCHAR(9),
    nombre VARCHAR(150) NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    telefono VARCHAR(13) NOT NULL,
    direccion VARCHAR(200),
    CONSTRAINT pk_profesor PRIMARY KEY (dni)
);

ALTER TABLE alumno ADD CONSTRAINT fk_alumno_empresa FOREIGN KEY (empresa) REFERENCES empresa;
ALTER TABLE alumno_asiste ADD CONSTRAINT fk_alumno_asiste_alumno FOREIGN KEY (dni) REFERENCES alumno;
ALTER TABLE alumno_asiste ADD CONSTRAINT fk_alumno_asiste_curso FOREIGN KEY (num_concreto) REFERENCES curso;
ALTER TABLE curso ADD CONSTRAINT fk_curso_profesor FOREIGN KEY (dni_profesor) REFERENCES profesor;
ALTER TABLE curso ADD CONSTRAINT fk_curso_tipo_curso FOREIGN KEY (tipo_curso) REFERENCES tipo_curso;


--PONER EL ORDEN DE INSERCION
INSERT INTO empresa (cif,nombre,direccion,telefono)
VALUES ('45996764E','NTT DATA','Avenida Reyes Católicos, 22, Sevilla, España','622198546'),
	('65496764E','Google','31st Avey Colorado EEUU','+2 32198546'),
	('15395664W','Bionest','km 70 Carretera Norte Almonte','789980546');
--SELECT * FROM empresa;

INSERT INTO alumno(dni,nombre,direccion,telefono,edad,empresa)
VALUES ('45795437R','Pepe botika','Calle tajo, 22, sevilla','111222333','23','45996764E'),
('45795437Q','Roberto iniesta','Calle tajo, 22, sevilla','111222333','53','45996764E'),
('45795437P','Rob Swire','Calle tajo, 21, sevilla','111222333','22','45996764E'),
('45795437T','Mario Duplantier','Calle tajo, 26, sevilla','111222333','40','45996764E'),
('45795427I','Joe Duplantier','Calle tajo, 26, sevilla','111222333','38','45996764E'),

('45795433M','paco paquetes','Calle hueva, 22, sevilla','111222333','19','65496764E'),
('45755437Q','Ray heredia','Calle hueva, 20, sevilla','111222333','53','65496764E'),
('45795427P','Miguel Benitez','Calle hueva, 1, sevilla','111222333','22','65496764E'),
('45755437T','Serj Tankien','Calle hueva, 18, sevilla','111222333','40','65496764E'),
('45798427I','Juan de Dios','Calle tango, 17, sevilla','111222333','38','65496764E'),

('45793433M','paco','Calle hueva, 22, sevilla','111222333','19','15395664W'),
('15795437Q','heredia','Calle hueva, 20, sevilla','111222333','53','15395664W'),
('55795437P','Benitez','Calle hueva, 1, sevilla','111222333','22','15395664W'),
('95795437T','Tankien','Calle hueva, 18, sevilla','111222333','40','15395664W'),
('05795427I','Juan','Calle tango, 17, sevilla','111222333','38','15395664W');

--SELECT * FROM alumno;

INSERT INTO tipo_curso(cod_curso,duracion,programa,titulo)
VALUES (1,30, 'Curso de prevencion de riesgos laborales','Preventor de riesgos'),
(2,70, 'Curso de pastelería','Pastelero jefe'),
(3,60, 'Curso de cafetería','maestro de los cafés'),
(4,20, 'Curso de artes escenicas','Actor novel');

--SELECT * FROM tipo_curso;

INSERT INTO profesor(dni,nombre,apellido,telefono,direccion)
VALUES ('05725427Y','Juan','Martinez','111222333','Calle tango, 17, sevilla'),
('55725427L','Paco','Antunez','111222333','Calle tango, 12, sevilla'),
('15735427G','Jose','Martinez','111222333','Calle tango, 11, sevilla'),
('25725427K','Manuel','Mendoza','111222333','Calle tango, 1, sevilla');

--SELECT * FROM profesor;
--SELECT * FROM curso;


