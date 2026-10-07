-- ============================================================
-- CONSULTA 1 — Vista base del proyecto (INNER JOIN)
-- ============================================================
SELECT
    v.fecha,
    c.id_cliente,
    c.nombre_cliente,
    tc.nombre_tipo_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal AS total_venta,
    ci.nombre_ciudad,
    r.nombre_region,
    s.nombre_sucursal
FROM venta AS v
INNER JOIN cliente AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN detalle_venta AS dv
    ON v.id_venta = dv.id_venta
INNER JOIN producto AS p
    ON dv.id_producto = p.id_producto
INNER JOIN categoria AS cat
    ON p.id_categoria = cat.id_categoria
INNER JOIN tipo_cliente AS tc
    ON c.id_tipo_cliente = tc.id_tipo_cliente
INNER JOIN ciudad AS ci
    ON c.id_ciudad = ci.id_ciudad
INNER JOIN region AS r
    ON ci.id_region = r.id_region
INNER JOIN sucursal AS s
    ON v.id_sucursal = s.id_sucursal
ORDER BY v.fecha;


-- ============================================================
-- CONSULTA 2 — Clientes sin ventas (LEFT JOIN)
-- ============================================================

SELECT
    c.id_cliente,
    c.nombre_cliente,
    c.email
FROM cliente AS c
LEFT JOIN venta AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- ============================================================
-- CONSULTA 3 — Productos sin ventas (LEFT JOIN)
-- ============================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio_unitario
FROM producto AS p
INNER JOIN categoria AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN detalle_venta AS dv
    ON p.id_producto = dv.id_producto
WHERE dv.id_detalle_venta IS NULL;


-- ============================================================
-- CONSULTA 4 — Consolidado por canal (UNION ALL)
-- ============================================================

SELECT
    canal,
    SUM(total) AS total_canal
FROM
(
    SELECT
        v.fecha,
        dv.cantidad * dv.precio_unitario AS total,
        'Enero-Junio 2026' AS canal
    FROM venta AS v
    INNER JOIN detalle_venta AS dv
        ON v.id_venta = dv.id_venta
    WHERE v.fecha >= '2026-01-01'
      AND v.fecha < CAST('2026-07-01' AS DATETIME2)

    UNION ALL

    SELECT
        v.fecha,
        dv.cantidad * dv.precio_unitario AS total,
        'Julio-Diciembre 2026' AS canal
    FROM venta AS v
    INNER JOIN detalle_venta AS dv
        ON v.id_venta = dv.id_venta
    WHERE v.fecha >= CAST('2026-07-01' AS DATETIME2)
      AND v.fecha < CAST('2027-01-01' AS DATETIME2)
) AS consolidado
GROUP BY canal
ORDER BY canal;