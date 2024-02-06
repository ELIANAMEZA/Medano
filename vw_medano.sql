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