/* ============================================================
   PROYECTO BASE DE DATOS - VENTAS TECH
   SQL SERVER

   Script repetible:
   1. Elimina la base si existe
   2. Crea la base nuevamente
   3. Crea las tablas
   4. Inserta los datos
   ============================================================ */


/* ============================================================
   1. ELIMINAR LA BASE SI YA EXISTE
   ============================================================ */

USE master;
GO

DROP DATABASE IF EXISTS Ventas_Tech_DB;
GO

CREATE DATABASE Ventas_Tech_DB;
GO

USE Ventas_Tech_DB;
GO


/* ============================================================
   3. CREAR TABLA REGION
   ============================================================ */

CREATE TABLE region (
    id_region INT IDENTITY(1,1) PRIMARY KEY,
    nombre_region VARCHAR(100) NOT NULL UNIQUE
);
GO


/* ============================================================
   4. CREAR TABLA CIUDAD
   ============================================================ */

CREATE TABLE ciudad (
    id_ciudad INT IDENTITY(1,1) PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    id_region INT NOT NULL,

    CONSTRAINT fk_ciudad_region
        FOREIGN KEY (id_region)
        REFERENCES region(id_region)
);
GO


/* ============================================================
   5. CREAR TABLA TIPO_CLIENTE
   ============================================================ */

CREATE TABLE tipo_cliente (
    id_tipo_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tipo_cliente VARCHAR(50) NOT NULL UNIQUE
);
GO


/* ============================================================
   6. CREAR TABLA CLIENTE
   ============================================================ */

CREATE TABLE cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_cliente VARCHAR(150) NOT NULL,
    id_tipo_cliente INT NOT NULL,
    email VARCHAR(150) NULL,
    id_ciudad INT NOT NULL,

    CONSTRAINT fk_cliente_tipo_cliente
        FOREIGN KEY (id_tipo_cliente)
        REFERENCES tipo_cliente(id_tipo_cliente),

    CONSTRAINT fk_cliente_ciudad
        FOREIGN KEY (id_ciudad)
        REFERENCES ciudad(id_ciudad)
);
GO


/* ============================================================
   7. CREAR TABLA SUCURSAL
   ============================================================ */

CREATE TABLE sucursal (
    id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sucursal VARCHAR(100) NOT NULL,
    id_ciudad INT NOT NULL,

    CONSTRAINT fk_sucursal_ciudad
        FOREIGN KEY (id_ciudad)
        REFERENCES ciudad(id_ciudad)
);
GO


/* ============================================================
   8. CREAR TABLA CATEGORIA
   ============================================================ */

CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE
);
GO


/* ============================================================
   9. CREAR TABLA PRODUCTO
   ============================================================ */

CREATE TABLE producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(150) NOT NULL,
    id_categoria INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    costo DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);
GO


/* ============================================================
   10. CREAR TABLA VENTA
   ============================================================ */

CREATE TABLE venta (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATETIME2 NOT NULL,
    id_cliente INT NOT NULL,
    id_sucursal INT NOT NULL,
    monto_total DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_venta_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES sucursal(id_sucursal)
);
GO


/* ============================================================
   11. CREAR TABLA DETALLE_VENTA
   ============================================================ */

CREATE TABLE detalle_venta (
    id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,

    descuento DECIMAL(5,2) NOT NULL
        CONSTRAINT df_detalle_venta_descuento DEFAULT 0,

    subtotal DECIMAL(12,2) NOT NULL,

    CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta),

    CONSTRAINT fk_detalle_venta_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);
GO


/* ============================================================
   12. CREAR TABLA STOCK
   ============================================================ */

CREATE TABLE stock (
    id_producto INT NOT NULL,
    id_sucursal INT NOT NULL,

    stock_actual INT NOT NULL
        CONSTRAINT df_stock_actual DEFAULT 0,

    CONSTRAINT pk_stock
        PRIMARY KEY (id_producto, id_sucursal),

    CONSTRAINT fk_stock_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    CONSTRAINT fk_stock_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES sucursal(id_sucursal)
);
GO


/* ============================================================
   13. CREAR TABLA CAMPANIA
   ============================================================ */

