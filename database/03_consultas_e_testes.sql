-- ==============================================================================
-- Aula 1 - Etapa 5: Consultas e testes de integridade
-- ==============================================================================
USE retrogames;

-- ------------------------------------------------------------------------------
-- 1. Catálogo: jogos ativos com o nome da plataforma e a descrição da condição, ordenados por nome.
-- ------------------------------------------------------------------------------
SELECT 
    j.co_seq_jogo,
    j.no_jogo,
    p.no_plataforma,
    c.ds_condicao_jogo,
    j.vl_preco,
    j.qt_estoque
FROM tb_jogo j
INNER JOIN tb_plataforma p ON j.co_plataforma = p.co_seq_plataforma
INNER JOIN tb_condicao_jogo c ON j.co_condicao_jogo = c.co_condicao_jogo
WHERE j.st_ativo = TRUE
ORDER BY j.no_jogo ASC;

-- ------------------------------------------------------------------------------
-- 2. Gêneros de um jogo informado (exemplo: jogo com id 1 - Super Mario World)
-- ------------------------------------------------------------------------------
SELECT 
    g.co_seq_genero,
    g.no_genero
FROM tb_genero g
INNER JOIN tb_jogo_genero jg ON g.co_seq_genero = jg.co_genero
WHERE jg.co_jogo = 1
ORDER BY g.no_genero ASC;

-- ------------------------------------------------------------------------------
-- 3. Jogos de um gênero informado (exemplo: gênero 3 - RPG)
-- ------------------------------------------------------------------------------
SELECT 
    j.co_seq_jogo,
    j.no_jogo,
    j.vl_preco
FROM tb_jogo j
INNER JOIN tb_jogo_genero jg ON j.co_seq_jogo = jg.co_jogo
WHERE jg.co_genero = 3
ORDER BY j.no_jogo ASC;

-- ------------------------------------------------------------------------------
-- 4. Quantidade de jogos por plataforma, incluindo as plataformas sem jogos.
-- ------------------------------------------------------------------------------
SELECT 
    p.co_seq_plataforma,
    p.no_plataforma,
    COUNT(j.co_seq_jogo) AS total_jogos
FROM tb_plataforma p
LEFT JOIN tb_jogo j ON p.co_seq_plataforma = j.co_plataforma
GROUP BY p.co_seq_plataforma, p.no_plataforma
ORDER BY p.no_plataforma ASC;

-- ------------------------------------------------------------------------------
-- 5. Busca por parte do nome do jogo, com 5 itens por página (exemplo: página 2, LIMIT 5 OFFSET 5)
-- ------------------------------------------------------------------------------
-- Página 1:
SELECT co_seq_jogo, no_jogo, vl_preco 
FROM tb_jogo 
WHERE no_jogo LIKE '%a%' 
ORDER BY no_jogo ASC 
LIMIT 5 OFFSET 0;

-- Página 2:
SELECT co_seq_jogo, no_jogo, vl_preco 
FROM tb_jogo 
WHERE no_jogo LIKE '%a%' 
ORDER BY no_jogo ASC 
LIMIT 5 OFFSET 5;


-- ==============================================================================
-- Testes de Integridade e Resultados Obtidos
-- ==============================================================================

-- Teste 1: Inserir jogo com co_plataforma inexistente
-- Comando executado:
-- INSERT INTO tb_jogo (no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo) 
-- VALUES ('Teste FK Inexistente', 'Desc', 2000, 50.00, 1, TRUE, NOW(), 9999, 1);
-- Resultado observado: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`retrogames`.`tb_jogo`, CONSTRAINT `fk_tb_jogo_plataforma` FOREIGN KEY (`co_plataforma`) REFERENCES `tb_plataforma` (`co_seq_plataforma`))
-- Resultado esperado: Erro 1452 (chave estrangeira) -> Confirmado!

-- Teste 2: Inserir plataforma com nome já cadastrado
-- Comando executado:
-- INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento) 
-- VALUES ('Super Nintendo', 'Outra Empresa', 1991);
-- Resultado observado: ERROR 1062 (23000): Duplicate entry 'Super Nintendo' for key 'tb_plataforma.uk_tb_plataforma_no'
-- Resultado esperado: Erro 1062 (UNIQUE) -> Confirmado!

-- Teste 3: Excluir plataforma que possui jogos
-- Comando executado:
-- DELETE FROM tb_plataforma WHERE co_seq_plataforma = 1;
-- Resultado observado: ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`retrogames`.`tb_jogo`, CONSTRAINT `fk_tb_jogo_plataforma` FOREIGN KEY (`co_plataforma`) REFERENCES `tb_plataforma` (`co_seq_plataforma`))
-- Resultado esperado: Erro 1451 (chave estrangeira) -> Confirmado!

-- Teste 4: Inserir jogo com no_jogo nulo
-- Comando executado:
-- INSERT INTO tb_jogo (no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo) 
-- VALUES (NULL, 'Desc', 2000, 50.00, 1, TRUE, NOW(), 1, 1);
-- Resultado observado: ERROR 1048 (23000): Column 'no_jogo' cannot be null
-- Resultado esperado: Erro 1048 (NOT NULL) -> Confirmado!

-- Teste 5: Inserir jogo com vl_preco igual a 0
-- Comando executado:
-- INSERT INTO tb_jogo (no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo) 
-- VALUES ('Jogo Preço Zero Teste', 'Desc', 2000, 0.00, 1, TRUE, NOW(), 1, 1);
-- Resultado observado: Inserção aceita com sucesso (1 row affected). A regra de negócio RN06 fica no Service.
-- Em seguida, o registro de teste foi removido via:
-- DELETE FROM tb_jogo WHERE no_jogo = 'Jogo Preço Zero Teste';
-- Resultado esperado: Aceito: a regra fica no Service (RN06) -> Confirmado!
