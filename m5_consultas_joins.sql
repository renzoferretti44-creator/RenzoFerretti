--Consulta 1 — Vista base del proyecto (INNER JOIN)
--Trabajás sobre el esquema que creaste en el Checkpoint del Módulo 3. Combiná con INNER JOIN tu tabla de ventas con las tablas descriptivas que hayas modelado (clientes, productos y cualquier otra dimensión de tu caso de negocio) para obtener en una sola fila, como mínimo: fecha, identificación del cliente, descripción del producto, cantidad, precio unitario y total de venta.
--Sumá además las columnas descriptivas que existan en tu propio esquema (por ejemplo segmento de cliente, categoría de producto o región, si las modelaste). No es necesario que estén todas: la consulta se evalúa sobre las tablas que vos diseñaste, no sobre una lista fija.
--Si tu esquema no tiene ninguna dimensión geográfica ni de segmentación, agregala ahora al script del Módulo 3 con dos o tres registros de ejemplo. Esta consulta va a ser la fuente de datos principal en Power BI, así que conviene que tenga al menos una columna para agrupar y una para filtrar.

SELECT
fv.Fecha_Venta AS Fecha,
c.Id_Cliente,
c.Nombre AS Cliente,
c.Ciudad,
p.Nombre_Producto AS Producto,
cat.Nombre_Categoria AS Categoria,
fv.Cantidad,
fv.Precio_Unitario AS Precio,
fv.Cantidad * fv.Precio_Unitario AS Total_Venta
FROM dbo.FactVentas fv
INNER JOIN dbo.DimClientes c
ON fv.Id_Cliente = c.Id_Cliente
INNER JOIN dbo.DimProductos p
ON fv.Id_Producto = p.Id_Producto
INNER JOIN dbo.DimCategoria cat
ON p.Id_Categoria = cat.Id_Categoria;

-- Mi tabla Dim.Cliente posee el campo geografico solicitado en la consigna, este es CIUDAD.



-- Consulta 2 — Clientes sin ventas (LEFT JOIN) Identificá clientes registrados que aún no han realizado ninguna compra. Mostrá su nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.
SELECT
c.Nombre,
c.Email,
c.Fecha_Registro
FROM dbo.DimClientes c
LEFT JOIN dbo.FactVentas fv
ON c.Id_Cliente = fv.Id_Cliente
WHERE fv.Id_Venta IS NULL;

-- Nota: al ejecutarla tiene sentido que este vacia porque todos lo clientes realizaron al menos una compra en la carga de datos hecha.



-- Consulta 3 — Productos sin ventas (LEFT JOIN) Identificá productos del catálogo que no tienen ninguna venta registrada. Mostrá nombre del producto, categoría y precio. Usá WHERE ... IS NULL.
SELECT
p.Nombre_Producto AS Producto,
cat.Nombre_Categoria AS Categoria,
p.Precio
FROM dbo.DimProductos p
LEFT JOIN dbo.FactVentas fv
ON p.Id_Producto = fv.Id_Producto
INNER JOIN dbo.DimCategoria cat
ON p.Id_Categoria = cat.Id_Categoria
WHERE fv.Id_Venta IS NULL;

-- Nota: al ejecutarla tambien da vacio el resultado y tiene sentido porque todos los productos cargados se vendieron al menos una vez.



-- Consulta 4 — Consolidado por canal (UNION ALL)
--Importante: la columna canal no se consulta, se crea. No busques ese dato en tus tablas — lo generás vos dentro de cada SELECT como valor literal. Ese es el punto de este ejercicio.
--Escribí dos SELECT sobre tus ventas, separados por el criterio que corresponda a tu caso (por ejemplo, ventas de dos períodos, dos sucursales o dos orígenes distintos), y agregá en cada uno una columna de texto fija que identifique el origen. Unilos con UNION ALL y cerrá con un GROUP BY para obtener el total por cada origen.
--La estructura es esta:
--SELECT fecha, total, 'Online' AS canal FROM ventas WHERE ... UNION ALL SELECT fecha, total, 'Presencial' AS canal FROM ventas WHERE ...
--Las dos consultas tienen que devolver la misma cantidad de columnas, en el mismo orden y con tipos compatibles. Usamos UNION ALL y no UNION porque no queremos que se eliminen filas repetidas: cada venta debe contarse una sola vez, aunque coincida con otra en todos sus valores.

SELECT
periodo,
SUM(total) AS Total_Ventas
FROM
(
SELECT
Fecha_Venta,
Cantidad * Precio_Unitario AS total,
'Primera Quincena' AS periodo
FROM dbo.FactVentas
WHERE Fecha_Venta <= '2024-03-10'
 
UNION ALL
 
SELECT
Fecha_Venta,
Cantidad * Precio_Unitario AS total,
'Segunda Quincena' AS periodo
FROM dbo.FactVentas
WHERE Fecha_Venta > '2024-03-10'
) AS VentasConsolidadas
GROUP BY periodo;

-- Observacion: en la primera quincena el total de ventas fue mayor a la segunda quincena.