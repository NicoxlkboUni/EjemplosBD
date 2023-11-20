create table Dueno(
	RutD varchar(12) primary key,
	Nombre varchar(20),
	Telefono varchar (10),
	Direccion varchar(20)	
);
INSERT INTO Dueno VALUES ('1-1','VALERIA','555555','COLLAO 44, CONCE'),('2-2','JUAN','311120','CARRERA 22, HUALQUI');
---------------------------------------------------------------
create table Arrendatario(
	RutA varchar(12) primary key,
	Nombre varchar(20),
	Telefono varchar (10),
	Direccion varchar(20)	
);
INSERT INTO ARRENDATARIO VALUES ('32-1','JOSEFINA','5478','SALAS 126, TALCA'),
								('11-1','PEDRO','54555','LAUTARO 33, TALCA'), 	
								('33-1','SOFIA','4444','HERAS 395, CONCE');
---------------------------------------------------------------								
create table Propiedad(
	Cod_p integer primary key,
	Ubicacion varchar(20),
	NumBaños integer,
	NumDorm integer,
	SalaEstar char(2),
	MtsConst integer,
	MtsPatio integer,
	TipoPropiedad varchar(10),
	RutD varchar(12),
	Foreign key (RutD) references Dueno	
);
INSERT INTO PROPIEDAD VALUES (1,'NORTE', 2, 3,'SI',120, 30, 'DEPTO','1-1'), 
							(2,'ORIENTE', 1, 2,'NO',60, 20,'DEPTO', '1-1'), 
							(3,'ORIENTE', 2, 3,'SI',110, 20,'CASA', '2-2')
---------------------------------------------------------------
create table Telefono(
	numero varchar(10) primary key,
	compañia varchar(20),
	Cod_p integer,
	Foreign key (Cod_p) references Propiedad	
);
INSERT INTO TELEFONO VALUES ('8888', 'ENTEL',1), ('444', 'MOVISTAR',1), ('555','ENTEL',2 );
---------------------------------------------------------------
create table Arriendo(
	RutA varchar(12),
	Cod_p integer,
	Monto integer,
	FechaInicio date,
	FechaTerm date,
	Primary Key (RutA, Cod_p),
	Foreign key (RutA) references Arrendatario,
	Foreign key (Cod_p) references Propiedad	
);
INSERT INTO ARRIENDO VALUES ('11-1', 1, 100000, '01/02/2020', '30/01/2021'),
							('11-1', 2, 150000, '01/02/2021', NULL),
							('33-1', 2, 200000, '01/03/2019', '30/12/2020');
--Ya se crearon todas las tablas y se insertaron los valores anteriores
---------------------------------------------------------------
SELECT * FROM PROPIEDAD;
---------------------------------------------------------------
SELECT COD_P, UBICACION 
FROM PROPIEDAD;
---------------------------------------------------------------
SELECT COD_P AS CODIGO_PROPIEDAD, UBICACION 
FROM PROPIEDAD;
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION 
FROM PROPIEDAD P;
---------------------------------------------------------------
SELECT N.COD_P AS CODIGO_PROPIEDAD, N.UBICACION
FROM PROPIEDAD N;
---------------------------------------------------------------
SELECT N.COD_P AS CODIGO_PROPIEDAD, N.UBICACION
FROM PROPIEDAD N
WHERE N.TIPOPROPIEDAD='CASA';
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION 
FROM PROPIEDAD P 
WHERE P.TIPOPROPIEDAD='CASA' AND P.NUMDOR > 2;
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION 
FROM PROPIEDAD P 
WHERE P.TIPOPROPIEDAD='CASA' AND P.NUMDORM > 2;
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION 
FROM PROPIEDAD P 
WHERE P.TIPOPROPIEDAD='CASA' OR P.NUMDORM > 2;
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION, D.NOMBRE 
FROM PROPIEDAD P, DUENO AS D 
WHERE P.RUTD=D.RUTD AND P.TIPOPROPIEDAD='CASA';
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION 
FROM PROPIEDAD P
WHERE P.TIPOPROPIEDAD='CASA' OR P.NUMDORM > 2;
---------------------------------------------------------------
SELECT P.COD_P AS CODIGO_PROPIEDAD, P.UBICACION, D.NOMBRE 
FROM PROPIEDAD P, DUENO AS D
WHERE P.RUTD=D.RUTD AND P.TIPOPROPIEDAD='CASA'; --Comparacion entre tablas
---------------------------------------------------------------
--consulta e)
SELECT A.COD_P
FROM ARRIENDO A
WHERE (A.FECHAINICIO >= '01-01-2020' AND A.FECHAINICIO <= '31-12-2020') OR (A.FECHATERM >= '01-01-2020' AND A.FECHATERM <= '31-12-2020');
---------------------------------------------------------------
--consulta e) opcion 2 BETWEEN
SELECT A.COD_P
FROM ARRIENDO A
WHERE A.FECHAINICIO BETWEEN '01-01-2020' AND '31-12-2020'; --BETWEEN funciona con numeros y con fechas
---------------------------------------------------------------
--f. Muestra el código de las propiedades cuyo arriendo fluctua entre $150000 y $200000 ambos inclusive
SELECT A.COD_P AS CODIGO_PROPIEDAD, A.MONTO
FROM ARRIENDO A
WHERE A.MONTO BETWEEN '150000' AND '200000'
---------------------------------------------------------------
--g. Muestre el nombre de los arrendatorios y de los dueños, y el código de la propiedad que tienen vigente un arriendo.
SELECT C.NOMBRE, D.NOMBRE AS NOMBRE_DUENO, P.COD_P
FROM ARRIENDO A, ARRENDATARIO C, DUENO D, PROPIEDAD P
WHERE D.RUTD = P.RUTD AND P.COD_P = A.COD_P AND A.RUTA = C.RUTA AND (A.FECHATERM IS NULL); -- comparacion numerica =, comparacion existenicia IS
---------------------------------------------------------------
--h. Muestre el nombre y dirección de los arrendatarios que son de Talca
SELECT A.NOMBRE, A.DIRECCION
FROM ARRENDATARIO A
WHERE A.DIRECCION LIKE ('%TALCA');
---------------------------------------------------------------
--i. Liste el código de las propiedades que ha arrendado Pedro, desde el 2020 en adelante
SELECT P.COD_P
FROM PROPIEDAD P, ARRIENDO A, arrendatario C
WHERE P.COD_P = A.COD_P AND A.RUTA = C.RUTA AND 
	  C.NOMBRE = 'PEDRO' AND (A.FECHAINICIO  >= '01-01-2020');
---------------------------------------------------------------
--j. Muestre los teléfonos que tiene cada propiedad.
SELECT T.NUMERO AS NUMERO_PROPIEDAD
FROM PROPIEDAD P, TELEFONO T
WHERE P.COD_P = T.COD_P;
---------------------------------------------------------------
--k. Muestre el nombre(codigo) de las propiedades que no se encuentra con arriendo vigente
SELECT P.COD_P
FROM PROPIEDAD P
WHERE NOT EXISTS (SELECT *
				  FROM ARRIENDO A
				  WHERE A.COD_P = P.COD_P AND A.FECHATERM IS NULL);
---------------------------------------------------------------
--l. Muestra el nombre de los arrendatarios que no están arrendando actualmente.
SELECT C.NOMBRE
FROM arrendatario C 
WHERE NOT EXISTS (SELECT *
				 FROM ARRIENDO A
				 WHERE A.RUTA = C.RUTA AND A.FECHATERM IS NULL);


