-- Script de criação das tabelas da base de dados RetroGames
-- Conforme especificação técnica RetroGames (seções 4.1, 4.2 e 4.3)

CREATE DATABASE IF NOT EXISTS retrogames CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE retrogames;

-- 1. Tabela Domínio: Condição de conservação do jogo (chave fixa, sem auto_increment)
CREATE TABLE IF NOT EXISTS tb_condicao_jogo (
    co_condicao_jogo INT NOT NULL,
    ds_condicao_jogo VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tb_condicao_jogo PRIMARY KEY (co_condicao_jogo),
    CONSTRAINT uk_tb_condicao_jogo_ds UNIQUE (ds_condicao_jogo)
) ENGINE=InnoDB;

-- 2. Tabela Domínio: Perfis de acesso (chave fixa, sem auto_increment)
CREATE TABLE IF NOT EXISTS tb_perfil (
    co_perfil INT NOT NULL,
    ds_perfil VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tb_perfil PRIMARY KEY (co_perfil),
    CONSTRAINT uk_tb_perfil_ds UNIQUE (ds_perfil)
) ENGINE=InnoDB;

-- 3. Tabela Cadastro: Plataformas (console do jogo)
CREATE TABLE IF NOT EXISTS tb_plataforma (
    co_seq_plataforma INT NOT NULL AUTO_INCREMENT,
    no_plataforma VARCHAR(100) NOT NULL,
    no_fabricante VARCHAR(100) NOT NULL,
    nu_ano_lancamento INT NOT NULL,
    CONSTRAINT pk_tb_plataforma PRIMARY KEY (co_seq_plataforma),
    CONSTRAINT uk_tb_plataforma_no UNIQUE (no_plataforma)
) ENGINE=InnoDB;

-- 4. Tabela Cadastro: Gêneros do jogo (somente leitura)
CREATE TABLE IF NOT EXISTS tb_genero (
    co_seq_genero INT NOT NULL AUTO_INCREMENT,
    no_genero VARCHAR(100) NOT NULL,
    CONSTRAINT pk_tb_genero PRIMARY KEY (co_seq_genero),
    CONSTRAINT uk_tb_genero_no UNIQUE (no_genero)
) ENGINE=InnoDB;

-- 5. Tabela Principal: Jogos
CREATE TABLE IF NOT EXISTS tb_jogo (
    co_seq_jogo INT NOT NULL AUTO_INCREMENT,
    no_jogo VARCHAR(150) NOT NULL,
    ds_jogo TEXT NULL,
    nu_ano_lancamento INT NOT NULL,
    vl_preco DECIMAL(10,2) NOT NULL,
    qt_estoque INT NOT NULL,
    st_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    dt_cadastro DATETIME NOT NULL,
    co_plataforma INT NOT NULL,
    co_condicao_jogo INT NOT NULL,
    CONSTRAINT pk_tb_jogo PRIMARY KEY (co_seq_jogo),
    CONSTRAINT fk_tb_jogo_plataforma FOREIGN KEY (co_plataforma) REFERENCES tb_plataforma (co_seq_plataforma),
    CONSTRAINT fk_tb_jogo_condicao FOREIGN KEY (co_condicao_jogo) REFERENCES tb_condicao_jogo (co_condicao_jogo),
    INDEX idx_tb_jogo_nome (no_jogo)
) ENGINE=InnoDB;

-- 6. Tabela Associativa: Jogo e Gênero (relação N:N)
CREATE TABLE IF NOT EXISTS tb_jogo_genero (
    co_jogo INT NOT NULL,
    co_genero INT NOT NULL,
    CONSTRAINT pk_tb_jogo_genero PRIMARY KEY (co_jogo, co_genero),
    CONSTRAINT fk_tb_jogo_genero_jogo FOREIGN KEY (co_jogo) REFERENCES tb_jogo (co_seq_jogo),
    CONSTRAINT fk_tb_jogo_genero_genero FOREIGN KEY (co_genero) REFERENCES tb_genero (co_seq_genero)
) ENGINE=InnoDB;

-- 7. Tabela Cadastro: Usuários do sistema
CREATE TABLE IF NOT EXISTS tb_usuario (
    co_seq_usuario INT NOT NULL AUTO_INCREMENT,
    no_usuario VARCHAR(100) NOT NULL,
    ds_email VARCHAR(150) NOT NULL,
    ds_senha_hash VARCHAR(255) NOT NULL,
    st_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    dt_cadastro DATETIME NOT NULL,
    co_perfil INT NOT NULL,
    CONSTRAINT pk_tb_usuario PRIMARY KEY (co_seq_usuario),
    CONSTRAINT uk_tb_usuario_email UNIQUE (ds_email),
    CONSTRAINT fk_tb_usuario_perfil FOREIGN KEY (co_perfil) REFERENCES tb_perfil (co_perfil)
) ENGINE=InnoDB;
