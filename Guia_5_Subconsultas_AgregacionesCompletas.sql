CREATE TABLE CLIENTE (
	NCLIENTE INTEGER PRIMARY KEY,
	NOMBRE VARCHAR(10),
	CIUDAD VARCHAR(10)
);
INSERT INTO CLIENTE VALUES (1,'MARIA', 'TALCAHUANO');
INSERT INTO CLIENTE VALUES (2,'JOSE', 'CHILLAN');
INSERT INTO CLIENTE VALUES (3,'FRANCISCA', 'TOME');
INSERT INTO CLIENTE VALUES (4,'GUSTAVO', 'TALCAHUANO');
--------------------------------------------------------------------
CREATE TABLE PRODUCTO (
	COD INTEGER PRIMARY KEY,
	DESCRIPCION VARCHAR(15),
	TIPO VARCHAR(10),
	PRECIO INTEGER
);
INSERT INTO PRODUCTO VALUES (11,'YOGURT','LACTEO', 350);
INSERT INTO PRODUCTO VALUES (12,'MANTEQUILLA','LACTEO',2000);
INSERT INTO PRODUCTO VALUES (21,'ESPIRALES','PASTA', 1200);
INSERT INTO PRODUCTO VALUES (22,'CORBATAS','PASTA', 1200);
INSERT INTO PRODUCTO VALUES (31,'NARANJA','FRUTA', 1800);
INSERT INTO PRODUCTO VALUES (41,'ARROZ','CEREALES', 800);
INSERT INTO PRODUCTO VALUES (42,'LECHUGA','VERDURA', 1000);

--------------------------------------------------------------------
CREATE TABLE VENTA (
	NCLIENTE INTEGER,
	COD INTEGER,
	FECHA DATE,
	CANTIDAD INTEGER,
	PRIMARY KEY (NCLIENTE, COD, FECHA),
	FOREIGN KEY (NCLIENTE) REFERENCES CLIENTE,
	FOREIGN KEY (COD) REFERENCES PRODUCTO
);
INSERT INTO VENTA VALUES (1,11,'01/10/2023',4);
INSERT INTO VENTA VALUES (1,11,'15/10/2023',2);
INSERT INTO VENTA VALUES (2,21,'23/09/2023',4);
INSERT INTO VENTA VALUES (2,31,'12/10/2023',1);
INSERT INTO VENTA VALUES (1,22,'18/10/2023',6);
INSERT INTO VENTA VALUES (3,31,'20/09/2023',3);
INSERT INTO VENTA VALUES (3,12,'07/10/2023',8);
INSERT INTO VENTA VALUES (1,41,'20/04/2023',4);
INSERT INTO VENTA VALUES (3,42,'07/04/2023',5);
DELETE FROM VENTA;
--------------------------------------------------------------------
SELECT * FROM CLIENTE;
SELECT * FROM PRODUCTO;
SELECT * FROM VENTA;
--------------------------------------------------------------------
--1. Muestre el nombre de los productos que se han vendido más de 5 unidades por venta
SELECT P.DESCRIPCION
FROM PRODUCTO P, VENTA V
WHERE P.COD = V.COD AND V.CANTIDAD > 5;
--OPC SUBCOSULTAS
SELECT P.DESCRIPCION
FROM PRODUCTO P
WHERE EXISTS (SELECT * /*EXISTS -> CORRELACION PARA CREAR UNA NUEVA CONSULTA DENTRO DE ESTE*/
			 FROM VENTA V
			 WHERE V.CANTIDAD > 5 AND P.COD = V.COD);
--------------------------------------------------------------------
--2. Listar los productos que han sido vendidos a cliente de la ciudad de Talcahuano
SELECT P.DESCRIPCION
FROM PRODUCTO P, VENTA V, CLIENTE C
WHERE P.COD=V.COD AND V.NCLIENTE=C.NCLIENTE AND C.CIUDAD = 'TALCAHUANO';
--OPC SUBCONSULTAS
SELECT P.DESCRIPCION
FROM PRODUCTO P
WHERE EXISTS (SELECT *
			 FROM VENTA V
			 WHERE V.COD = P.COD AND EXISTS (SELECT *
											FROM CLIENTE C
											WHERE C.NCLIENTE = V.NCLIENTE AND C.CIUDAD ILIKE 'TALCAHUANO'));/*ILIKE -> PARA EVITAR PROBLEMAS CON MAYUSCULAS Y/O MINUSCULAS*/
