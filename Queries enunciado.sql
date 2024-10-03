-- --------------------------------------------- Parte 1 ------------------------------------------------------

-- Quantos utilizadores existem na plataforma?
SELECT COUNT(*) AS "Total Utilizadores" FROM utilizador;


-- Quantos utilizadores existem por distrito?
SELECT d.nome AS "Distrito", COUNT(u.id) AS "Total Utilizadores"
FROM distrito d
LEFT JOIN localidade l ON l.id_distrito = d.id
LEFT JOIN utilizador u ON u.id_localidade = l.id
GROUP BY d.nome;



-- Para cada hipermercado, quantos utilizadores o têm como preferência?
SELECT hl.id_hipermercado, h.nome AS "Hipermercado", COUNT(uh.id_utilizador) AS "Total Utilizadores"
FROM hipermercado_localidade hl
LEFT JOIN utilizador_hipermercado uh ON uh.id_hipermercado_localidade = hl.id
LEFT JOIN hipermercado h ON h.id = hl.id_hipermercado
GROUP BY hl.id_hipermercado, h.nome;





-- Para o utilizador X e a lista de compras A, quais os supermercados deverão 
-- ser visitados e quais produtos devem ser comprados em cada um?
SELECT  p.descricao AS "Produto", 
		hl.id AS "ID", 
		h.nome AS "Hipermercado", 
		l.nome AS "Localidade", 
		hl.morada AS "Morada", 
		ph1.preco AS "Menor Preço" 
		FROM lista_compra lc
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN produto p ON plc.id_produto = p.id
INNER JOIN produto_hipermercado ph1 ON ph1.id_produto = p.id
INNER JOIN (
    SELECT ph.id_produto, MIN(ph.preco) AS preco
    FROM produto_hipermercado ph
    GROUP BY ph.id_produto
) AS ph_min ON p.id = ph_min.id_produto AND ph1.preco = ph_min.preco
INNER JOIN produto_hipermercado ph ON p.id = ph.id_produto AND ph.preco = ph_min.preco
INNER JOIN hipermercado_localidade hl ON ph.id_hipermercado_localidade = hl.id
INNER JOIN localidade l on l.id = hl.id_localidade
INNER JOIN hipermercado h on h.id = hl.id_hipermercado
INNER JOIN utilizador u on u.id = lc.id_utilizador
WHERE lc.id = 5 AND u.id = 14;




-- Qual a quantidade média de produtos que cada utilizador tem por lista?
SELECT u.nome AS "Utilizador", ROUND(AVG(produtos_por_lista), 2) AS "Quantidade Média de Produtos por Lista"
FROM (
    SELECT u.id, COUNT(plc.id_produto) AS produtos_por_lista
    FROM utilizador u
    LEFT JOIN lista_compra lc ON lc.id_utilizador = u.id
    LEFT JOIN produto_lista_compra plc ON plc.id_lista = lc.id
    GROUP BY u.id
) AS subquery
JOIN utilizador u ON u.id = subquery.id
GROUP BY u.nome;



-- ------------------------------------------------------------ PARTE 2 ---------------

 -- Para a lista de compras B qual a evolução do preço nos últimos 3 meses?
SELECT p.descricao AS "Produto",
       h.nome AS "Hipermercado",
       l.nome AS "Localidade",
       hl.morada AS "Morada",
       CONCAT(prh_baixo.preco_baixo, ' euros') AS "Preço Mais Baixo",
       CONCAT(prh_alto.preco_alto, ' euros') AS "Preço Mais Alto",
       CONCAT((prh_alto.preco_alto - prh_baixo.preco_baixo) * CASE WHEN prh_alto.data_alto > prh_baixo.data_baixo THEN 1 ELSE -1 END, ' euros') AS "Diferença de Preço"
FROM lista_compra lc
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN produto p ON plc.id_produto = p.id
INNER JOIN produto_hipermercado ph ON p.id = ph.id_produto
INNER JOIN hipermercado_localidade hl ON hl.id = ph.id_hipermercado_localidade
INNER JOIN hipermercado h ON h.id = hl.id_hipermercado
INNER JOIN localidade l ON l.id = hl.id_localidade
INNER JOIN (
    SELECT prh.id_produto_hipermercado, prh.preco AS preco_baixo, prh.data_preco AS data_baixo
    FROM preco_historico prh
    INNER JOIN (
        SELECT id_produto_hipermercado, MIN(preco) AS baixo_preco
        FROM preco_historico
        WHERE data_preco >= CURDATE() - INTERVAL 3 MONTH
        GROUP BY id_produto_hipermercado
    ) prh_baixo ON prh.id_produto_hipermercado = prh_baixo.id_produto_hipermercado AND prh.preco = prh_baixo.baixo_preco
) prh_baixo ON ph.id = prh_baixo.id_produto_hipermercado
INNER JOIN (
    SELECT prh.id_produto_hipermercado, prh.preco AS preco_alto, prh.data_preco AS data_alto
    FROM preco_historico prh
    INNER JOIN (
        SELECT id_produto_hipermercado, MAX(preco) AS max_preco
        FROM preco_historico
        WHERE data_preco >= CURDATE() - INTERVAL 3 MONTH
        GROUP BY id_produto_hipermercado
    ) prh_max ON prh.id_produto_hipermercado = prh_max.id_produto_hipermercado AND prh.preco = prh_max.max_preco
    WHERE prh.data_preco >= CURDATE() - INTERVAL 3 MONTH
) prh_alto ON ph.id = prh_alto.id_produto_hipermercado
WHERE lc.id = 5
GROUP BY p.descricao, h.nome, l.nome, hl.morada, prh_baixo.preco_baixo, prh_alto.preco_alto, prh_baixo.data_baixo, prh_alto.data_alto;