CREATE TABLE campania (
    id_campania INT IDENTITY(1,1) PRIMARY KEY,
    nombre_campania VARCHAR(150) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);
GO


/* ============================================================
   14. CREAR TABLA CAMPANIA_PRODUCTO
   ============================================================ */

CREATE TABLE campania_producto (
    id_campania INT NOT NULL,
    id_producto INT NOT NULL,
    porcentaje_descuento DECIMAL(5,2) NOT NULL,

    CONSTRAINT pk_campania_producto
        PRIMARY KEY (id_campania, id_producto),

    CONSTRAINT fk_campania_producto_campania
        FOREIGN KEY (id_campania)
        REFERENCES campania(id_campania),

    CONSTRAINT fk_campania_producto_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);
GO


/* ============================================================
   ============================================================
   CARGA DE DATOS
   ============================================================
   ============================================================ */


/* ============================================================
   15. INSERT REGION
   ============================================================ */

INSERT INTO region
(nombre_region)
VALUES
('Metropolitana'),
('Valparaíso'),
('Biobío'),
('La Araucanía'),
('Coquimbo'),
('Los Lagos'),
('Maule'),
('Antofagasta');
GO


/* ============================================================
   16. INSERT CIUDAD
   ============================================================ */

INSERT INTO ciudad
(nombre_ciudad, id_region)
VALUES
('Santiago', 1),
('Valparaíso', 2),
('Viña del Mar', 2),
('Concepción', 3),
('Temuco', 4),
('La Serena', 5),
('Puerto Montt', 6),
('Talca', 7);
GO


/* ============================================================
   17. INSERT TIPO_CLIENTE
   ============================================================ */

INSERT INTO tipo_cliente
(nombre_tipo_cliente)
VALUES
('Cliente Regular'),
('Cliente Frecuente'),
('Cliente Premium'),
('Cliente Mayorista'),
('Cliente Empresa'),
('Cliente Nuevo'),
('Cliente Online'),
('Cliente Corporativo');
GO


/* ============================================================
   18. INSERT CLIENTE
   ============================================================ */

INSERT INTO cliente
(nombre_cliente, id_tipo_cliente, email, id_ciudad)
VALUES
('Juan Pérez González', 1, 'juan.perez@email.com', 1),
('María González Soto', 2, 'maria.gonzalez@email.com', 2),
('Carlos Rodríguez Díaz', 3, 'carlos.rodriguez@email.com', 3),
('Ana Martínez López', 4, 'ana.martinez@email.com', 4),
('Pedro Sánchez Muñoz', 5, 'pedro.sanchez@email.com', 5),
('Camila Torres Silva', 6, 'camila.torres@email.com', 6),
('Diego Fuentes Rojas', 7, 'diego.fuentes@email.com', 7),
('Valentina Castro Pérez', 8, 'valentina.castro@email.com', 8);
GO


/* ============================================================
   19. INSERT SUCURSAL
   ============================================================ */

INSERT INTO sucursal
(nombre_sucursal, id_ciudad)
VALUES
('Sucursal Centro Santiago', 1),
('Sucursal Providencia', 1),
('Sucursal Valparaíso Centro', 2),
('Sucursal Viña del Mar', 3),
('Sucursal Concepción Centro', 4),
('Sucursal Temuco Centro', 5),
('Sucursal La Serena', 6),
('Sucursal Puerto Montt', 7);
GO


/* ============================================================
   20. INSERT CATEGORIA
   ============================================================ */

INSERT INTO categoria
(nombre_categoria)
VALUES
('Electrónica'),
('Hogar'),
('Vestuario'),
('Calzado'),
('Accesorios'),
('Deportes'),
('Belleza'),
('Alimentos');
GO


/* ============================================================
   21. INSERT PRODUCTO
   ============================================================ */

INSERT INTO producto
(nombre_producto, id_categoria, precio_unitario, costo)
VALUES
('Audífonos Bluetooth', 1, 29990.00, 18000.00),
('Licuadora 1.5 Litros', 2, 45990.00, 28000.00),
('Polera Básica Hombre', 3, 15990.00, 8500.00),
('Zapatillas Running', 4, 59990.00, 35000.00),
('Mochila Urbana', 5, 24990.00, 14000.00),
('Bicicleta Mountain Bike', 6, 249990.00, 165000.00),
('Crema Facial Hidratante', 7, 12990.00, 6500.00),
('Café Molido 500g', 8, 8990.00, 4500.00);
GO


