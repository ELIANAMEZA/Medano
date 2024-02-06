-- Function
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
 
