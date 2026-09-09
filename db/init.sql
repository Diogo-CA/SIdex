-- =============================================================
-- SIdex - Esquema do banco de dados (MySQL 8)
-- Gerado a partir das queries em backend/.../repository/*.java
-- Executado automaticamente pelo container do MySQL na 1a subida.
-- =============================================================

CREATE DATABASE IF NOT EXISTS db_projeto
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE db_projeto;

-- -------------------------------------------------------------
-- usuarios
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
    id            BIGINT       NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    senha         VARCHAR(255) NOT NULL,
    data_cadastro DATETIME     NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_usuarios_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- cartas (catalogo local; alimentado sob demanda pela API TCGdex)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cartas (
    id                VARCHAR(60)  NOT NULL,
    nome              VARCHAR(200) NULL,
    numero_na_colecao VARCHAR(30)  NULL,
    colecao           VARCHAR(150) NULL,
    raridade          VARCHAR(100) NULL,
    ilustrador        VARCHAR(150) NULL,
    imagem            VARCHAR(500) NULL,
    PRIMARY KEY (id),
    KEY idx_cartas_nome (nome),
    KEY idx_cartas_colecao (colecao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- binder (pastas/baralhos do usuario)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS binder (
    id         BIGINT       NOT NULL AUTO_INCREMENT,
    nome       VARCHAR(150) NOT NULL,
    usuario_id BIGINT       NOT NULL,
    PRIMARY KEY (id),
    KEY idx_binder_usuario (usuario_id),
    CONSTRAINT fk_binder_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- cartas_colecao (acervo do usuario)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cartas_colecao (
    id              BIGINT      NOT NULL AUTO_INCREMENT,
    carta_id        VARCHAR(60) NOT NULL,
    usuario_id      BIGINT      NOT NULL,
    binder_id       BIGINT      NULL,
    quantidade      INT         NOT NULL DEFAULT 1,
    is_foil         TINYINT(1)  NOT NULL DEFAULT 0,
    condicao        ENUM('M','NM','SP','MP','HP','D') NULL,
    data_adicionada DATETIME    NULL,
    is_favorita     TINYINT(1)  NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_colecao_usuario (usuario_id),
    KEY idx_colecao_binder (binder_id),
    KEY idx_colecao_carta (carta_id),
    CONSTRAINT fk_colecao_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_colecao_carta FOREIGN KEY (carta_id)
        REFERENCES cartas (id) ON DELETE CASCADE,
    CONSTRAINT fk_colecao_binder FOREIGN KEY (binder_id)
        REFERENCES binder (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- wishlists (lista de desejos)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS wishlists (
    id                BIGINT      NOT NULL AUTO_INCREMENT,
    usuario_id        BIGINT      NOT NULL,
    carta_id          VARCHAR(60) NOT NULL,
    is_foil_desejada  TINYINT(1)  NOT NULL DEFAULT 0,
    condicao_desejada ENUM('M','NM','SP','MP','HP','D') NULL,
    PRIMARY KEY (id),
    KEY idx_wishlist_usuario (usuario_id),
    KEY idx_wishlist_carta (carta_id),
    CONSTRAINT fk_wishlist_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_carta FOREIGN KEY (carta_id)
        REFERENCES cartas (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
