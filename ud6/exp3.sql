CREATE TABLE producto(
num_producto INTEGER NOT NULL,
nombre TEXT NOT NULL,
precio NUMERIC,
precio_descontado NUMERIC,
CONSTRAINT precio_positivo CHECK (precio > 0),
CONSTRAINT precio_descontado_positivo CHECK (precio_descontado > 0),
CONSTRAINT descuento_valido CHECK (precio_descontado < precio)
);

CREATE TABLE producto_pk (
num_producto INTEGER,
nombre TEXT,
precio NUMERIC,
CONSTRAINT pk_producto PRIMARY KEY (num_producto)
);

--las claves externas deben tener el mismo tipo de datos que la pk a la que referencian
--salvo cuando la pk tiene como tipo de dato serial, entonces habra que utilizar un tipo de dato compatible
--smallint integer etc...

DROP TABLE IF EXISTS alumno CASCADE;

CREATE TABLE alumno (
    id_alumno SERIAL,
    nombre TEXT,
    CONSTRAINT pk_alumno PRIMARY KEY (id_alumno)
);

DROP TABLE IF EXISTS asignatura CASCADE;

CREATE TABLE asignatura (
    id_asignatura SERIAL,
    nombre VARCHAR(100),
    profesor VARCHAR(200),
    CONSTRAINT pk_asignatura PRIMARY KEY (id_asignatura)
);

DROP TABLE IF EXISTS matricula CASCADE;

CREATE TABLE matricula (
    id_alumno INTEGER,
    id_asignatura INTEGER,
    anio_escolar VARCHAR(10),
    CONSTRAINT pk_matricula
        PRIMARY KEY (id_alumno, id_asignatura, anio_escolar),
    CONSTRAINT fk_matricula_alumno
        FOREIGN KEY (id_alumno) REFERENCES alumno,
    CONSTRAINT fk_matricula_asignatura
        FOREIGN KEY (id_asignatura) REFERENCES asignatura
);

DROP TABLE IF EXISTS nota CASCADE;


CREATE TABLE nota (
    id_alumno INTEGER,
    id_asignatura INTEGER,
    anio_escolar VARCHAR(10),
    tipo_evaluacion VARCHAR(1),
    nota NUMERIC(4,2),
    CONSTRAINT pk_nota PRIMARY KEY
        (id_alumno, id_asignatura,
         anio_escolar, tipo_evaluacion),
    CONSTRAINT ck_nota_tipo_evaluacion
        CHECK (tipo_evaluacion IN ('1','2','3','F')),
    CONSTRAINT fk_nota_matricula
        FOREIGN KEY (id_alumno, id_asignatura,
         anio_escolar)
        REFERENCES matricula (id_alumno,
         id_asignatura, anio_escolar)
);