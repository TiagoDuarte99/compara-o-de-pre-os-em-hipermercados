
-- se um valor for alterado na tabela produtos_hipermercado, vai ser adicionada na tabela preco_historico a alteração
DELIMITER //
CREATE TRIGGER tr_preco_historico_insert
AFTER UPDATE ON produto_hipermercado
FOR EACH ROW
BEGIN
  IF NEW.preco <> OLD.preco THEN
    INSERT INTO preco_historico (id_produto_hipermercado, data_preco, preco)
    VALUES (NEW.id, NOW(), NEW.preco);
  END IF;
END //
DELIMITER ;


-- sempre que se colocar um produto na tabela produtos_hipermercado, vai ser adicionada tambem a tabela preco_historico

DELIMITER //

CREATE TRIGGER tr_produto_hipermercado_insert
AFTER INSERT ON produto_hipermercado
FOR EACH ROW
BEGIN
  INSERT INTO preco_historico (id_produto_hipermercado, data_preco, preco)
  VALUES (NEW.id, NOW(), NEW.preco);
END //

DELIMITER ;