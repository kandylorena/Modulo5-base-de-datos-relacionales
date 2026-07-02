-- ============================================================
-- QUERIES: Consultas de información del e-commerce
-- ============================================================

-- 1. Listar todos los productos junto a su categoría
SELECT p.id, p.nombre AS producto, p.precio, c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
ORDER BY c.nombre, p.nombre;

-- 2. Buscar productos por nombre (contenga "cam")
SELECT id, nombre, precio, descripcion
FROM productos
WHERE nombre ILIKE '%cam%';

-- 3. Filtrar productos por categoría (ej: Electrónica)
SELECT p.id, p.nombre, p.precio, p.descripcion
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
WHERE c.nombre = 'Electrónica'
ORDER BY p.nombre;

-- 4. Mostrar los productos asociados a un pedido (ej: pedido 1)
SELECT dp.id AS detalle_id, p.nombre AS producto, dp.cantidad,
       dp.precio_unitario, (dp.cantidad * dp.precio_unitario) AS subtotal
FROM detalle_pedidos dp
JOIN productos p ON dp.producto_id = p.id
WHERE dp.pedido_id = 1
ORDER BY p.nombre;

-- 5. Calcular el total de un pedido (ej: pedido 1)
SELECT pe.id AS pedido_id, u.nombre AS cliente,
       pe.fecha_pedido, pe.estado,
       SUM(dp.cantidad * dp.precio_unitario) AS total_calculado,
       pe.total AS total_registrado
FROM pedidos pe
JOIN usuarios u ON pe.usuario_id = u.id
JOIN detalle_pedidos dp ON dp.pedido_id = pe.id
WHERE pe.id = 1
GROUP BY pe.id, u.nombre, pe.fecha_pedido, pe.estado, pe.total;

-- 6. Identificar productos con stock bajo (menos de 5 unidades)
SELECT p.id, p.nombre, s.cantidad AS stock_actual
FROM stock s
JOIN productos p ON s.producto_id = p.id
WHERE s.cantidad < 5
ORDER BY s.cantidad;
