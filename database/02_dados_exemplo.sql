-- Script de inserção dos dados de exemplo
-- Conforme especificação técnica e Aula 1 - Etapa 4

USE retrogames;

-- 1. Inserir Condições (chaves fixas: 1 Novo, 2 Usado, 3 Recondicionado)
INSERT INTO tb_condicao_jogo (co_condicao_jogo, ds_condicao_jogo) VALUES
(1, 'Novo'),
(2, 'Usado'),
(3, 'Recondicionado')
ON DUPLICATE KEY UPDATE ds_condicao_jogo = VALUES(ds_condicao_jogo);

-- 2. Inserir Perfis (chaves fixas: 1 Administrador, 2 Cliente)
INSERT INTO tb_perfil (co_perfil, ds_perfil) VALUES
(1, 'Administrador'),
(2, 'Cliente')
ON DUPLICATE KEY UPDATE ds_perfil = VALUES(ds_perfil);

-- 3. Inserir pelo menos 6 plataformas
INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento) VALUES
('Super Nintendo', 'Nintendo', 1990),
('Mega Drive', 'Sega', 1988),
('PlayStation 1', 'Sony', 1994),
('Nintendo 64', 'Nintendo', 1996),
('Game Boy', 'Nintendo', 1989),
('Sega Saturn', 'Sega', 1994),
('Neo Geo AES', 'SNK', 1990);

-- 4. Inserir pelo menos 8 gêneros
INSERT INTO tb_genero (no_genero) VALUES
('Ação'),
('Aventura'),
('RPG'),
('Plataforma'),
('Luta'),
('Corrida'),
('Estratégia'),
('Esportes'),
('Shoot em up');

-- 5. Inserir pelo menos 20 jogos (consoles retrô reais, com pelo menos 1 inativo e 1 com estoque zero)
-- dt_cadastro no formato UTC
INSERT INTO tb_jogo (no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo) VALUES
('Super Mario World', 'Aventura clássica do encanador Mario na Terra dos Dinossauros.', 1990, 189.90, 5, TRUE, '2026-01-10 10:00:00', 1, 2),
('Chrono Trigger', 'RPG atemporal que envolve viagens pelo tempo para salvar o planeta.', 1995, 450.00, 2, TRUE, '2026-01-11 11:30:00', 1, 1),
('Sonic the Hedgehog 2', 'Apresenta Miles Tails Prower ao lado do ouriço azul.', 1992, 120.00, 4, TRUE, '2026-01-12 12:00:00', 2, 2),
('Streets of Rage 2', 'Clássico beat em up urbano com trilha marcante de Yuzo Koshiro.', 1992, 220.00, 0, TRUE, '2026-01-13 14:15:00', 2, 2), -- Estoque ZERO
('Castlevania: Symphony of the Night', 'Alucard explora o castelo do Conde Drácula.', 1997, 599.90, 1, TRUE, '2026-01-14 15:00:00', 3, 1),
('Final Fantasy VII', 'Cloud Strife e o grupo Avalanche lutam contra a corporação Shinra.', 1997, 280.00, 3, TRUE, '2026-01-15 16:45:00', 3, 2),
('Metal Gear Solid', 'Solid Snake infiltra a instalação nuclear de Shadow Moses.', 1998, 310.00, 2, TRUE, '2026-01-16 09:20:00', 3, 2),
('The Legend of Zelda: Ocarina of Time', 'Jornada épica de Link pelas eras de Hyrule.', 1998, 350.00, 6, TRUE, '2026-01-17 10:10:00', 4, 3),
('Super Mario 64', 'Marco pioneiro na transição de jogos para cenários tridimensionais.', 1996, 260.00, 3, TRUE, '2026-01-18 11:00:00', 4, 2),
('GoldenEye 007', 'Jogo de tiro em primeira pessoa revolucionário para consoles.', 1997, 190.00, 4, TRUE, '2026-01-19 13:40:00', 4, 2),
('Pokémon Red', 'Comece sua jornada Pokémon em Kanto e torne-se um Mestre.', 1996, 299.90, 3, TRUE, '2026-01-20 14:00:00', 5, 2),
('Tetris', 'O quebra-cabeça que popularizou o console portátil Game Boy.', 1989, 99.00, 8, TRUE, '2026-01-21 15:30:00', 5, 2),
('The Legend of Zelda: Links Awakening', 'Link desperta na misteriosa e isolada Ilha Koholint.', 1993, 240.00, 2, TRUE, '2026-01-22 17:00:00', 5, 3),
('Panzer Dragoon Saga', 'RPG cultuado ambientado em um mundo pós-apocalíptico.', 1998, 899.00, 1, FALSE, '2026-01-23 18:20:00', 6, 2), -- INATIVO (st_ativo = FALSE)
('Nights into Dreams', 'Voe através do mundo dos sonhos para deter Wizeman.', 1996, 210.00, 2, TRUE, '2026-01-24 10:05:00', 6, 2),
('The King of Fighters 98', 'O confronto definitivo dos maiores lutadores da SNK.', 1998, 750.00, 1, TRUE, '2026-01-25 11:50:00', 7, 1),
('Metal Slug X', 'Ação frenética run and gun com armas e veículos icônicos.', 1999, 680.00, 2, TRUE, '2026-01-26 13:10:00', 7, 2),
('Donkey Kong Country', 'Gráficos pré-renderizados impressionantes e jogabilidade refinada.', 1994, 175.00, 5, TRUE, '2026-01-27 14:35:00', 1, 2),
('Street Fighter II Turbo', 'Combates velozes e desafiadores entre guerreiros mundiais.', 1993, 160.00, 4, TRUE, '2026-01-28 16:15:00', 1, 2),
('Resident Evil 2', 'Sobreviva ao caos zumbi em Raccoon City com Leon e Claire.', 1998, 250.00, 3, TRUE, '2026-01-29 17:40:00', 3, 2),
('Crash Bandicoot 3: Warped', 'Viaje pelas eras do tempo detendo o maligno Dr. Neo Cortex.', 1998, 140.00, 4, TRUE, '2026-01-30 08:30:00', 3, 3);

