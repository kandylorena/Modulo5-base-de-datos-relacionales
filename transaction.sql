-- ============================================================
-- TRANSACTION: Registro de una compra con control de stock
-- ============================================================

-- Ejemplo: El usuario María García (id=3) compra:
--   - 1 Laptop Pro (producto_id=2, precio=1299.99)
--   - 2 Auriculares Bluetooth (producto_id=3, precio=79.99)

DO $$
DECLARE
    v_usuario_id    INTEGER := 3;
    v_pedido_id     INTEGER;
    v_total         DECIMAL(12,2) := 0;
BEGIN
    -- Iniciar transacción
    -- (dentro de un bloque DO la transacción es implícita)

    -- 1. Validar stock suficiente para cada producto
    IF (SELECT cantidad FROM stock WHERE producto_id = 2) < 1 THEN
        RAISE EXCEPTION 'Stock insuficiente para Laptop Pro';
    END IF;

    IF (SELECT cantidad FROM stock WHERE producto_id = 3) < 2 THEN
        RAISE EXCEPTION 'Stock insuficiente para Auriculares Bluetooth';
    END IF;

    -- 2. Crear el pedido (cabecera)
    INSERT INTO pedidos (usuario_id, total, estado)
    VALUES (v_usuario_id, 0, 'pendiente')
    RETURNING id INTO v_pedido_id;

    -- 3. Registrar el detalle del pedido (producto 2)
    INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
    VALUES (v_pedido_id, 2, 1, 1299.99);
    v_total := v_total + (1 * 1299.99);

    -- 4. Actualizar stock del producto 2
    UPDATE stock
    SET cantidad = cantidad - 1
    WHERE producto_id = 2;

    -- 5. Registrar el detalle del pedido (producto 3)
    INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario)
    VALUES (v_pedido_id, 3, 2, 79.99);
    v_total := v_total + (2 * 79.99);

    -- 6. Actualizar stock del producto 3
    UPDATE stock
    SET cantidad = cantidad - 2
    WHERE producto_id = 3;

    -- 7. Actualizar el total del pedido
    UPDATE pedidos
    SET total = v_total, estado = 'completado'
    WHERE id = v_pedido_id;

    -- Confirmar (COMMIT implícito al finalizar el bloque)
    RAISE NOTICE 'Pedido % creado exitosamente. Total: $%', v_pedido_id, v_total;

EXCEPTION
    WHEN OTHERS THEN
        -- ROLLBACK implícito al salir del bloque con excepción
        RAISE NOTICE 'Error: %. Transacción cancelada.', SQLERRM;
END;
$$;

-- ============================================================
-- Verificación: consultar el estado después de la transacción
-- ============================================================

-- Pedido creado
SELECT * FROM pedidos WHERE id = (SELECT MAX(id) FROM pedidos);

-- Detalle del nuevo pedido
SELECT dp.*, p.nombre AS producto
FROM detalle_pedidos dp
JOIN productos p ON dp.producto_id = p.id
WHERE dp.pedido_id = (SELECT MAX(id) FROM pedidos);

-- Stock actualizado
SELECT p.nombre, s.cantidad
FROM stock s
JOIN productos p ON s.producto_id = p.id
WHERE p.nombre IN ('Laptop Pro', 'Auriculares Bluetooth');
