CREATE TABLE Empleado(
	id_empleado SERIAL,
	nombre VARCHAR(100),
	cod_departamento INTEGER,
	id_jefe INTEGER,
	CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
	CONSTRAINT fk_empleado_empleado FOREIGN KEY (id_jefe) REFERENCES Empleado(id_empleado),
	
);