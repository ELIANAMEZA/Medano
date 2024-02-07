CREATE SCHEMA MEDANO;
USE MEDANO;

-- CREAR TABLA CLIENTES

CREATE TABLE IF NOT EXISTS CLIENTES(
ID_CL INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
NOMBRE_CL VARCHAR(30) NOT NULL,
APELLIDO_CL VARCHAR(30) NOT NULL,
CORREO_CL VARCHAR(50) DEFAULT 'NULL',
TEL_CL VARCHAR(20) NOT NULL UNIQUE,
FECHA_NAC_CL DATE
)ENGINE=InnoDB DEFAULT CHARSET utf8mb4;


-- CREAR TABLA CONSULTA HOMEOPATICA

CREATE TABLE IF NOT EXISTS CONSULTA_H(
NRO_ID_CH INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
NOMBRE_PROF_CH VARCHAR(30) NOT NULL,
APELLIDO_PROF_CH VARCHAR(30) NOT NULL,
ID_CL INT UNSIGNED NOT NULL,
FECHA_RES_CH DATE NOT NULL,
HORA_RES_CH TIME NOT NULL,
CONSTRAINT FKD_ID_CL_CH FOREIGN KEY(ID_CL) REFERENCES CLIENTES(ID_CL)
)ENGINE=InnoDB default CHARSET utf8mb4;

-- CREAR TABLA PRODUCTOS

CREATE TABLE IF NOT EXISTS PRODUCTOS(
ID_PRODUCTOS INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
MARCA VARCHAR(20) NOT NULL,
NOMBRE_PRODUCTO VARCHAR(20) NOT NULL,
STOCK INT,
CATEGORIA VARCHAR(20) NOT NULL
)ENGINE=INNODB DEFAULT CHARSET UTF8MB4;

-- CREAR TABLA PEDIDOS

CREATE TABLE IF NOT EXISTS PEDIDOS(
ID_PEDIDOS INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
ID_CL INT UNSIGNED NOT NULL,
ID_PRODUCTOS INT UNSIGNED NOT NULL,
FECHA_PEDIDOS DATE NOT NULL,
CONSTRAINT FKD_ID_CL_PEDIDOS FOREIGN KEY(ID_CL) REFERENCES CLIENTES(ID_CL),
CONSTRAINT FKD_ID_PRODUCTOS_PEDIDOS FOREIGN KEY(ID_PRODUCTOS) REFERENCES PRODUCTOS(ID_PRODUCTOS)
)ENGINE=INNODB DEFAULT CHARSET UTF8MB4;


-- CREAR TABLA PROVEEDORES

CREATE TABLE IF NOT EXISTS PROVEEDORES(
ID_PROVEEDORES INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
ID_PRODUCTOS INT UNSIGNED NOT NULL,
NOMBRE_PROVEEDORES VARCHAR(30) NOT NULL,
DIRECCION_PROVEEDORES VARCHAR(30) NOT NULL,
TEL_PROVEEDORES VARCHAR (20) NOT NULL UNIQUE,
CONSTRAINT FKD_ID_PRODUCTOS_PROVEEDORES FOREIGN KEY (ID_PRODUCTOS) REFERENCES PRODUCTOS(ID_PRODUCTOS)
)ENGINE=InnoDB DEFAULT CHARSET utf8mb4;

-- CREAR TABLA EMPLEADOS

CREATE TABLE IF NOT EXISTS EMPLEADOS(
ID_EMPLEADO INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
NOMBRE_EMPLEADO VARCHAR(30) NOT NULL,
APELLIDO_EMPLEADO VARCHAR(30) NOT NULL,
DIRECCION_EMPLEADO VARCHAR(30) NOT NULL,
TEL_EMPLEADO VARCHAR(30) NOT NULL UNIQUE,
CORREO_EMPLEADO VARCHAR(50) DEFAULT 'NULL'
)ENGINE=InnoDB DEFAULT CHARSET utf8mb4;

DROP TABLE EMPLEADOS;

-- CREAR TABLA VENTAS

