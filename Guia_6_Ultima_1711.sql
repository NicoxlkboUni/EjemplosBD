CREATE TABLE PRODUCTO(
	modelo VARCHAR(10) PRIMARY KEY,
	fabricante VARCHAR(10) , 
	fecha DATE, 
	precio INTEGER);
INSERT INTO PRODUCTO VALUES ('P1','DELL','2019/12/20', 200000 );
INSERT INTO PRODUCTO VALUES ('P2','HP','2020/05/20', 480000);
INSERT INTO PRODUCTO VALUES ('I1','HP','2019/08/12', 120000);
INSERT INTO PRODUCTO VALUES('I2','EPSON','2019/08/12', 540000);
INSERT INTO PRODUCTO VALUES('I3','CANON','2021/07/01', 200000);
INSERT INTO PRODUCTO VALUES('I4','CANON','2021/08/02', 150000);
-- DELETE FROM PRODUCTO WHERE MODELO = 'I4' 
------------------------------------------------------------------------------------
CREATE TABLE PC (
	modelo VARCHAR(10) PRIMARY KEY,
	velocidad INTEGER,
	ram INTEGER,
	hd INTEGER,
FOREIGN KEY (modelo) REFERENCES PRODUCTO);
INSERT INTO PC VALUES ('P1', 60,4, 512), ('P2', 100, 16,256);
------------------------------------------------------------------------------------
CREATE TABLE Impresora (modelo VARCHAR(10) PRIMARY KEY,
	color VARCHAR(10),
	tipo VARCHAR(10),
FOREIGN KEY (modelo) REFERENCES PRODUCTO);
INSERT INTO IMPRESORA VALUES ('I1','NEGRO','LASER'), ('I2','ROJO','3D'),('I3','AZUL','LASER');
INSERT INTO IMPRESORA VALUES ('I4','NEGRO','3D')
------------------------------------------------------------------------------------	
/*1. Mostrar el modelo y la velocidad de los PC’s con disco duro mayor a 
120 gigabytes y el precio no sea superior al promedio de todos los PC’s.*/								 
								 
SELECT PC.MODELO,PC.VELOCIDAD
FROM PC, PRODUCTO P
WHERE PC.MODELO=P.MODELO AND PC.HD>120 AND P.PRECIO < (SELECT AVG(PRECIO)
														FROM PRODUCTO, PC
														WHERE PC.MODELO = P.MODELO) 

								
/*2. Mostrar el nombre de los fabricantes que no tengan impresoras de color rojo y azul*/
SELECT P.FABRICANTE
FROM PRODUCTO P, IMPRESORA I
WHERE I.MODELO = P.MODELO AND NOT EXISTS (SELECT I.MODELO
										 FROM IMPRESORA 
										 WHERE I.COLOR ILIKE 'ROJO' AND P.MODELO = I.MODELO) AND NOT EXISTS (SELECT I.MODELO
																											 FROM IMPRESORA 
																											 WHERE I.COLOR ILIKE 'AZUL' AND P.MODELO = I.MODELO)

/*3. Mostrar el nombre de los fabricantes que no produce impresora de tipo 3D*/
SELECT P.FABRICANTE
FROM PRODUCTO P, IMPRESORA I
WHERE I.MODELO = P.MODELO AND NOT EXISTS (SELECT *
									 FROM IMPRESORA I
									 WHERE I.MODELO = P.MODELO AND I.TIPO LIKE '3D');

/*4. Mostrar el nombre de los fabricantes y el costo promedio de las impresoras producidas por ellos*/
SELECT P.FABRICANTE, AVG(P.PRECIO)
FROM PRODUCTO P, IMPRESORA I
WHERE P.MODELO=I.MODELO
GROUP BY P.FABRICANTE

/*5. Mostrar el nombre de los modelos de los PCs que tengas el precio más alto.*/
SELECT P.MODELO --MUESTRO EL MODELO
FROM PRODUCTO P, PC 
WHERE PC.MODELO=P.MODELO AND P.PRECIO = (SELECT MAX(PRECIO) --ELIJO EL PRECIO MAS ALTO Y LO IGUALO AL PRODUCTO CON EL MISMO PRECIO.
										  FROM PRODUCTO P2, PC PC1
										  WHERE P2.MODELO = PC1.MODELO)
										  
/*6. Mostrar el nombre de los fabricantes que producen las impresoras más económicas.*/
SELECT P.MODELO --MUESTRO EL MODELO
FROM PRODUCTO P, IMPRESORA I 
WHERE I.MODELO=P.MODELO AND P.PRECIO = (SELECT MIN(PRECIO) --ELIJO EL PRECIO MAS ALTO Y LO IGUALO AL PRODUCTO CON EL MISMO PRECIO.
										  FROM PRODUCTO P2, IMPRESORA I1
										  WHERE P2.MODELO = I1.MODELO)
										  
/*7. Mostrar el modelo y tipo de impresora donde el fabricante no sea Canon o Epson.*/
SELECT P.MODELO, I.TIPO
FROM PRODUCTO P, IMPRESORA I
WHERE I.MODELO=P.MODELO AND I.MODELO NOT IN (SELECT MODELO 
											 FROM PRODUCTO 
											 WHERE FABRICANTE LIKE 'CANON' OR FABRICANTE LIKE 'EPSON')

/*8. Muestre el fabricante que donde el precio promedio de los PC sea el más bajo pero 
que tenga la velocidad más alta (utilizar vistas).*/

CREATE VIEW PREC_PROM_PC AS (
	SELECT P.MODELO, AVG(P.PRECIO) AS PROMEDIO
	FROM PRODUCTO P, PC
	WHERE P.MODELO = PC.MODELO
	GROUP BY P.MODELO
);

CREATE VIEW MAX_VELOCIDAD AS (
	SELECT MODELO, MAX(VELOCIDAD) AS VELOCIDAD
	FROM PC
	GROUP BY MODELO
);

SELECT P.FABRICANTE
FROM PRODUCTO P, PC
WHERE PC.MODELO=P.MODELO 
AND P.PRECIO = (SELECT MAX(PROMEDIO) FROM PREC_PROM_PC) 
AND PC.VELOCIDAD = (SELECT MAX(VELOCIDAD) FROM MAX_VELOCIDAD)

/*9. Mostrar el fabricante, la cantidad de impresoras y el costo promedio que tiene cada fabricante,
considerando en el resultado sólo los que tiene más de 3 impresora*/

CREATE VIEW PREC_PROM_IMP AS (
	SELECT P.FABRICANTE AS FABRICANTE, AVG(P.PRECIO) AS PROMEDIO, COUNT(I.MODELO) AS CANTIDAD
	FROM PRODUCTO P, IMPRESORA I
	WHERE P.MODELO = I.MODELO 
	GROUP BY P.FABRICANTE
);

SELECT FABRICANTE
FROM PREC_PROM_IMP
WHERE CANTIDAD > 3

/*10. Mostrar el nombre de cada fabricante y el porcentaje de impresoras con respecto
al número total de productos (pc e impresoras)*/











