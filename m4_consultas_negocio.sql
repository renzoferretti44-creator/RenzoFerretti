-- Consulta 1 — Resumen ejecutivo mensual Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. Calculá el total como cantidad * precio_unitario. Usá alias descriptivos en español y agrupá por mes con EXTRACT(MONTH FROM fecha_venta).

SELECT
MONTH(Fecha_Venta) AS Mes,
SUM(Cantidad * Precio_Unitario) AS Total_Facturado,
COUNT(Id_Venta) AS Cantidad_Pedidos,
AVG(Cantidad * Precio_Unitario) AS Ticket_Promedio
FROM dbo.FactVentas
GROUP BY MONTH(Fecha_Venta)
ORDER BY Mes;

-- Consulta 2 — Ranking de productos Top 5 de id_producto por total facturado, mostrando las unidades vendidas (SUM(cantidad)) y el total generado. Usá GROUP BY id_producto, ORDER BY y limitá el resultado a 5.

SELECT TOP 5
Id_Producto,
SUM(Cantidad) AS Unidades_Vendidas,
SUM(Cantidad * Precio_Unitario) AS Total_Facturado
FROM dbo.FactVentas
GROUP BY Id_Producto
ORDER BY Total_Facturado DESC;

-- Consulta 3 — Clientes recurrentes id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. Usá GROUP BY id_cliente y HAVING COUNT(*) > 1.

SELECT
Id_Cliente,
COUNT(*) AS Cantidad_Pedidos,
SUM(Cantidad * Precio_Unitario) AS Total_Gastado
FROM dbo.FactVentas
GROUP BY Id_Cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado DESC;

-- Consulta 4 — Meses por encima/por debajo del promedio Total facturado por mes, con una columna adicional que etiquete con CASE WHEN si ese mes quedó 'Por encima' o 'Por debajo' del promedio mensual general.

WITH VentasMensuales AS
(
SELECT
MONTH(Fecha_Venta) AS Mes,
SUM(Cantidad * Precio_Unitario) AS Total_Facturado
FROM dbo.FactVentas
GROUP BY MONTH(Fecha_Venta)
)
SELECT
Mes,
Total_Facturado,
CASE
WHEN Total_Facturado >
(
SELECT AVG(Total_Facturado)
FROM VentasMensuales
)
THEN 'Por encima'
ELSE 'Por debajo'
END AS Comparacion_Promedio
FROM VentasMensuales;

-- HALLAZGOS DE NEGOCIO

-- 1. El producto 1 concentra aproximadamente el 56% de la facturación total analizada.

-- 2. Todos los clientes registrados realizaron más de una compra, evidenciando un alto nivel de recurrencia en la base de clientes.

-- 3. Los productos de alto valor unitario (laptops y monitores) generan la mayor parte de los ingresos