-- 6. Inserir associações Jogo x Gênero (cada jogo com 1 a 3 gêneros)
INSERT INTO tb_jogo_genero (co_jogo, co_genero) VALUES
(1, 4), (1, 2),        -- Super Mario World: Plataforma, Aventura
(2, 3), (2, 2),        -- Chrono Trigger: RPG, Aventura
(3, 4), (3, 1),        -- Sonic 2: Plataforma, Ação
(4, 1),                -- Streets of Rage 2: Ação
(5, 1), (5, 2), (5, 3),-- Castlevania SOTN: Ação, Aventura, RPG
(6, 3),                -- Final Fantasy VII: RPG
(7, 1), (7, 2),        -- Metal Gear Solid: Ação, Aventura
(8, 2), (8, 3),        -- Zelda OoT: Aventura, RPG
(9, 4), (9, 2),        -- Super Mario 64: Plataforma, Aventura
(10, 1),               -- GoldenEye 007: Ação
(11, 3), (11, 2),      -- Pokémon Red: RPG, Aventura
(12, 7),               -- Tetris: Estratégia
(13, 2), (13, 1),      -- Zelda Links Awakening: Aventura, Ação
(14, 3), (14, 2),      -- Panzer Dragoon Saga: RPG, Aventura
(15, 1), (15, 4),      -- Nights into Dreams: Ação, Plataforma
(16, 5),               -- KOF 98: Luta
(17, 1), (17, 9),      -- Metal Slug X: Ação, Shoot em up
(18, 4), (18, 2),      -- Donkey Kong Country: Plataforma, Aventura
(19, 5),               -- Street Fighter II Turbo: Luta
(20, 1), (20, 2),      -- Resident Evil 2: Ação, Aventura
(21, 4), (21, 1);      -- Crash Bandicoot 3: Plataforma, Ação