-- Em média, qual a percentagem de evolução do preço de todos os produtos de charcutaria no último ano?
SELECT CONCAT(ROUND(AVG(percentagem_evolucao),2),' %') AS "Precentagem de aumento preço "
FROM (
  SELECT ((prh_recente.preco - prh_antigo.preco) / prh_antigo.preco) * 100 AS percentagem_evolucao
  FROM preco_historico prh_recente
  JOIN preco_historico prh_antigo ON prh_recente.id_produto_hipermercado = prh_antigo.id_produto_hipermercado
  JOIN produto_hipermercado ph ON prh_recente.id_produto_hipermercado = ph.id
  JOIN produto p ON ph.id_produto = p.id
  JOIN seccao s ON p.id_seccao = s.id
  WHERE s.nome = 'charcutaria'
    AND prh_recente.data_preco >= CURDATE() - INTERVAL 1 YEAR
    AND prh_recente.data_preco = (
      SELECT MAX(data_preco)
      FROM preco_historico
      WHERE id_produto_hipermercado = prh_recente.id_produto_hipermercado
    )
    AND prh_antigo.data_preco = (
      SELECT MAX(data_preco)
      FROM preco_historico
      WHERE id_produto_hipermercado = prh_antigo.id_produto_hipermercado
        AND data_preco < prh_recente.data_preco
    )
) AS subquery;


-- Qual o hipermercado em que os preços mais subiram nos últimos 6 meses?

SELECT subquery.id_hipermercado_localidade "ID Hipermercado Localidade", (total_aumento - total_diminuicao) AS "Diferença de Preços nos ultimos 6 Meses"
FROM (
  SELECT ph.id_hipermercado_localidade, 
         SUM(CASE WHEN prh_recente.preco > prh_antigo.preco THEN (prh_recente.preco - prh_antigo.preco) ELSE 0 END) AS total_aumento,
         SUM(CASE WHEN prh_recente.preco < prh_antigo.preco THEN (prh_antigo.preco - prh_recente.preco) ELSE 0 END) AS total_diminuicao
  FROM preco_historico prh_recente
  JOIN preco_historico prh_antigo ON prh_recente.id_produto_hipermercado = prh_antigo.id_produto_hipermercado
  JOIN produto_hipermercado ph ON prh_recente.id_produto_hipermercado = ph.id
  WHERE prh_recente.data_preco >= CURDATE() - INTERVAL 6 MONTH
    AND prh_antigo.data_preco = (
      SELECT MAX(data_preco)
      FROM preco_historico
      WHERE id_produto_hipermercado = prh_antigo.id_produto_hipermercado
        AND data_preco < prh_recente.data_preco
    )
  GROUP BY ph.id_hipermercado_localidade
) AS subquery
order by (total_aumento - total_diminuicao) desc; limit 1;






--     --------- PARTE 3 -----------------



-- Existem cupões para aplicar numa certa lista de compras?
SELECT td.id AS "Numero de talão"
FROM talao_desconto td
INNER JOIN descontos d ON td.id_desconto = d.id
INNER JOIN utilizador u ON td.id_utilizador = u.id
INNER JOIN lista_compra lc ON u.id = lc.id_utilizador
WHERE lc.id = 5
  AND d.tipo_desconto = 'Talão'
  AND (d.data_inicio <= CURDATE() AND d.data_fim >= CURDATE())
GROUP BY td.id;




-- Dado um produto, o preço após cupão num hipermercado torna-o o local mais barato para o comprar?
SELECT h1.nome AS "Hipermercado com Cupão",
       l1.nome AS "Localidade com Cupão",
       hl1.morada AS "Morada com Cupão",
       td.id AS "Numero Talao",
       d.desconto AS "Desconto",
       CONCAT(ROUND(ph1.preco - (ph1.preco * d.desconto), 2), ' euros') AS "Preço com cupao",
       h2.nome AS "Hipermercado sem Cupão",
       l2.nome AS "Localidade sem Cupão",
       hl2.morada AS "Morada sem Cupão",
       CONCAT(ph2.preco, ' euros') AS "Preço sem Cupão"
FROM produto_hipermercado ph1
INNER JOIN descontos d ON ph1.id_hipermercado_localidade = d.id_hipermecado_localidade
INNER JOIN talao_desconto td ON td.id_desconto = d.id
INNER JOIN hipermercado_localidade hl1 ON hl1.id = ph1.id_hipermercado_localidade
INNER JOIN hipermercado h1 ON h1.id = hl1.id_hipermercado
INNER JOIN localidade l1 ON l1.id = hl1.id_localidade
LEFT JOIN produto_hipermercado ph2 ON ph1.id_produto = ph2.id_produto
INNER JOIN hipermercado_localidade hl2 ON hl2.id = ph2.id_hipermercado_localidade
INNER JOIN hipermercado h2 ON h2.id = hl2.id_hipermercado
INNER JOIN localidade l2 ON l2.id = hl2.id_localidade
WHERE ph1.id_produto = 6
  AND ph1.id_hipermercado_localidade = 4
  AND ph2.preco < ph1.preco
ORDER BY ph2.preco ASC
LIMIT 1;




