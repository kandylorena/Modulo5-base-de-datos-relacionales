-- ============================================================
-- SEED: Datos de ejemplo
-- ============================================================

-- 1. CATEGORÍAS (3)
INSERT INTO categorias (nombre, descripcion)
VALUES
    ('Electrónica',   'Dispositivos electrónicos, gadgets y accesorios tecnológicos'),
    ('Ropa',          'Prendas de vestir para hombre y mujer'),
    ('Hogar',         'Artículos para el hogar, decoración y utensilios');

-- 2. PRODUCTOS (11)
INSERT INTO productos (nombre, descripcion, precio, categoria_id)
VALUES
    ('Smartphone XYZ',       'Smartphone con pantalla AMOLED 6.5", 128GB',       599.99,  1),
    ('Laptop Pro',           'Laptop con procesador i7, 16GB RAM, 512GB SSD',   1299.99, 1),
    ('Auriculares Bluetooth','Auriculares inalámbricos con cancelación de ruido', 79.99,  1),
    ('Reloj Inteligente',    'Smartwatch con GPS y monitor cardíaco',            199.99,  1),
    ('Camiseta Algodón',     'Camiseta de algodón orgánico, varios colores',      24.99,  2),
    ('Jeans Clásico',        'Jeans de corte recto, tela denim premium',          49.99,  2),
    ('Chaqueta Impermeable', 'Chaqueta con capucha, resistente al agua',          89.99,  2),
    ('Zapatos Deportivos',   'Zapatillas para running con amortiguación',         79.99,  2),
    ('Lámpara LED',          'Lámpara de escritorio LED regulable',               39.99,  3),
    ('Silla Ergonómica',     'Silla de oficina con soporte lumbar',              299.99,  3),
    ('Set de Sartenes',      'Set de 3 sartenes antiadherentes',                 149.99,  3);

-- 3. USUARIOS (5)
INSERT INTO usuarios (nombre, email, password_hash, rol)
VALUES
    ('Admin Principal', 'admin@tienda.com',    'hash_admin_123',  'admin'),
    ('Juan Pérez',      'juan@email.com',       'hash_juan_123',   'cliente'),
    ('María García',    'maria@email.com',      'hash_maria_123',  'cliente'),
    ('Carlos López',    'carlos@email.com',     'hash_carlos_123', 'cliente'),
    ('Ana Martínez',    'ana@email.com',        'hash_ana_123',    'cliente');

-- 4. STOCK
INSERT INTO stock (producto_id, cantidad)
VALUES
    (1,  15),  -- Smartphone XYZ
    (2,  8),   -- Laptop Pro
    (3,  30),  -- Auriculares Bluetooth
    (4,  12),  -- Reloj Inteligente
    (5,  50),  -- Camiseta Algodón
    (6,  20),  -- Jeans Clásico
    (7,  10),  -- Chaqueta Impermeable
    (8,  25),  -- Zapatos Deportivos
    (9,  4),   -- Lámpara LED (stock bajo)
    (10, 3),   -- Silla Ergonómica (stock bajo)
    (11, 18);  -- Set de Sartenes

-- 5. PEDIDOS (3) con sus DETALLES

-- Pedido 1: Juan Pérez
INSERT INTO pedidos (usuario_id, total, estado)
VALUES (2, 0, 'completado');
-- Items del pedido 1
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES
    (1, 1, 1, 599.99),
    (1, 3, 2,  79.99);
-- Actualizar total
UPDATE pedidos SET total = (SELECT SUM(cantidad * precio_unitario)
                            FROM detalle_pedidos WHERE pedido_id = 1)
WHERE id = 1;

-- Pedido 2: María García
INSERT INTO pedidos (usuario_id, total, estado)
VALUES (3, 0, 'completado');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES
    (2, 5, 3, 24.99),
    (2, 6, 1, 49.99),
    (2, 9, 1, 39.99);
UPDATE pedidos SET total = (SELECT SUM(cantidad * precio_unitario)
                            FROM detalle_pedidos WHERE pedido_id = 2)
WHERE id = 2;

-- Pedido 3: Carlos López
INSERT INTO pedidos (usuario_id, total, estado)
VALUES (4, 0, 'pendiente');
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
VALUES
    (3, 2, 1, 1299.99);
UPDATE pedidos SET total = (SELECT SUM(cantidad * precio_unitario)
                            FROM detalle_pedidos WHERE pedido_id = 3)
WHERE id = 3;
