/* ============================================================
  1.Productos con menor rotación
   ============================================================ */
   SELECT TOP (1000) [id_producto]
      ,[id_sucursal]
      ,[stock_actual]
  FROM [Ventas_Tech_DB].[dbo].[stock]


/* ============================================================
 2. Sucursales con mayor acumulación de stock 
   ============================================================ */

   SELECT
    id_sucursal,
    SUM(stock_actual) AS stock_total
FROM stock
GROUP BY id_sucursal
ORDER BY stock_total DESC;

/* ============================================================
 3. ¿Los descuentos generan mayor volumen de ventas?
   ============================================================ */

   SELECT
    descuento,
    SUM(cantidad) AS unidades_vendidas
FROM detalle_venta
GROUP BY descuento
ORDER BY unidades_vendidas DESC;

/* ============================================================
 4. Productos con ofertas
   ============================================================ */

   SELECT
    id_producto,
    porcentaje_descuento
FROM campania_producto
ORDER BY porcentaje_descuento DESC;

/* ============================================================
 5. Clientes recurrentes
   ============================================================ */

   SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(monto_total) AS total_gastado
FROM venta
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

/* ============================================================
 6. Promedio de unidades vendidas por producto
   ============================================================ */

   SELECT
    AVG(cantidad) AS promedio_unidades_vendidas
FROM detalle_venta;

/* ============================================================
 6. Precio MIN y MAX de producto.
   ============================================================ */

SELECT
    MIN(precio_unitario) AS precio_minimo,
    MAX(precio_unitario) AS precio_maximo
FROM producto;
GO

/* ============================================================
1. No existen clientes recurrentes en los datos analizados, ya que ningún cliente registra más de un pedido.
2. La sucursal 6 presenta la mayor acumulación de stock, con un total de 84 unidades disponibles.
3. El descuento del 5% registra el mayor volumen de ventas, con 5 unidades vendidas.
   ============================================================ */