-- ============================================================
-- SCHEMA: E-Commerce - Tablas, PKs, FKs y restricciones
-- ============================================================

-- Eliminar tablas si existen (para reinicio limpio)
DROP TABLE IF EXISTS detalle_pedidos CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS stock CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- ============================================================
-- 1. USUARIOS
-- ============================================================
CREATE TABLE usuarios (
    id          SERIAL       PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol         VARCHAR(20)  NOT NULL DEFAULT 'cliente'
                CHECK (rol IN ('admin', 'cliente')),
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 2. CATEGORÍAS
-- ============================================================
CREATE TABLE categorias (
    id          SERIAL       PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

-- ============================================================
-- 3. PRODUCTOS
-- ============================================================
CREATE TABLE productos (
    id          SERIAL        PRIMARY KEY,
    nombre      VARCHAR(200)  NOT NULL,
    descripcion TEXT,
    precio      DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    categoria_id INTEGER      NOT NULL REFERENCES categorias(id)
                               ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at  TIMESTAMP     NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 4. STOCK
-- ============================================================
CREATE TABLE stock (
    id          SERIAL  PRIMARY KEY,
    producto_id INTEGER NOT NULL UNIQUE REFERENCES productos(id)
                          ON DELETE CASCADE ON UPDATE CASCADE,
    cantidad    INTEGER NOT NULL DEFAULT 0 CHECK (cantidad >= 0)
);

-- ============================================================
-- 5. PEDIDOS
-- ============================================================
CREATE TABLE pedidos (
    id          SERIAL        PRIMARY KEY,
    usuario_id  INTEGER       NOT NULL REFERENCES usuarios(id)
                               ON DELETE RESTRICT ON UPDATE CASCADE,
    fecha_pedido TIMESTAMP    NOT NULL DEFAULT NOW(),
    total       DECIMAL(12,2) NOT NULL DEFAULT 0,
    estado      VARCHAR(20)   NOT NULL DEFAULT 'pendiente'
                CHECK (estado IN ('pendiente', 'completado', 'cancelado'))
);

-- ============================================================
-- 6. DETALLE_PEDIDOS
-- ============================================================
CREATE TABLE detalle_pedidos (
    id              SERIAL        PRIMARY KEY,
    pedido_id       INTEGER       NOT NULL REFERENCES pedidos(id)
                                   ON DELETE CASCADE ON UPDATE CASCADE,
    producto_id     INTEGER       NOT NULL REFERENCES productos(id)
                                   ON DELETE RESTRICT ON UPDATE CASCADE,
    cantidad        INTEGER       NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL
);