CREATE TABLE IF NOT EXISTS VENTAS(
ID_VENTA INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
ID_EMPLEADO INT UNSIGNED NOT NULL,
ID_PEDIDOS INT UNSIGNED NOT NULL,
TOTAL VARCHAR(20) NOT NULL,
MODALIDAD_PAGO VARCHAR(20) NOT NULL,
CONSTRAINT FKD_ID_EMPLEADO_VENTAS FOREIGN KEY(ID_EMPLEADO) REFERENCES EMPLEADOS(ID_EMPLEADO),
CONSTRAINT FKD_ID_PEDIDOS_VENTAS FOREIGN KEY(ID_PEDIDOS) REFERENCES PEDIDOS(ID_PEDIDOS)
)ENGINE=INNODB DEFAULT CHARSET UTF8MB4;


-- DROP SCHEMA MEDANO;

-- SE CREARON LOS SIGUIENTES VIEW
-- VIEW QUE MUESTRE LA TABLA CLIENTES ORDENADO DESCENDENTE POR APELLIDO_CL
CREATE OR REPLACE VIEW V_CLIENTES AS
(SELECT APELLIDO_CL, FECHA_NAC_CL
FROM CLIENTES
ORDER BY APELLIDO_CL DESC);

SELECT * FROM V_CLIENTES;

-- VIEW QUE MUSTRE LA TABLA PRODUCTOS POR NOMBRE_PRODUCTO CON STOCK MAYOR A 10
CREATE OR REPLACE VIEW V_PRODUCTOS AS
(SELECT NOMBRE_PRODUCTO, STOCK
FROM PRODUCTOS
GROUP BY NOMBRE_PRODUCTO, STOCK
HAVING STOCK >10);
SELECT * FROM V_PRODUCTOS;

-- VIEW QUE MUESTRE PROVEEDORES QUE LA DIRECCIÓN COMIENCE CON AV.
CREATE OR REPLACE VIEW V_PROVEEDORES AS
(SELECT DIRECCION_PROVEEDORES
FROM PROVEEDORES 
WHERE DIRECCION_PROVEEDORES LIKE ('AV.%'));
SELECT *FROM V_PROVEEDORES;

-- VIEW QUE MUESTRE CLIENTES NACIDOS EN 1986
CREATE OR REPLACE VIEW V_CLIENTES_FECHA AS
(SELECT FECHA_NAC_CL
FROM CLIENTES 
WHERE FECHA_NAC_CL LIKE ('1986%'));
SELECT * FROM V_CLIENTES_FECHA;


-- VIEW QUE MUSTRE LA TABLA PRODUCTOS POR CATEGORIA EN ORDEN DESCENDENTE
CREATE OR REPLACE VIEW V_PRODUCTOS_CAT AS
(SELECT NOMBRE_PRODUCTO, CATEGORIA
FROM PRODUCTOS
ORDER BY CATEGORIA DESC);

SELECT * FROM V_PRODUCTOS_CAT;

-- VIEW QUE MUESTRE LA TABLA VENTAS POR ID_EMPLEADO
CREATE OR REPLACE VIEW V_VENTAS_EMPLEADO AS
(SELECT ID_VENTA, ID_EMPLEADO
FROM VENTAS
ORDER BY ID_EMPLEADO ASC);

SELECT * FROM V_VENTAS_EMPLEADO;

-- SE CREARON LAS SIGUIENTES FUNCIONES
-- Quiero que me traigan el nombre según el Id de cliente
DELIMITER //
CREATE FUNCTION fn_traer_cliente (CL_ID INT)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
DECLARE resultado VARCHAR (30);
SET resultado = (SELECT NOMBRE_CL FROM clientes WHERE ID_CL = CL_ID);
RETURN resultado;
END 
 //

-- Quiero que me traiga el stock por categoría 
DELIMITER //
CREATE FUNCTION fn_ver_stock (categoria_producto VARCHAR(30)) 
RETURNS INT
READS SQL DATA
BEGIN
DECLARE resultado INT;
SET resultado = (SELECT STOCK FROM productos WHERE categoria = categoria_producto);
RETURN resultado;
END
//

-- STORE PROCEDURE
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

-- SP PARA ORDENAR UN DATO/REGISTRO

DELIMITER //
CREATE PROCEDURE sp_ordenar_productos (IN campo VARCHAR (30), IN orden VARCHAR(30))
BEGIN 

