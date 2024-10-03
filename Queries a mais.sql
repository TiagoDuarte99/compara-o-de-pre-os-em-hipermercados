-- Para cada Hipermercado Localidade, quantos utilizadores o têm como preferência?
SELECT hl.id, h.nome AS "Hipermercado", 
	l.nome AS "Localidade", 
	hl.morada AS "Morada", 
	COUNT(uh.id_utilizador) AS "Total Utilizadores"
FROM hipermercado_localidade hl
LEFT JOIN utilizador_hipermercado uh ON uh.id_hipermercado_localidade = hl.id
LEFT JOIN hipermercado h ON h.id = hl.id_hipermercado
LEFT JOIN localidade l on l.id = hl.id_localidade
GROUP BY hl.id, h.nome;



-- menor preço de todos os pordutos
SELECT p.descricao AS Produto, MIN(ph.preco) AS menor_preco
FROM utilizador u
INNER JOIN lista_compra lc ON u.id = lc.id_utilizador
INNER JOIN (SELECT DISTINCT id_lista, id_produto 
FROM produto_lista_compra) plc ON lc.id = plc.id_lista
INNER JOIN produto p ON plc.id_produto = p.id
INNER JOIN produto_hipermercado ph ON p.id = ph.id_produto
GROUP BY p.descricao, p.id
order by p.id;




-- Onde posso utilizar os Taloes para a lista de compras X?
SELECT td.id AS "Numero de talão", 
       COALESCE(h1.nome, h.nome) AS "Hipermercado",  
       l.nome AS "Localidade", 
       hl.morada AS "Morada", 
       CONCAT(SUM(d.desconto * 100), '%') AS "Percentagem"
FROM talao_desconto td
INNER JOIN descontos d ON td.id_desconto = d.id
INNER JOIN utilizador u ON td.id_utilizador = u.id
INNER JOIN lista_compra lc ON u.id = lc.id_utilizador
LEFT JOIN hipermercado_localidade hl ON hl.id = d.id_hipermecado_localidade
LEFT JOIN hipermercado h ON h.id = d.id_hipermercado
LEFT JOIN hipermercado h1 ON h1.id = hl.id_hipermercado
LEFT JOIN localidade l ON l.id = hl.id_localidade
WHERE lc.id = 5
  AND d.tipo_desconto = 'Talão'
  AND (d.data_inicio <= CURDATE() AND d.data_fim >= CURDATE())
GROUP BY td.id, hl.id_hipermercado;





-- Obter o preço de determinado produto sem cupão em todos os hipermercados:
SELECT h.nome AS "Hipermercado", 
	l.nome AS "Localidade", 
	hl.morada AS "Morada", 
	p.descricao AS "Produto",
	ph.preco AS "Preço sem descontos"
FROM produto_hipermercado ph
INNER JOIN hipermercado_localidade hl on hl.id = ph.id
INNER join hipermercado h ON h.id = hl.id_hipermercado
INNER JOIN localidade l ON l.id = hl.id_localidade
INNER JOIN produto p ON p.id = ph.id_produto
WHERE ph.id_produto = 1;



-- Obter o preço do produto com talao de um hipermercado específico:
SELECT h.nome AS "Hipermercado", 
	l.nome AS "Localidade", 
	hl.morada AS "Morada", 
	td.id AS "Numero Talao", 
	d.desconto AS "Desconto",
	p.descricao AS "Produto",
	CONCAT(ph.preco,' euros') AS "Sem Talão",  
	CONCAT(ROUND(ph.preco - (ph.preco * d.desconto),2),' euros')  AS "Preço com Talão"
FROM produto_hipermercado ph
INNER JOIN descontos d ON ph.id_hipermercado_localidade = d.id_hipermecado_localidade
INNER JOIN talao_desconto td ON td.id_desconto = d.id
INNER JOIN hipermercado_localidade hl ON hl.id = ph.id_hipermercado_localidade
INNER JOIN hipermercado h ON h.id = hl.id_hipermercado
INNER JOIN localidade l ON l.id = hl.id_localidade
INNER JOIN produto p ON p.id = ph.id_produto
WHERE ph.id_produto = 6
  AND ph.id_hipermercado_localidade = 4
  AND td.id_utilizador = 14;



