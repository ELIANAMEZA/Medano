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