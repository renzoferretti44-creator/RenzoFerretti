/*Creo la base de datos*/
CREATE DATABASE Ventas_Tech_DB;
GO

/*Me posiciono sobre la base de datos creada*/
USE Ventas_Tech_DB;
GO

/*ELIMINO LAS TABLAS POR LAS DUDAS QUE EXISTAN PREVIAMENTE*/
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

/*Creo las tablas de dimension*/

CREATE TABLE dbo.DimCategoria(
Id_Categoria INT PRIMARY KEY,
Nombre_Categoria VARCHAR (50) NOT NULL,
Descripcion VARCHAR (200)
);

CREATE TABLE dbo.DimClientes(
Id_Cliente INT PRIMARY KEY,
Nombre VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE,
Ciudad VARCHAR(50),
Fecha_Registro DATE NOT NULL
);

CREATE TABLE dbo.DimProductos(
Id_Producto INT PRIMARY KEY,
Nombre_producto VARCHAR(100) NOT NULL,
Id_Categoria INT NOT NULL,
Precio DECIMAL(10,2),
Stock INT DEFAULT 0,
Activo INT DEFAULT 1,
CONSTRAINT FK_Dim_Categoria FOREIGN KEY (Id_Categoria) REFERENCES dbo.DimCategoria(Id_Categoria)
);
GO

/*Creo la tabla de hechos*/

CREATE TABLE dbo.FactVentas(
Id_Venta INT PRIMARY KEY,
Id_Cliente INT NOT NULL,
Id_Producto INT NOT NULL,
Cantidad INT NOT NULL,
Precio_Unitario DECIMAL(10,2),
Fecha_Venta DATE NOT NULL,
CONSTRAINT FK_Fact_clientes FOREIGN KEY(Id_Cliente) REFERENCES dbo.DimClientes(Id_Cliente),
CONSTRAINT FK_Fact_Productos FOREIGN KEY (Id_Producto) REFERENCES dbo.DimProductos(Id_producto)
);
GO

/*carga de registros en categoria*/

INSERT INTO dbo.DimCategoria VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO dbo.DimCategoria VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO dbo.DimCategoria VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO dbo.DimCategoria VALUES (4, 'Almacenamiento', 'Discos y memorias');

/*carga de registros en clientes*/

INSERT INTO dbo.DimClientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO dbo.DimClientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO dbo.DimClientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO dbo.DimClientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO dbo.DimClientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

/*carga de registros en productos*/

INSERT INTO dbo.Dimproductos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO dbo.Dimproductos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO dbo.Dimproductos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO dbo.Dimproductos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO dbo.Dimproductos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO dbo.Dimproductos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

/*carga de registros en ventas*/

INSERT INTO dbo.FactVentas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO dbo.FactVentas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO dbo.FactVentas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO dbo.FactVentas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO dbo.FactVentas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO dbo.FactVentas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO dbo.FactVentas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO dbo.FactVentas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO dbo.FactVentas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO dbo.FactVentas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

/*valido la carga de datos*/

SELECT * FROM dbo.DimCategoria;
SELECT * FROM dbo.DimClientes;
SELECT * FROM dbo.DimProductos;
SELECT * FROM dbo.Factventas;