-- Verificar os produtos de uma determinada lista de compras
SELECT p.descricao AS "Produto" from lista_compra lc
inner join produto_lista_compra plc on plc.id_lista = lc.id
INNER JOIN produto p ON p.id = plc.id_produto
where lc.id = 5
group by plc.id;




-- quantidade de produtos em todas as listas de cada produto para um determinado utilizador
SELECT p.descricao AS "Produto", SUM(plc.quantidade) AS "Quantidade"
FROM utilizador u
INNER JOIN lista_compra lc ON u.id = lc.id_utilizador
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN produto p ON plc.id_produto = p.id
WHERE u.id = 14
GROUP BY u.id, p.id;




-- Vereficar o menor preço de um determinado produto
SELECT MIN(preco) AS menor_preco
FROM produto_hipermercado
WHERE id_produto = 4;




-- Verificar os produtos de um determinado hipermercado tem:
select h.nome AS "Hipermercado", p.descricao from hipermercado h
inner join hipermercado_localidade hl on hl.id_hipermercado = h.id
inner join produto_hipermercado ph on ph.id_hipermercado_localidade = hl.id
inner join produto p on p.id = ph.id_produto
where h.id = 1;




-- Verificar os produtos de um determinado hipermercado Localidade tem:
select h.nome AS "Hipermercado",
	l.nome AS "Localidade",
	hl.morada AS "Morada",
	p.descricao AS "Produto"
	from hipermercado_localidade hl
inner join hipermercado h on hl.id_hipermercado = h.id
inner join produto_hipermercado ph on ph.id_hipermercado_localidade = hl.id
inner join localidade l ON l.id = hl.id_localidade
inner join produto p on p.id = ph.id_produto
where hl.id = 7;





-- Quais são os produtos ou seções que têm, ja tiveram ou vao ter descontos específicos para um determinado cartão de desconto?
SELECT COALESCE(h1.nome, h.nome) AS "Hipermercado",
       l.nome AS "Localidade",
       hl.morada AS "Morada",
       d.desconto AS "Valor Desconto",
       d.data_inicio AS "Data Inicio Desconto",
       d.data_fim AS "Data Fim Desconto",
       d.limite_compras AS "Quantidade de Produtos com o Desconto",
       p.descricao AS "Descrição Produto Com Desconto",
       s.nome AS "Nome Seção Com Desconto"
FROM descontos d
LEFT JOIN hipermercado h ON h.id = d.id_hipermercado
LEFT JOIN hipermercado_localidade hl ON hl.id = d.id_hipermecado_localidade
LEFT JOIN hipermercado h1 ON h1.id = hl.id_hipermercado
LEFT JOIN localidade l ON l.id = hl.id_localidade
LEFT JOIN produto p ON d.id_produto = p.id
LEFT JOIN seccao s ON d.id_seccao = s.id
WHERE d.tipo_desconto = 'Cartao'
  AND (h.id = (SELECT id FROM hipermercado WHERE nome = 'Pingo Doce')
       OR hl.id_hipermercado = (SELECT id FROM hipermercado WHERE nome = 'Pingo Doce'))
ORDER BY d.id;



-- calcular o preço após o desconto de todos os produtos de um hipermercado em especifico
SELECT h.nome AS "Hipermercado",
	   hl.morada AS "Morada",
	   p.descricao AS "Produto",
	   d.desconto AS "Desconto",
	   CONCAT(ph.preco, ' euros') AS "Preço Antes do Desconto",
       CONCAT(ROUND(ph.preco - (ph.preco * d.desconto),2), ' euros') AS "Preço Depois do Desconto"
FROM produto_hipermercado ph
INNER JOIN descontos d ON ph.id_hipermercado_localidade = d.id_hipermecado_localidade
INNER JOIN produto p ON p.id = ph.id_produto
INNER JOIN hipermercado_localidade hl ON hl.id = d.id
INNER JOIN hipermercado h ON h.id = hl.id_hipermercado
WHERE ph.id_hipermercado_localidade = 6 AND d.tipo_desconto = "Geral"
  AND CURDATE() BETWEEN d.data_inicio AND COALESCE(d.data_fim, CURDATE());




-- para verificar se existem taloes para o artigo 6 no hipermercado 4
SELECT COUNT(*) AS count_taloes
FROM talao_desconto td
INNER JOIN descontos d ON d.id = td.id_desconto
WHERE d.id_produto = 6
  AND d.id_hipermecado_localidade = 4;