SET @ordenar = CONCAT('SELECT * FROM productos ORDER BY', ' ', campo, ' ', orden);

PREPARE consulta FROM @ordenar; 
EXECUTE consulta;
DEALLOCATE PREPARE consulta;

END
//
CALL sp_ordenar_productos (‘MARCA’, ‘desc’);

select * from productos;

-- TRIGGER
-- creamos la tabla de auditoria
CREATE TABLE auditoriaClientes
(
id_auditoria_clientes INT PRIMARY KEY AUTO_INCREMENT,
ID_CL INT NOT NULL,
NOMBRE_CL varchar(30),
APELLIDO_CL varchar(30),
CORREO_CL varchar(50),
TEL_CL varchar(20),
FECHA_NAC_CL date,
usuario VARCHAR (255),
fecha_hora DATETIME,
tipo_mov varchar(255) 
);

-- creamos un trigger
CREATE TRIGGER auditoria_insercion_cliente
AFTER INSERT ON clientes 
FOR EACH ROW
INSERT INTO auditoriaClientes VALUES 
(DEFAULT, new.ID_CL, new.NOMBRE_CL, new.APELLIDO_CL, new.CORREO_CL, new.TEL_CL, new.FECHA_NAC_CL, USER(),
 NOW(),'se inserto un nuevo cliente');
 
 -- Insertamos en la tabla de clientes nuevos registros
INSERT INTO medano.clientes VALUES (DEFAULT, 'Paolo', 'Henry','paolohenry@gmail.com','1564583231','1940-08-10');
INSERT INTO medano.clientes VALUES (DEFAULT, 'Micaela', 'Gomez','micaelagomez@gmail.com','1567859436','1989-05-10');

-- consultamos la tabla auditoriaClientes
SELECT * FROM auditoriaClientes;
select * from clientes;

-- creamos un trigger de eliminación

CREATE TRIGGER auditoria_eliminacion_cliente
BEFORE DELETE ON clientes 
FOR EACH ROW
INSERT INTO auditoriaClientes VALUES 
(DEFAULT, OLD.ID_CL, OLD.NOMBRE_CL, OLD.APELLIDO_CL, OLD.CORREO_CL, OLD.TEL_CL, OLD.FECHA_NAC_CL, USER(),
 NOW(),'se elimina un cliente');

-- Eliminamos en la tabla de clientes un registro
DELETE FROM clientes WHERE ID_CL=12;

-- consultamos la tabla auditoriaClientes
SELECT * FROM auditoriaClientes;
-- consultamos la tabla clientes
SELECT * FROM clientes;

-- trigger de modificación
DROP TABLE IF EXISTS auditoriaStock;

#creamos la tabla de auditoria de stock
CREATE TABLE auditoriaStock(
id_log INT PRIMARY KEY AUTO_INCREMENT,
ID_PRODUCTOS INT NOT NULL,
VIEJMARCA varchar (20),
VIEJONOMBRE_PRODUCTO varchar (20),
VIEJOSTOCK int,
VIEJACATEGORIA varchar (20) ,
usuario VARCHAR (60),
fecha_hora DATETIME,
tipo_mov varchar (255),
NuevoNombre varchar (20),
NuevoStock int,
NuevaCategoria varchar (20)
);

DROP TRIGGER IF EXISTS  auditoria_mod_stock;

CREATE TRIGGER auditoria_mod_stock
AFTER UPDATE ON PRODUCTOS
FOR EACH ROW
INSERT INTO auditoriaStock VALUES 
(DEFAULT,old.ID_PRODUCTOS,old.MARCA,old.NOMBRE_PRODUCTO,old.STOCK,old.CATEGORIA,USER(), NOW(),'se modifica un producto',new.NOMBRE_PRODUCTO,new.STOCK,new.CATEGORIA);


#Modificamos  en la tabla de productos una cantidad
UPDATE PRODUCTOS SET NOMBRE_PRODUCTO='Jugo de Arándanos',STOCK=70, CATEGORIA='bebida' WHERE ID_PRODUCTOS=2;

#consultamos la tabla auditoriaStock
SELECT * FROM auditoriaStock;
#consultamos la tabla productos
SELECT * FROM productos;
rollback;