/* ============================================================
   22. INSERT VENTA
   ============================================================ */

INSERT INTO venta
(fecha, id_cliente, id_sucursal, monto_total)
VALUES
('2026-01-05 10:30:00', 1, 1, 59980.00),
('2026-01-08 11:15:00', 2, 2, 43690.50),
('2026-01-12 12:45:00', 3, 3, 43173.00),
('2026-01-18 15:20:00', 4, 4, 50991.50),
('2026-02-03 09:50:00', 5, 5, 49980.00),
('2026-02-10 16:10:00', 6, 6, 224991.00),
('2026-02-15 13:30:00', 7, 7, 49362.00),
('2026-02-22 17:45:00', 8, 8, 14384.00);
GO


/* ============================================================
   23. INSERT DETALLE_VENTA
   ============================================================ */

INSERT INTO detalle_venta
(id_venta, id_producto, cantidad, precio_unitario, descuento, subtotal)
VALUES
(1, 1, 2, 29990.00, 0.00, 59980.00),
(2, 2, 1, 45990.00, 5.00, 43690.50),
(3, 3, 3, 15990.00, 10.00, 43173.00),
(4, 4, 1, 59990.00, 15.00, 50991.50),
(5, 5, 2, 24990.00, 0.00, 49980.00),
(6, 6, 1, 249990.00, 10.00, 224991.00),
(7, 7, 4, 12990.00, 5.00, 49362.00),
(8, 8, 2, 8990.00, 20.00, 14384.00);
GO


/* ============================================================
   24. INSERT STOCK
   ============================================================ */

INSERT INTO stock
(id_producto, id_sucursal, stock_actual)
VALUES
(1, 1, 45),
(2, 1, 18),
(3, 2, 65),
(4, 2, 12),
(5, 3, 38),
(6, 3, 7),
(7, 4, 52),
(8, 4, 24),
(1, 5, 30),
(2, 5, 41),
(3, 6, 75),
(4, 6, 9),
(5, 7, 28),
(6, 7, 5),
(7, 8, 46),
(8, 8, 33);
GO


/* ============================================================
   25. INSERT CAMPANIA
   ============================================================ */

INSERT INTO campania
(nombre_campania, fecha_inicio, fecha_fin)
VALUES
('Campaña Verano 2026', '2026-01-01', '2026-01-31'),
('Campaña Regreso a Clases 2026', '2026-02-01', '2026-02-28'),
('Campaña Especial Marzo 2026', '2026-03-01', '2026-03-31');
GO


/* ============================================================
   26. INSERT CAMPANIA_PRODUCTO
   ============================================================ */

INSERT INTO campania_producto
(id_campania, id_producto, porcentaje_descuento)
VALUES
(1, 1, 10.00),
(1, 2, 15.00),
(1, 6, 20.00),
(2, 5, 10.00),
(2, 7, 15.00),
(2, 8, 20.00),
(3, 3, 10.00),
(3, 4, 15.00);
GO


/* ============================================================
   27. VERIFICACION DE CANTIDAD DE REGISTROS
   ============================================================ */

SELECT 'region' AS tabla, COUNT(*) AS cantidad FROM region
UNION ALL
SELECT 'ciudad', COUNT(*) FROM ciudad
UNION ALL
SELECT 'tipo_cliente', COUNT(*) FROM tipo_cliente
UNION ALL
SELECT 'cliente', COUNT(*) FROM cliente
UNION ALL
SELECT 'sucursal', COUNT(*) FROM sucursal
UNION ALL
SELECT 'categoria', COUNT(*) FROM categoria
UNION ALL
SELECT 'producto', COUNT(*) FROM producto
UNION ALL
SELECT 'venta', COUNT(*) FROM venta
UNION ALL
SELECT 'detalle_venta', COUNT(*) FROM detalle_venta
UNION ALL
SELECT 'stock', COUNT(*) FROM stock
UNION ALL
SELECT 'campania', COUNT(*) FROM campania
UNION ALL
SELECT 'campania_producto', COUNT(*) FROM campania_producto;
GO