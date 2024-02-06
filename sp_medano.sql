-- sp para insertar un dato
DELIMITER //
CREATE PROCEDURE sp_insertar_dato( IN MARCAP VARCHAR(30), IN NOM VARCHAR(30), CANT INT, CATP VARCHAR(30))
BEGIN

INSERT INTO productos
(MARCA, NOMBRE_PRODUCTO, STOCK, CATEGORIA)
VALUES
(MARCAP, NOM, CANT, CATP);

END ;
//

CALL sp_insertar_dato ('GORDOCHANTA', 'POROTOS', 5, 'LEGUMBRES');

SELECT * FROM PRODUCTOS;

-- SP PARA ELIMINAR UN DATO

DELIMITER //
CREATE PROCEDURE sp_eliminar_dato (MARCAP VARCHAR(30), NOM VARCHAR(30), CANT INT, CATP VARCHAR(30))
BEGIN
SET sql_safe_updates=0;
DELETE FROM productos WHERE (MARCA = '2 hermanos' and NOMBRE_PRODUCTO = 'harina garbanzo'and STOCK = 5 and CATEGORIA = 'HARINA');

END ;
//
CALL sp_eliminar_dato ('2 hermanos', 'harina garbanzo', 5, 'HARINA');

SELECT * FROM PRODUCTOS;

-- SP PARA INSERTAR UN REGISTRO EN CONSULTA_H
DELIMITER //
CREATE PROCEDURE sp_insertar_registro( IN NOMBRE VARCHAR(30), IN APELLIDO VARCHAR(30))
BEGIN

INSERT INTO consulta_h
(NOMBRE_PROF_CH, APELLIDO_PROF_CH)
VALUES
('NOMBRE', 'APELLIDO');

END
//
CALL sp_insertar_registro('Ricardo', 'Ramirez');

-- SP PARA ORDENAR TABLAS Y CAMPOS

DELIMITER //
CREATE PROCEDURE sp_ordenar_productos(IN campo VARCHAR (30), IN orden VARCHAR(30))
BEGIN 

SET @ordenar = CONCAT('SELECT * FROM productos ORDER BY', ' ', campo, ' ', orden);

PREPARE consulta FROM @ordenar; 
EXECUTE consulta;
DEALLOCATE PREPARE consulta;

END
//
CALL sp_ordenar_productos('MARCA', 'desc');