--------------------------------------------------------------------
--3. Muestre el número de los clientes que han comprado productos de tipo lácteos.
SELECT C.NCLIENTE 
FROM CLIENTE C, VENTA V, PRODUCTO P
WHERE C.NCLIENTE=V.NCLIENTE AND P.COD=V.COD AND P.TIPO = 'LACTEO';
--OPC SUBCOSNULTAS
SELECT C.NCLIENTE
FROM CLIENTE C
WHERE C.NCLIENTE IN (SELECT V.NCLIENTE /*IN -> COMPARACION ENTRE CONSULTAS CON COLUMNAS EN COMUN*/
					 FROM VENTA V
					 WHERE V.COD IN (SELECT P.COD
									FROM PRODUCTO P
									WHERE P.TIPO = 'LACTEO'));
--------------------------------------------------------------------
--4. Listar el nombre de los clientes que no han comprado productos
SELECT C.NOMBRE
FROM CLIENTE C
WHERE NOT EXISTS (SELECT *
				 FROM VENTA V
				 WHERE C.NCLIENTE = V.NCLIENTE);
				 
--------------------------------------------------------------------
--5. Muestre el nombre de los clientes que no han comprado en el mes de octubre. to_char(fecha, 'MM')
SELECT C.nombre
FROM CLIENTE C
WHERE NOT EXISTS (
    SELECT *
    FROM VENTA V
    WHERE V.NCLIENTE = C.NCLIENTE AND TO_CHAR(V.FECHA, 'MM') = '10'
);
--------------------------------------------------------------------
--6. Liste las ciudades de los clientes no han comprado productos de tipo vegetal.

SELECT C.ciudad
FROM CLIENTE C, VENTA V
WHERE C.NCLIENTE = V.NCLIENTE AND NOT EXISTS (SELECT * FROM PRODUCTO P WHERE V.COD = P.COD AND P.TIPO LIKE 'VEGETAL')
GROUP BY C.CIUDAD

--------------------------------------------------------------------Consultas con Agregación--------------------------------------------------------------------
SELECT SUM(V.CANTIDAD) AS TOTAL_PRODU --Atributo agregado SUM-MAX-ETC.
FROM VENTA V;
--LA CANTIDAD QUE MAS SE VENDIO
SELECT MAX(V.CANTIDAD) AS TOTAL_PRODU
FROM VENTA V;
--CANTIDAD TOTAL VENDIDA POR CADA PRODUCTO DE UN TIPO ESPECIFICO
SELECT P.DESCRIPCION, SUM(V.CANTIDAD) AS TOTAL_PRODc
FROM VENTA V, PRODUCTO P
WHERE V.COD = P.COD AND P.TIPO LIKE 'PASTA'
GROUP BY P.DESCRIPCION; --Agrupa por tipo
--CANTIDAD TOTAL VENDIDA POR CADA PRODUCTO DE UN TIPO ESPECIFICO CON UNA CONDICION SOBRE UNA AGREGACION
SELECT P.DESCRIPCION, SUM(V.CANTIDAD) AS TOTAL_PRODUC
FROM VENTA V, PRODUCTO P
WHERE V.COD = P.COD AND P.TIPO LIKE 'PASTA'
GROUP BY P.DESCRIPCION
HAVING SUM(V.CANTIDAD)>5;--CONDICION SOBRE AGREGACION
--CONTAR NIVELES DE VENTA
SELECT COUNT(*)--DENTRO SE PONE DE QUE COLUMA QUEREMOS CONTAR
FROM VENTA;
--CANTIDAD DE COMPRAS REALIZADA POR CADA CLIENTE
CREATE VIEW CANTIDAD_COMPR AS (
SELECT C.NOMBRE, COUNT(*) AS CANTIDAD
FROM CLIENTE C, VENTA V
WHERE C.NCLIENTE=V.NCLIENTE
GROUP BY C.NOMBRE--USAR SIEMPRE EL Y/O LOS ATRIBUTOS QUE VAN EN EL SELECT
);
DROP VIEW cantidad_compr; --ELIMINAR VISTA
--NOMBRE DE LOS CLIENTES QUE MAS COMPRAS HICIERON
SELECT A.NOMBRE
FROM CANTIDAD_COMPR A
WHERE A.CANTIDAD = (SELECT MAX(CANTIDAD) 
                   FROM CANTIDAD_COMPR);