--  para o hipermercado X quanto vai ficar a lista de compas A
SELECT SUM(ph.preco * plc.quantidade) AS "Total da Lista de Compras"
FROM produto_lista_compra plc
INNER JOIN (
  SELECT DISTINCT id_produto, preco
  FROM produto_hipermercado
  WHERE id_hipermercado_localidade = 6 -- 7 para comparar
) AS ph ON ph.id_produto = plc.id_produto
INNER JOIN lista_compra lc ON lc.id = plc.id_lista
WHERE lc.id = 5;





-- verificar quais os hipermercados que tem o produto X
SELECT h.nome AS "Hipermercado",
	l.nome AS "Localidade",
	hl.morada AS "Morada"
FROM hipermercado h
INNER JOIN hipermercado_localidade hl ON hl.id_hipermercado = h.id
INNER JOIN produto_hipermercado ph ON ph.id_hipermercado_localidade = hl.id
INNER JOIN localidade l ON l.id = hl.id
INNER JOIN produto p ON p.id = ph.id_produto
WHERE p.id = 4;





-- diferença de preço entre o preço mais antigo e o mais recente de cada produto que sofreu alterações no 
-- preço agrupado pelo hipermercado localidade nos ultimos 6 meses
SELECT h.nome AS "Hipermercado",
	   l.nome AS "Localidade",
	   hl.morada AS "Morada",
       p.descricao AS "Produto",
       MAX(prh_recente.preco) - MIN(prh_antigo.preco) AS diferenca_preco
FROM preco_historico prh_recente
inner JOIN preco_historico prh_antigo ON prh_recente.id_produto_hipermercado = prh_antigo.id_produto_hipermercado
inner JOIN produto_hipermercado ph ON prh_recente.id_produto_hipermercado = ph.id
inner join produto p ON p.id = ph.id_produto
inner join hipermercado_localidade hl ON hl.id = ph.id_hipermercado_localidade
inner join hipermercado h ON h.id = hl.id_hipermercado
Inner join localidade l ON l.id = hl.id_localidade
WHERE prh_recente.data_preco >= CURDATE() - INTERVAL 6 MONTH
  AND prh_antigo.data_preco = (
    SELECT MAX(data_preco)
    FROM preco_historico
    WHERE id_produto_hipermercado = prh_antigo.id_produto_hipermercado
      AND data_preco < prh_recente.data_preco
  )
GROUP BY ph.id_hipermercado_localidade, ph.id_produto
order by ph.id_hipermercado_localidade;





-- Quais são os hipermercados que não operam no distrito X? 
 SELECT h.nome
FROM hipermercado h
WHERE h.id NOT IN (
  SELECT hl.id_hipermercado
  FROM hipermercado_localidade hl
  INNER JOIN localidade l ON hl.id_localidade = l.id
  INNER JOIN concelho c ON l.id_concelho = c.id
  INNER JOIN distrito d ON c.id_distrito = d.id
  WHERE d.nome = 'Porto'
);




-- quantidade de produtos de um determinado produto, nas listas de compras de um determinado utilizador
SELECT p.descricao AS "Produto", SUM(plc.quantidade) AS "Quantidade"
FROM utilizador u
INNER JOIN lista_compra lc ON u.id = lc.id_utilizador
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN produto p ON plc.id_produto = p.id
WHERE u.id = 14
GROUP BY u.id, p.id;



-- Quais são os produtos mais caros em cada hipermercado?
SELECT h.nome AS "Hipermercado",
       l.nome AS "Localidade",
       p.descricao AS "Produto",
       ph.preco AS "Preço"
FROM produto_hipermercado ph
INNER JOIN hipermercado_localidade hl ON hl.id = ph.id_hipermercado_localidade
INNER JOIN hipermercado h ON h.id = hl.id_hipermercado
INNER JOIN localidade l ON l.id = hl.id_localidade
INNER JOIN produto p ON p.id = ph.id_produto
WHERE (ph.id_hipermercado_localidade, ph.preco) IN (
  SELECT id_hipermercado_localidade, MAX(preco)
  FROM produto_hipermercado
  GROUP BY id_hipermercado_localidade
)
ORDER BY h.nome, l.nome;




