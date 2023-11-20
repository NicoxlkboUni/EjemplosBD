CREATE TABLE alumno(
RUT varchar(12) PRIMARY KEY,
nombre varchar(20),
fecha_nac date,
telefono integer
--opcion = PRIMARY KEY(RUT) ->
--schemas -> public -> tables
);

INSERT INTO alumno VALUES('1-1', 'EEE', '03/09/2022', '99499');
SELECT * FROM alumno;
---------------------------------------------------------------------

create TABLE asignatura(
CODIGO integer,
nombre varchar(10),
primary key(codigo)

);

INSERT INTO asignatura(nombre, codigo) VALUES('baseDatos', '4051'); -- en el orden q se definen en el codigo anterior
SELECT * FROM asignatura;
---------------------------------------------------------------------

CREATE TABLE inscribe(
RUT_al varchar(12),--rut alumno como clave foranea
CODIGO integer,
PRIMARY KEY(RUT_al,CODIGO),
FOREIGN key(RUT_al) REFERENCES alumno,
foreign key(CODIGO) REFERENCES asignatura

);
INSERT INTO inscribe VALUES('1-1', '4051');
SELECT * FROM inscribe;