--7. Mostrar la cantidad de productos y el valor recibido (la suma de (precio *cantidad) por concepto de ventas del día el 15-10-2022.
SELECT P.DESCRIPCION, V.CANTIDAD, P.PRECIO*V.CANTIDAD AS VALOR_TOTAL
FROM PRODUCTO P, VENTA V
WHERE P.COD=V.COD AND V.FECHA = '15-10-2023'
GROUP BY P.DESCRIPCION, V.CANTIDAD, P.PRECIO*V.CANTIDAD ;

--8. Crear una vista que contenga el código del producto, número de cliente, la fecha y el valor total de la venta (precio *cantidad).
CREATE VIEW VENTAS_TOT AS (
SELECT P.COD, C.NOMBRE, V.FECHA, P.PRECIO*V.CANTIDAD AS DINERO
FROM CLIENTE C, PRODUCTO P, VENTA V
WHERE P.COD=V.COD AND V.NCLIENTE=C.NCLIENTE
);
DROP VIEW ventas_tot;

--9. Utilice la vista anterior y muestre la descripción del producto que se ha obtenido mayor dinero.
SELECT P.DESCRIPCION
FROM VENTAS_TOT VT , PRODUCTO P
WHERE P.COD = VT.COD AND VT.DINERO = (SELECT MAX(DINERO) FROM VENTAS_TOT);

--10. Utilice la vista creada y muestre el promedio de las ventas de cada uno de los clientes.
SELECT VT.NOMBRE, SUM(VT.DINERO) 
FROM VENTAS_TOT VT
GROUP BY VT.NOMBRE

--11. Muestre la cantidad de clientes que no han comprado productos (consulta anidada y correlacionada).
SELECT COUNT(*)
FROM CLIENTE C
WHERE NOT EXISTS (SELECT * 
				  FROM VENTA V 
				  WHERE V.NCLIENTE = C.NCLIENTE);
				  
--12. Muestre la descripción de los productos que tienen el precio menor y no han sido comprados.
CREATE VIEW PROD_NO_COMP AS (
SELECT P.COD
FROM PRODUCTO P
WHERE NOT EXISTS (SELECT *
				 FROM VENTAS_TOT VT
				 WHERE P.COD = VT.COD)
);
DROP VIEW abr_cant;

SELECT P.DESCRIPCION
FROM PRODUCTO P
WHERE P.PRECIO = (SELECT MIN(precio) FROM PROD_NO_COMP);

--13. Muestre la cantidad de productos agrupados por tipo de productos que se han vendido durante abril
CREATE VIEW ABR_CANT AS (
SELECT V.COD, SUM(V.CANTIDAD) AS TOTAL
FROM VENTA V 
WHERE V.FECHA BETWEEN '01-04-2023' AND '30-04-2023'
GROUP BY V.COD
);
SELECT P.TIPO, AC.TOTAL
FROM PRODUCTO P, ABR_CANT AC
WHERE P.COD=AC.COD

--14. Muestre el nombre de los clientes que han comprado más de una vez el mismo producto
SELECT C.nombre
FROM CLIENTE C, VENTA V
WHERE C.NCLIENTE = V.NCLIENTE
GROUP BY C.NCLIENTE, V.COD
HAVING COUNT(*) > 1;