-- Quais os hipermercados preferidos do utilizador que têm todos os artigos de uma lista de compras
SELECT lc.id AS "ID da Lista de Compras", h.nome AS "Hipermercado", uh.id_hipermercado_localidade
FROM lista_compra lc
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN utilizador_hipermercado uh ON lc.id_utilizador = uh.id_utilizador
INNER JOIN hipermercado h ON uh.id_hipermercado_localidade = h.id
INNER JOIN produto p ON plc.id_produto = p.id
LEFT JOIN produto_hipermercado ph ON p.id = ph.id_produto AND ph.id_hipermercado_localidade = h.id
WHERE lc.id = 5 
  AND uh.id_utilizador = 14 
GROUP BY lc.id, h.nome, uh.id_hipermercado_localidade
HAVING COUNT(plc.id_produto) = COUNT(ph.id_produto);



-- Verifica qual o hipermercado preferido do utlizador que tem o preço mais baixo para uma
-- determinado lista de compras
SELECT lc.id AS "ID da Lista de Compras",
       h.nome AS "Hipermercado",
       hl.morada AS "Morada",
       SUM(plc.quantidade * prh.preco) AS "Preço Total"
FROM lista_compra lc
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN utilizador_hipermercado uh ON lc.id_utilizador = uh.id_utilizador
INNER JOIN hipermercado h ON uh.id_hipermercado_localidade = h.id
INNER JOIN produto p ON plc.id_produto = p.id
INNER JOIN hipermercado_localidade hl ON hl.id = uh.id_hipermercado_localidade
LEFT JOIN produto_hipermercado ph ON p.id = ph.id_produto AND ph.id_hipermercado_localidade = h.id
LEFT JOIN preco_historico prh ON ph.id = prh.id_produto_hipermercado
WHERE lc.id = 5 
  AND uh.id_utilizador = 14 
GROUP BY lc.id, h.nome, hl.morada
HAVING COUNT(plc.id_produto) = COUNT(ph.id_produto)
ORDER BY SUM(plc.quantidade * prh.preco);




-- verificar onde o utilizador X pode ter desconto se utilizar o cartao_cliente. Isto e o desconto tem de ser do 
-- tipo_desconto cartao e o utilizador tem de ter o cartao do hipermercado que está no desconto
SELECT h.nome AS "Hipermercado",
       l.nome AS "Localidade",
       hl.morada AS "Morada",
       SUM(ph.preco) AS "Preço Total"
FROM lista_compra lc
INNER JOIN produto_lista_compra plc ON lc.id = plc.id_lista
INNER JOIN produto_hipermercado ph ON plc.id_produto = ph.id_produto
INNER JOIN hipermercado_localidade hl ON hl.id = ph.id_hipermercado_localidade
INNER JOIN hipermercado h ON h.id = hl.id_hipermercado
INNER JOIN localidade l ON l.id = hl.id_localidade
INNER JOIN utilizador_hipermercado uh ON uh.id_hipermercado_localidade = hl.id_hipermercado AND uh.id_utilizador = lc.id_utilizador
WHERE lc.id = 5 -- ID da lista de compras
GROUP BY h.nome, l.nome, hl.morada
ORDER BY "Preço Total" ASC
LIMIT 1;



-- obter os utilizadores que têm um determinado hipermercado_localidade como preferido 
SELECT u.nome AS "Utilizador"
FROM hipermercado_localidade hl
INNER JOIN utilizador_hipermercado uh ON hl.id = uh.id_hipermercado_localidade
INNER JOIN utilizador u ON u.id = uh.id_utilizador
WHERE hl.id = 2;


-- Quais os utilizadores que podem usar um desconto do tipo_desconto cartão
SELECT u.nome AS "Utilizador"
FROM utilizador u
INNER JOIN cartao_cliente cc ON u.id = cc.id_utilizador
INNER JOIN descontos d ON cc.id_hipermercado = d.id_hipermercado
WHERE d.tipo_desconto = 'Cartao';



-- obter os descontos do tipo "cartão" que estão disponíveis 
-- para um determinado hipermercado, como o "Pingo Doce"
SELECT d.id, d.desconto
FROM descontos d
INNER JOIN hipermercado h ON d.id_hipermercado = h.id
WHERE d.tipo_desconto = 'Cartao' AND h.nome = 'Pingo Doce';






