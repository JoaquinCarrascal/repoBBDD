DROP TABLE IF EXISTS docente CASCADE;
DROP TABLE IF EXISTS actividad CASCADE;
DROP TABLE IF EXISTS alumno CASCADE;		--usado para testear la base de datos, no tiene relacion directa con el ejercicio
DROP TABLE IF EXISTS asignacion_act CASCADE;
DROP TABLE IF EXISTS asistencia_act CASCADE;

CREATE TABLE docente( 	--cuando borramos un profesor aplicaria soft delete para 
	dni VARCHAR(10), 	--que no se borren las actividades con alumnos asociados
	nombre VARCHAR(100) NOT NULL, 
	telefono VARCHAR(13) NOT NULL, -- por el prefijo si fuese de 3 cifras(4 caracteres) 
	anyo_ingreso DATE NOT NULL,
	CONSTRAINT pk_docente PRIMARY KEY (dni)
);

CREATE TABLE actividad ( --aqui aplicaría un borrado en cascada para que si 
	id_act SMALLSERIAL,  --se diese el caso de borrar la actividad se borren 
	nombre	VARCHAR(50) NOT NULL, --tambien las relaciones de las personas que estuvieron en ellas
	duracion SMALLINT NOT NULL,
CONSTRAINT pk_actividad PRIMARY KEY (id_act)
);

CREATE TABLE alumno( --Borrado en cascada
	cod_alumno SMALLSERIAL, 
	nombre VARCHAR(150) NOT NULL, 
	telefono VARCHAR(13) NOT NULL, 
	nivel VARCHAR(10),
CONSTRAINT pk_alumno PRIMARY KEY (cod_alumno)
);

CREATE TABLE asignacion_act( --borrado en cascada para que se borre la relacion de asistencia actividad tambien
	id_docente VARCHAR(10) ,
	id_actividad SMALLINT,
	dia_semana	VARCHAR(10),
	hora TIME,
CONSTRAINT pk_asignacion_act PRIMARY KEY (id_docente,id_actividad,dia_semana,hora)
);

CREATE TABLE asistencia_act(
id_alumno SMALLINT,
id_actividad SMALLINT,
id_docente VARCHAR(10) NOT NULL,
CONSTRAINT pk_asistencia_act PRIMARY KEY (id_actividad,id_alumno)
);

ALTER TABLE actividad ADD CONSTRAINT ck_tiempo_actividad CHECK (duracion > 0);
ALTER TABLE asignacion_act ADD CONSTRAINT fk_asignacion_act_docente FOREIGN KEY(id_docente) REFERENCES docente;
ALTER TABLE asignacion_act ADD CONSTRAINT fk_asignacion_act_actividad FOREIGN KEY(id_actividad) REFERENCES actividad;
ALTER TABLE asistencia_act ADD CONSTRAINT fk_asistencia_act_alumno FOREIGN KEY(id_alumno) REFERENCES alumno;
ALTER TABLE asistencia_act ADD CONSTRAINT fk_asistencia_act_actividad FOREIGN KEY(id_actividad) REFERENCES actividad;

