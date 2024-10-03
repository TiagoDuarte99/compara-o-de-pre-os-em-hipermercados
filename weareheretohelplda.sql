/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE `cartao_cliente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_utilizador` int NOT NULL,
  `id_hipermercado` int NOT NULL,
  `data_validade` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_utilizador` (`id_utilizador`,`id_hipermercado`),
  KEY `id_hipermercado` (`id_hipermercado`),
  CONSTRAINT `cartao_cliente_ibfk_1` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizador` (`id`),
  CONSTRAINT `cartao_cliente_ibfk_2` FOREIGN KEY (`id_hipermercado`) REFERENCES `hipermercado` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `concelho` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(64) NOT NULL,
  `id_distrito` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_concelho_distrito` (`id_distrito`),
  CONSTRAINT `fk_concelho_distrito` FOREIGN KEY (`id_distrito`) REFERENCES `distrito` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `descontos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_produto` int DEFAULT NULL,
  `id_seccao` int DEFAULT NULL,
  `id_hipermercado` int DEFAULT NULL,
  `id_hipermecado_localidade` int DEFAULT NULL,
  `tipo_desconto` enum('Geral','Cartao','Talao') NOT NULL,
  `desconto` decimal(5,2) NOT NULL,
  `data_inicio` date NOT NULL,
  `data_fim` date DEFAULT NULL,
  `limite_compras` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_produto` (`id_produto`),
  KEY `id_seccao` (`id_seccao`),
  KEY `id_hipermercado` (`id_hipermercado`),
  KEY `id_hipermecado_localidade` (`id_hipermecado_localidade`),
  CONSTRAINT `descontos_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id`),
  CONSTRAINT `descontos_ibfk_2` FOREIGN KEY (`id_seccao`) REFERENCES `seccao` (`id`),
  CONSTRAINT `descontos_ibfk_3` FOREIGN KEY (`id_hipermercado`) REFERENCES `hipermercado` (`id`),
  CONSTRAINT `descontos_ibfk_4` FOREIGN KEY (`id_hipermecado_localidade`) REFERENCES `hipermercado_localidade` (`id`),
  CONSTRAINT `descontos_chk_1` CHECK (((`id_hipermercado` is not null) or (`id_hipermecado_localidade` is not null))),
  CONSTRAINT `descontos_chk_2` CHECK (((`data_fim` is not null) or (`limite_compras` is not null)))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `distrito` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `hipermercado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `hipermercado_localidade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_hipermercado` int NOT NULL,
  `id_localidade` int NOT NULL,
  `morada` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_hipermercado` (`id_hipermercado`),
  KEY `id_localidade` (`id_localidade`),
  CONSTRAINT `hipermercado_localidade_ibfk_1` FOREIGN KEY (`id_hipermercado`) REFERENCES `hipermercado` (`id`),
  CONSTRAINT `hipermercado_localidade_ibfk_2` FOREIGN KEY (`id_localidade`) REFERENCES `localidade` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `lista_compra` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `id_utilizador` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_utilizador` (`id_utilizador`),
  CONSTRAINT `lista_compra_ibfk_1` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizador` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `localidade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(256) NOT NULL,
  `id_distrito` int NOT NULL,
  `id_concelho` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_localidade_distrito` (`id_distrito`),
  KEY `fk_localidade_concelho` (`id_concelho`),
  CONSTRAINT `fk_localidade_concelho` FOREIGN KEY (`id_concelho`) REFERENCES `concelho` (`id`),
  CONSTRAINT `fk_localidade_distrito` FOREIGN KEY (`id_distrito`) REFERENCES `distrito` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `marca` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `preco_historico` (
  `id_produto_hipermercado` int NOT NULL,
  `data_preco` datetime NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_produto_hipermercado`,`data_preco`),
  CONSTRAINT `preco_historico_ibfk_1` FOREIGN KEY (`id_produto_hipermercado`) REFERENCES `produto_hipermercado` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `produto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_seccao` int NOT NULL,
  `id_marca` int NOT NULL,
  `descricao` varchar(256) NOT NULL,
  `id_unidade_medida` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_seccao` (`id_seccao`,`descricao`),
  KEY `id_marca` (`id_marca`),
  KEY `id_unidade_medida` (`id_unidade_medida`),
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_seccao`) REFERENCES `seccao` (`id`),
  CONSTRAINT `produto_ibfk_2` FOREIGN KEY (`id_marca`) REFERENCES `marca` (`id`),
  CONSTRAINT `produto_ibfk_3` FOREIGN KEY (`id_unidade_medida`) REFERENCES `unidade_medida` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `produto_hipermercado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `id_hipermercado_localidade` int NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `preco` decimal(10,2) NOT NULL,
  `data_inserido` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_produto` (`id_produto`),
  KEY `id_hipermercado_localidade` (`id_hipermercado_localidade`),
  CONSTRAINT `produto_hipermercado_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id`),
  CONSTRAINT `produto_hipermercado_ibfk_2` FOREIGN KEY (`id_hipermercado_localidade`) REFERENCES `hipermercado_localidade` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `produto_lista_compra` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lista` int NOT NULL,
  `id_produto` int NOT NULL,
  `quantidade` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_lista` (`id_lista`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `produto_lista_compra_ibfk_1` FOREIGN KEY (`id_lista`) REFERENCES `lista_compra` (`id`),
  CONSTRAINT `produto_lista_compra_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `seccao` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `talao_desconto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_utilizador` int NOT NULL,
  `id_desconto` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_utilizador` (`id_utilizador`),
  KEY `id_desconto` (`id_desconto`),
  CONSTRAINT `talao_desconto_ibfk_1` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizador` (`id`),
  CONSTRAINT `talao_desconto_ibfk_2` FOREIGN KEY (`id_desconto`) REFERENCES `descontos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `unidade_medida` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `utilizador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `telefone` varchar(9) NOT NULL,
  `morada` varchar(200) NOT NULL,
  `id_localidade` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `telefone` (`telefone`),
  KEY `id_localidade` (`id_localidade`),
  CONSTRAINT `utilizador_ibfk_1` FOREIGN KEY (`id_localidade`) REFERENCES `localidade` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `utilizador_hipermercado` (
  `id_utilizador` int NOT NULL,
  `id_hipermercado_localidade` int NOT NULL,
  PRIMARY KEY (`id_utilizador`,`id_hipermercado_localidade`),
  KEY `id_hipermercado_localidade` (`id_hipermercado_localidade`),
  CONSTRAINT `utilizador_hipermercado_ibfk_1` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizador` (`id`),
  CONSTRAINT `utilizador_hipermercado_ibfk_2` FOREIGN KEY (`id_hipermercado_localidade`) REFERENCES `hipermercado_localidade` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `cartao_cliente` (`id`, `id_utilizador`, `id_hipermercado`, `data_validade`) VALUES
(1, 5, 1, '2023-06-22');
INSERT INTO `cartao_cliente` (`id`, `id_utilizador`, `id_hipermercado`, `data_validade`) VALUES
(2, 5, 2, '2023-07-15');
INSERT INTO `cartao_cliente` (`id`, `id_utilizador`, `id_hipermercado`, `data_validade`) VALUES
(3, 6, 3, '2023-08-03');
INSERT INTO `cartao_cliente` (`id`, `id_utilizador`, `id_hipermercado`, `data_validade`) VALUES
(4, 6, 4, '2023-09-18'),
(5, 7, 5, '2023-10-05'),
(6, 7, 6, '2023-11-22'),
(7, 8, 7, '2023-12-08'),
(8, 8, 8, '2024-01-14'),
(9, 9, 1, '2024-02-29'),
(10, 9, 2, '2024-03-15'),
(11, 10, 3, '2024-04-01'),
(12, 10, 4, '2024-05-16'),
(13, 57, 5, '2025-03-09'),
(14, 57, 6, '2025-04-25'),
(15, 11, 1, '2023-06-22'),
(16, 11, 2, '2023-07-15'),
(17, 12, 3, '2023-08-03'),
(18, 12, 4, '2023-09-18'),
(19, 13, 5, '2023-10-05'),
(20, 13, 6, '2023-11-22'),
(21, 14, 7, '2023-12-08'),
(22, 14, 8, '2024-01-14'),
(23, 15, 1, '2024-02-29'),
(24, 15, 2, '2024-03-15'),
(25, 16, 3, '2024-04-01'),
(26, 16, 4, '2024-05-16'),
(27, 17, 5, '2024-06-02'),
(28, 17, 6, '2024-07-18'),
(29, 18, 7, '2024-08-04'),
(30, 18, 8, '2024-09-20'),
(31, 19, 1, '2024-10-07'),
(32, 19, 2, '2024-11-22'),
(33, 20, 3, '2024-12-09'),
(34, 20, 4, '2025-01-15'),
(35, 21, 5, '2025-02-28'),
(36, 21, 6, '2025-03-16'),
(37, 22, 7, '2025-04-02'),
(38, 22, 8, '2025-05-17'),
(39, 23, 1, '2025-06-03'),
(40, 23, 2, '2025-07-19'),
(41, 24, 3, '2025-08-05'),
(42, 24, 4, '2025-09-21'),
(43, 25, 5, '2025-10-08'),
(44, 25, 6, '2025-11-23'),
(45, 26, 7, '2025-12-10'),
(46, 26, 8, '2026-01-16'),
(47, 27, 1, '2026-02-28'),
(48, 27, 2, '2026-03-17'),
(49, 28, 3, '2026-04-03'),
(50, 28, 4, '2026-05-19'),
(51, 29, 5, '2026-06-05'),
(52, 29, 6, '2026-07-21'),
(53, 30, 7, '2026-08-07'),
(54, 30, 8, '2026-09-23');

INSERT INTO `concelho` (`id`, `nome`, `id_distrito`) VALUES
(1, 'Amares', 3);
INSERT INTO `concelho` (`id`, `nome`, `id_distrito`) VALUES
(2, 'Barcelos', 3);
INSERT INTO `concelho` (`id`, `nome`, `id_distrito`) VALUES
(3, 'Braga', 3);
INSERT INTO `concelho` (`id`, `nome`, `id_distrito`) VALUES
(4, 'Cabeceiras de Basto', 3),
(5, 'Celorico de Basto', 3),
(6, 'Esposende', 3),
(7, 'Fafe', 3),
(8, 'Guimarães', 3),
(9, 'Póvoa de Lanhoso', 3),
(10, 'Terras de Bouro', 3),
(11, 'Vieira do Minho', 3),
(12, 'Vila Nova de Famalicão', 3),
(13, 'Vila Verde', 3),
(14, 'Vizela', 3),
(15, 'Amarante', 13),
(16, 'Baião', 13),
(17, 'Felgueiras', 13),
(18, 'Gondomar', 13),
(19, 'Lousada', 13),
(20, 'Maia', 13),
(21, 'Marco de Canaveses', 13),
(22, 'Matosinhos', 13),
(23, 'Paços de Ferreira', 13),
(24, 'Paredes', 13),
(25, 'Penafiel', 13),
(26, 'Porto', 13),
(27, 'Póvoa de Varzim', 13),
(28, 'Santo Tirso', 13),
(29, 'Trofa', 13),
(30, 'Valongo', 13),
(31, 'Vila do Conde', 13),
(32, 'Vila Nova de Gaia', 13);

INSERT INTO `descontos` (`id`, `id_produto`, `id_seccao`, `id_hipermercado`, `id_hipermecado_localidade`, `tipo_desconto`, `desconto`, `data_inicio`, `data_fim`, `limite_compras`) VALUES
(1, 1, NULL, 1, NULL, 'Cartao', 0.10, '2023-01-01', NULL, 100);
INSERT INTO `descontos` (`id`, `id_produto`, `id_seccao`, `id_hipermercado`, `id_hipermecado_localidade`, `tipo_desconto`, `desconto`, `data_inicio`, `data_fim`, `limite_compras`) VALUES
(2, NULL, 1, 2, NULL, 'Cartao', 0.15, '2023-02-01', '2023-02-28', NULL);
INSERT INTO `descontos` (`id`, `id_produto`, `id_seccao`, `id_hipermercado`, `id_hipermecado_localidade`, `tipo_desconto`, `desconto`, `data_inicio`, `data_fim`, `limite_compras`) VALUES
(3, NULL, NULL, 5, NULL, 'Talao', 0.20, '2023-06-01', '2023-06-30', NULL);
INSERT INTO `descontos` (`id`, `id_produto`, `id_seccao`, `id_hipermercado`, `id_hipermecado_localidade`, `tipo_desconto`, `desconto`, `data_inicio`, `data_fim`, `limite_compras`) VALUES
(4, 3, NULL, 7, NULL, 'Geral', 0.12, '2023-04-01', NULL, 80),
(5, NULL, 2, NULL, 1, 'Cartao', 0.18, '2023-05-01', '2023-05-31', NULL),
(6, 4, NULL, NULL, 28, 'Talao', 0.25, '2023-06-01', '2023-06-30', NULL),
(7, 5, NULL, NULL, 34, 'Geral', 0.15, '2023-07-01', NULL, 90),
(8, 6, NULL, NULL, 56, 'Cartao', 0.20, '2023-06-01', '2023-07-31', NULL),
(9, 6, NULL, NULL, 4, 'Talao', 0.30, '2023-06-01', '2023-09-30', NULL),
(10, 7, NULL, NULL, 32, 'Geral', 0.18, '2023-10-01', '2023-10-31', NULL),
(11, NULL, 2, NULL, 12, 'Cartao', 0.25, '2023-11-01', '2023-11-30', NULL),
(12, 8, NULL, NULL, 104, 'Talao', 0.35, '2023-12-01', '2023-12-31', NULL),
(13, NULL, NULL, NULL, 6, 'Geral', 0.20, '2023-06-11', NULL, 70),
(14, NULL, NULL, NULL, 70, 'Cartao', 0.30, '2024-02-01', '2024-02-29', NULL),
(15, 10, NULL, 6, NULL, 'Talao', 0.40, '2024-03-01', '2024-03-31', NULL),
(16, 11, NULL, 4, NULL, 'Geral', 0.15, '2024-06-24', NULL, 50);

INSERT INTO `distrito` (`id`, `nome`) VALUES
(1, 'Aveiro');
INSERT INTO `distrito` (`id`, `nome`) VALUES
(2, 'Beja');
INSERT INTO `distrito` (`id`, `nome`) VALUES
(3, 'Braga');
INSERT INTO `distrito` (`id`, `nome`) VALUES
(4, 'Bragança'),
(5, 'Castelo Branco'),
(6, 'Coimbra'),
(7, 'Évora'),
(8, 'Faro'),
(9, 'Guarda'),
(10, 'Leiria'),
(11, 'Lisboa'),
(12, 'Portalegre'),
(13, 'Porto'),
(14, 'Santarém'),
(15, 'Setúbal'),
(16, 'Viana do Castelo'),
(17, 'Vila Real'),
(18, 'Viseu');

INSERT INTO `hipermercado` (`id`, `nome`) VALUES
(1, 'Pingo Doce');
INSERT INTO `hipermercado` (`id`, `nome`) VALUES
(2, 'Continente');
INSERT INTO `hipermercado` (`id`, `nome`) VALUES
(3, 'Lidl');
INSERT INTO `hipermercado` (`id`, `nome`) VALUES
(4, 'Aldi'),
(5, 'Auchan'),
(6, 'Minipreço'),
(7, 'Mercadona'),
(8, 'Intermarché');

INSERT INTO `hipermercado_localidade` (`id`, `id_hipermercado`, `id_localidade`, `morada`) VALUES
(1, 1, 1, 'Rua A');
INSERT INTO `hipermercado_localidade` (`id`, `id_hipermercado`, `id_localidade`, `morada`) VALUES
(2, 1, 3, 'Rua B');
INSERT INTO `hipermercado_localidade` (`id`, `id_hipermercado`, `id_localidade`, `morada`) VALUES
(3, 2, 5, 'Rua C');
INSERT INTO `hipermercado_localidade` (`id`, `id_hipermercado`, `id_localidade`, `morada`) VALUES
(4, 3, 7, 'Rua D'),
(5, 4, 9, 'Rua E'),
(6, 5, 11, 'Rua F'),
(7, 6, 13, 'Rua G'),
(8, 7, 15, 'Rua H'),
(9, 8, 17, 'Rua I'),
(10, 1, 19, 'Rua J'),
(11, 2, 21, 'Rua K'),
(12, 3, 23, 'Rua L'),
(13, 4, 25, 'Rua M'),
(14, 5, 27, 'Rua N'),
(15, 6, 29, 'Rua O'),
(16, 7, 31, 'Rua P'),
(17, 8, 33, 'Rua Q'),
(18, 1, 35, 'Rua R'),
(19, 2, 37, 'Rua S'),
(20, 3, 2, 'Rua T'),
(21, 4, 4, 'Rua U'),
(22, 5, 6, 'Rua V'),
(23, 6, 8, 'Rua X'),
(24, 7, 10, 'Rua Y'),
(25, 8, 12, 'Rua Z'),
(26, 1, 14, 'Rua AA'),
(27, 2, 16, 'Rua BB'),
(28, 3, 18, 'Rua CC'),
(29, 4, 20, 'Rua DD'),
(30, 5, 22, 'Rua EE'),
(31, 6, 24, 'Rua FF'),
(32, 7, 26, 'Rua GG'),
(33, 8, 28, 'Rua HH'),
(34, 1, 30, 'Rua II'),
(35, 2, 32, 'Rua JJ'),
(36, 3, 34, 'Rua KK'),
(37, 4, 36, 'Rua LL'),
(38, 5, 1, 'Rua MM'),
(39, 6, 3, 'Rua NN'),
(40, 7, 5, 'Rua OO'),
(41, 8, 7, 'Rua PP'),
(42, 1, 9, 'Rua QQ'),
(43, 2, 11, 'Rua RR'),
(44, 3, 13, 'Rua SS'),
(45, 4, 15, 'Rua TT'),
(46, 5, 17, 'Rua UU'),
(47, 6, 19, 'Rua VV'),
(48, 7, 21, 'Rua WW'),
(49, 8, 23, 'Rua XX'),
(50, 1, 25, 'Rua YY'),
(51, 2, 27, 'Rua ZZ'),
(52, 3, 30, 'Rua A'),
(53, 4, 32, 'Rua B'),
(54, 5, 34, 'Rua C'),
(55, 6, 36, 'Rua D'),
(56, 7, 1, 'Rua E'),
(57, 8, 3, 'Rua F'),
(58, 1, 5, 'Rua G'),
(59, 2, 7, 'Rua H'),
(60, 3, 9, 'Rua I'),
(61, 4, 11, 'Rua J'),
(62, 5, 13, 'Rua K'),
(63, 6, 15, 'Rua L'),
(64, 7, 17, 'Rua M'),
(65, 8, 19, 'Rua N'),
(66, 1, 21, 'Rua O'),
(67, 2, 23, 'Rua P'),
(68, 3, 25, 'Rua Q'),
(69, 4, 27, 'Rua R'),
(70, 5, 29, 'Rua S'),
(71, 6, 31, 'Rua T'),
(72, 7, 33, 'Rua U'),
(73, 8, 35, 'Rua V'),
(74, 1, 37, 'Rua W'),
(75, 2, 2, 'Rua X'),
(76, 3, 4, 'Rua Y'),
(77, 4, 6, 'Rua Z'),
(78, 5, 8, 'Rua AA'),
(79, 6, 10, 'Rua BB'),
(80, 7, 12, 'Rua CC'),
(81, 8, 14, 'Rua DD'),
(82, 1, 16, 'Rua EE'),
(83, 2, 18, 'Rua FF'),
(84, 3, 20, 'Rua GG'),
(85, 4, 22, 'Rua HH'),
(86, 5, 24, 'Rua II'),
(87, 6, 26, 'Rua JJ'),
(88, 7, 28, 'Rua KK'),
(89, 8, 30, 'Rua LL'),
(90, 1, 32, 'Rua MM'),
(91, 2, 34, 'Rua NN'),
(92, 3, 36, 'Rua OO'),
(93, 4, 1, 'Rua PP'),
(94, 5, 3, 'Rua QQ'),
(95, 6, 5, 'Rua RR'),
(96, 7, 7, 'Rua SS'),
(97, 8, 9, 'Rua TT'),
(98, 1, 11, 'Rua UU'),
(99, 2, 13, 'Rua VV'),
(100, 3, 15, 'Rua WW'),
(101, 4, 17, 'Rua XX'),
(102, 5, 19, 'Rua YY'),
(103, 6, 21, 'Rua ZZ'),
(104, 7, 23, 'Rua AAA'),
(105, 8, 25, 'Rua BBB'),
(106, 1, 27, 'Rua CCC'),
(107, 2, 29, 'Rua DDD'),
(108, 1, 44, 'Rua ABC'),
(109, 2, 44, 'Rua BCA');

INSERT INTO `lista_compra` (`id`, `nome`, `id_utilizador`) VALUES
(1, 'Lista de Compras 10', 10);
INSERT INTO `lista_compra` (`id`, `nome`, `id_utilizador`) VALUES
(2, 'Lista de Compras 11', 11);
INSERT INTO `lista_compra` (`id`, `nome`, `id_utilizador`) VALUES
(3, 'Lista de Compras 12', 12);
INSERT INTO `lista_compra` (`id`, `nome`, `id_utilizador`) VALUES
(4, 'Lista de Compras 13', 13),
(5, 'Lista de Compras 14', 14),
(6, 'Lista de Compras 15', 15),
(7, 'Lista de Compras 16', 14),
(8, 'Lista de Compras 17', 17),
(9, 'Lista de Compras 18', 18),
(10, 'Lista de Compras 19', 19),
(11, 'Lista de Compras 20', 20),
(12, 'Lista de Compras 21', 1),
(13, 'Lista de Compras 22', 1),
(14, 'Lista de Compras 23', 2),
(15, 'Lista de Compras 24', 14),
(16, 'Lista de Compras 25', 3),
(17, 'Lista de Compras 26', 3),
(18, 'Lista de Compras 27', 4),
(19, 'Lista de Compras 28', 4),
(20, 'Lista de Compras 29', 5),
(21, 'Lista de Compras 30', 5),
(22, 'Lista de Compras 31', 6),
(23, 'Lista de Compras 32', 6),
(24, 'Lista de Compras 33', 7),
(25, 'Lista de Compras 34', 7),
(26, 'Lista de Compras 35', 8),
(27, 'Lista de Compras 36', 8),
(28, 'Lista de Compras 37', 9),
(29, 'Lista de Compras 38', 9),
(30, 'Lista de Compras 39', 10),
(31, 'Lista de Compras 40', 10);

INSERT INTO `localidade` (`id`, `nome`, `id_distrito`, `id_concelho`) VALUES
(1, 'Adaúfe', 3, 3);
INSERT INTO `localidade` (`id`, `nome`, `id_distrito`, `id_concelho`) VALUES
(2, 'Arcos', 3, 3);
INSERT INTO `localidade` (`id`, `nome`, `id_distrito`, `id_concelho`) VALUES
(3, 'Cabreiros', 3, 3);
INSERT INTO `localidade` (`id`, `nome`, `id_distrito`, `id_concelho`) VALUES
(4, 'Crespos', 3, 3),
(5, 'Espinho', 3, 3),
(6, 'Esporões', 3, 3),
(7, 'Figueiredo', 3, 3),
(8, 'Fonte Arcada', 3, 3),
(9, 'Fraião', 3, 3),
(10, 'Frossos', 3, 3),
(11, 'Gondizalves', 3, 3),
(12, 'Lamas', 3, 3),
(13, 'Lomar', 3, 3),
(14, 'Merelim (São Pedro)', 3, 3),
(15, 'Merelim (São Paio)', 3, 3),
(16, 'Morreira', 3, 3),
(17, 'Nogueira', 3, 3),
(18, 'Padim da Graça', 3, 3),
(19, 'Palmeira', 3, 3),
(20, 'Real', 3, 3),
(21, 'Vila Verde', 3, 13),
(22, 'Prado (São Miguel)', 3, 13),
(23, 'Vila de Prado', 3, 13),
(24, 'Prado (São Miguel e São João)', 3, 13),
(25, 'Prado (São Miguel e Santa Maria)', 3, 13),
(26, 'Vade (São Tomé)', 3, 13),
(27, 'Vade (São Tomé e Covelas)', 3, 13),
(28, 'Duas Igrejas', 3, 13),
(29, 'Corujeira', 3, 13),
(30, 'Coucieiro', 3, 13),
(31, 'Guimarães', 3, 8),
(32, 'Azurém', 3, 8),
(33, 'São Paio', 3, 8),
(34, 'Creixomil', 3, 8),
(35, 'Mesão Frio', 3, 8),
(36, 'Candoso (São Martinho)', 3, 8),
(37, 'Brito', 3, 8),
(38, 'Urgezes', 3, 8),
(39, 'Pevidém', 3, 8),
(40, 'Selho (São Lourenço)', 3, 8),
(41, 'Selho (São Jorge)', 3, 8),
(42, 'Souto (Santa Maria)', 3, 8),
(43, 'Souto (São Salvador)', 3, 8),
(44, 'Aldoar', 13, 26),
(45, 'Bonfim', 13, 26),
(46, 'Campanhã', 13, 26),
(47, 'Cedofeita', 13, 26),
(48, 'Foz do Douro', 13, 26),
(49, 'Lordelo do Ouro', 13, 26),
(50, 'Massarelos', 13, 26),
(51, 'Miragaia', 13, 26),
(52, 'Paranhos', 13, 26),
(53, 'Ramalde', 13, 26),
(54, 'Santo Ildefonso', 13, 26),
(55, 'São Nicolau', 13, 26),
(56, 'São Pedro da Afurada', 13, 26),
(57, 'Vitória', 13, 26);

INSERT INTO `marca` (`id`, `nome`) VALUES
(1, 'Coca-Cola');
INSERT INTO `marca` (`id`, `nome`) VALUES
(2, 'Pepsi');
INSERT INTO `marca` (`id`, `nome`) VALUES
(3, 'Sumol');
INSERT INTO `marca` (`id`, `nome`) VALUES
(4, 'Colgate'),
(5, 'Oral-B'),
(6, 'Heinz'),
(7, 'Nestlé'),
(8, 'Danone'),
(9, 'L\'Oreal'),
(10, 'Palmolive'),
(11, 'Nivea'),
(12, 'Dove'),
(13, 'Pringles'),
(14, 'Lay\'s'),
(15, 'Cigala'),
(16, 'Equilíbrio/Continente'),
(17, 'Por Si'),
(18, 'Pingo Doce'),
(19, 'Dia'),
(20, 'Pedras'),
(21, 'Frizze'),
(22, 'President'),
(23, 'Mimosa'),
(24, 'Skip'),
(25, 'Lysol'),
(26, 'Super Bock'),
(27, 'Paulaner'),
(28, 'Heineken'),
(29, 'Sanitop'),
(30, 'Renova'),
(31, 'Açores'),
(32, 'Sanitop'),
(33, 'Barilla'),
(34, 'Cirio'),
(35, 'Olá!'),
(36, 'Fairy');

INSERT INTO `preco_historico` (`id_produto_hipermercado`, `data_preco`, `preco`) VALUES
(1, '2023-06-25 09:39:27', 2.10);
INSERT INTO `preco_historico` (`id_produto_hipermercado`, `data_preco`, `preco`) VALUES
(1, '2023-06-25 11:30:31', 1.10);
INSERT INTO `preco_historico` (`id_produto_hipermercado`, `data_preco`, `preco`) VALUES
(2, '2023-06-25 09:39:27', 2.80);
INSERT INTO `preco_historico` (`id_produto_hipermercado`, `data_preco`, `preco`) VALUES
(2, '2023-06-25 11:35:04', 1.80),
(3, '2023-06-25 09:39:27', 1.99),
(4, '2023-06-25 09:39:27', 3.50),
(5, '2023-06-25 09:39:27', 1.50),
(6, '2023-06-25 09:39:27', 2.10),
(6, '2023-06-25 10:13:50', 3.10),
(6, '2023-06-25 11:08:22', 4.10),
(6, '2023-06-25 11:08:39', 5.10),
(6, '2023-06-25 11:11:36', 6.10),
(6, '2023-06-25 11:41:44', 15.10),
(7, '2023-06-25 09:39:27', 3.75),
(8, '2023-06-25 09:39:27', 2.99),
(9, '2023-06-25 09:39:27', 1.80),
(10, '2023-06-25 09:39:27', 0.99),
(11, '2023-06-25 09:39:27', 2.10),
(11, '2023-06-25 11:30:31', 3.10),
(12, '2023-06-25 09:39:27', 2.80),
(12, '2023-06-25 11:35:04', 3.80),
(12, '2023-06-25 11:37:48', 10.80),
(12, '2023-06-25 11:38:10', 8.80),
(12, '2023-06-25 11:39:59', 1.80),
(13, '2023-06-25 09:39:27', 1.99),
(14, '2023-06-25 09:39:27', 3.50),
(15, '2023-06-25 09:39:27', 1.50),
(15, '2023-06-25 16:43:44', 7.50),
(16, '2023-06-25 09:39:27', 2.10),
(16, '2023-06-25 11:19:16', 1.10),
(16, '2023-06-25 11:26:25', 0.10),
(17, '2023-06-25 09:39:27', 3.75),
(18, '2023-06-25 09:39:27', 2.99),
(19, '2023-06-25 09:39:27', 1.80),
(20, '2023-06-25 09:39:27', 0.99),
(21, '2023-06-25 09:39:27', 2.10),
(22, '2023-06-25 09:39:27', 2.80),
(23, '2023-06-25 09:39:27', 1.99),
(24, '2023-06-25 09:39:27', 3.50),
(24, '2023-06-25 19:23:51', 1.50),
(24, '2023-06-25 19:26:21', 0.50),
(24, '2023-06-25 19:52:27', 7.50),
(25, '2023-06-25 09:39:27', 1.50),
(26, '2023-06-25 09:39:27', 2.10),
(27, '2023-06-25 09:39:27', 3.75),
(27, '2023-06-25 09:57:13', 1.80),
(27, '2023-06-25 09:58:24', 1.90),
(27, '2023-06-25 10:07:15', 2.80),
(27, '2023-06-25 10:46:39', 3.80),
(27, '2023-06-25 10:47:53', 4.80),
(27, '2023-06-25 10:50:51', 6.80),
(27, '2023-06-25 10:51:40', 7.80),
(28, '2023-06-25 09:39:27', 2.99),
(29, '2023-06-25 09:39:27', 1.80),
(29, '2023-06-25 10:06:48', 2.80),
(29, '2023-06-25 11:17:52', 0.80),
(30, '2023-06-25 09:39:27', 0.99),
(31, '2023-06-25 14:57:58', 1.75),
(32, '2023-06-25 15:29:44', 1.00),
(33, '2023-06-26 20:29:42', 2.35);

INSERT INTO `produto` (`id`, `id_seccao`, `id_marca`, `descricao`, `id_unidade_medida`) VALUES
(1, 1, 1, 'Produto 1', 1);
INSERT INTO `produto` (`id`, `id_seccao`, `id_marca`, `descricao`, `id_unidade_medida`) VALUES
(2, 1, 2, 'Produto 2', 2);
INSERT INTO `produto` (`id`, `id_seccao`, `id_marca`, `descricao`, `id_unidade_medida`) VALUES
(3, 1, 3, 'Produto 3', 3);
INSERT INTO `produto` (`id`, `id_seccao`, `id_marca`, `descricao`, `id_unidade_medida`) VALUES
(4, 2, 4, 'Produto 4', 4),
(5, 2, 5, 'Produto 5', 5),
(6, 19, 6, 'Produto 6', 6),
(7, 3, 7, 'Produto 7', 7),
(8, 3, 8, 'Produto 8', 8),
(9, 19, 9, 'Produto 9', 9),
(10, 4, 10, 'Produto 10', 10),
(11, 4, 11, 'Produto 11', 11),
(12, 4, 12, 'Produto 12', 1),
(13, 5, 13, 'Produto 13', 2),
(14, 5, 14, 'Produto 14', 3),
(15, 5, 15, 'Produto 15', 4),
(16, 6, 16, 'Produto 16', 5),
(17, 6, 17, 'Produto 17', 6),
(18, 6, 18, 'Produto 18', 7),
(19, 7, 19, 'Produto 19', 8),
(20, 7, 20, 'Produto 20', 9),
(21, 7, 21, 'Produto 21', 10),
(22, 8, 22, 'Produto 22', 11),
(23, 8, 23, 'Produto 23', 1),
(24, 8, 24, 'Produto 24', 2),
(25, 9, 25, 'Produto 25', 3),
(26, 9, 26, 'Produto 26', 4),
(27, 9, 27, 'Produto 27', 5),
(28, 10, 28, 'Produto 28', 6),
(29, 10, 29, 'Produto 29', 7),
(30, 10, 30, 'Produto 30', 8),
(31, 11, 31, 'Produto 31', 9),
(32, 11, 32, 'Produto 32', 10),
(33, 11, 33, 'Produto 33', 11),
(34, 12, 34, 'Produto 34', 1),
(35, 12, 35, 'Produto 35', 2),
(36, 12, 36, 'Produto 36', 3),
(37, 13, 1, 'Produto 37', 4),
(38, 13, 2, 'Produto 38', 5),
(39, 13, 3, 'Produto 39', 6),
(40, 14, 4, 'Produto 40', 7),
(41, 14, 5, 'Produto 41', 8),
(42, 14, 6, 'Produto 42', 9),
(43, 15, 7, 'Produto 43', 10),
(44, 15, 8, 'Produto 44', 11),
(45, 15, 9, 'Produto 45', 1),
(46, 16, 10, 'Produto 46', 2),
(47, 16, 11, 'Produto 47', 3),
(48, 16, 12, 'Produto 48', 4),
(49, 17, 13, 'Produto 49', 5),
(50, 17, 14, 'Produto 50', 6),
(51, 17, 15, 'Produto 51', 7),
(52, 18, 16, 'Produto 52', 8),
(53, 18, 17, 'Produto 53', 9),
(54, 18, 18, 'Produto 54', 10),
(55, 19, 19, 'Produto 55', 11),
(56, 19, 20, 'Produto 56', 1),
(57, 19, 21, 'Produto 57', 2),
(58, 1, 22, 'Produto 58', 3),
(59, 1, 23, 'Produto 59', 4),
(60, 1, 24, 'Produto 60', 5),
(61, 2, 25, 'Produto 61', 6),
(62, 2, 26, 'Produto 62', 7),
(63, 2, 27, 'Produto 63', 8),
(64, 3, 28, 'Produto 64', 9),
(65, 3, 29, 'Produto 65', 10),
(66, 3, 30, 'Produto 66', 11),
(67, 4, 31, 'Produto 67', 1),
(68, 4, 32, 'Produto 68', 2),
(69, 4, 33, 'Produto 69', 3),
(70, 5, 34, 'Produto 70', 4),
(71, 5, 35, 'Produto 71', 5),
(72, 5, 36, 'Produto 72', 6),
(73, 6, 1, 'Produto 73', 7),
(74, 6, 2, 'Produto 74', 8),
(75, 6, 3, 'Produto 75', 9),
(76, 7, 4, 'Produto 76', 10),
(77, 7, 5, 'Produto 77', 11),
(78, 7, 6, 'Produto 78', 1),
(79, 8, 7, 'Produto 79', 2),
(80, 8, 8, 'Produto 80', 3),
(81, 8, 9, 'Produto 81', 4),
(82, 9, 10, 'Produto 82', 5),
(83, 9, 11, 'Produto 83', 6),
(84, 9, 12, 'Produto 84', 7),
(85, 10, 13, 'Produto 85', 8),
(86, 10, 14, 'Produto 86', 9),
(87, 10, 15, 'Produto 87', 10),
(88, 11, 16, 'Produto 88', 11),
(89, 11, 17, 'Produto 89', 1),
(90, 11, 18, 'Produto 90', 2);

INSERT INTO `produto_hipermercado` (`id`, `id_produto`, `id_hipermercado_localidade`, `quantidade`, `preco`, `data_inserido`) VALUES
(1, 1, 1, 6.00, 1.10, '2022-08-28 00:00:00');
INSERT INTO `produto_hipermercado` (`id`, `id_produto`, `id_hipermercado_localidade`, `quantidade`, `preco`, `data_inserido`) VALUES
(2, 2, 2, 12.00, 1.80, '2022-08-28 00:00:00');
INSERT INTO `produto_hipermercado` (`id`, `id_produto`, `id_hipermercado_localidade`, `quantidade`, `preco`, `data_inserido`) VALUES
(3, 3, 3, 8.00, 1.99, '2022-09-02 00:00:00');
INSERT INTO `produto_hipermercado` (`id`, `id_produto`, `id_hipermercado_localidade`, `quantidade`, `preco`, `data_inserido`) VALUES
(4, 4, 4, 5.00, 3.50, '2022-09-07 00:00:00'),
(5, 5, 5, 10.00, 1.50, '2022-09-12 00:00:00'),
(6, 6, 6, 15.00, 2.10, '2022-09-17 00:00:00'),
(7, 7, 7, 6.00, 3.75, '2022-09-22 00:00:00'),
(8, 8, 8, 18.00, 2.99, '2022-09-27 00:00:00'),
(9, 9, 9, 3.00, 1.80, '2022-10-02 00:00:00'),
(10, 10, 10, 9.00, 0.99, '2022-10-07 00:00:00'),
(11, 2, 1, 6.00, 3.10, '2022-08-28 00:00:00'),
(12, 3, 2, 12.00, 1.80, '2022-08-28 00:00:00'),
(13, 4, 3, 8.00, 1.99, '2022-09-02 00:00:00'),
(14, 5, 4, 5.00, 3.50, '2022-09-07 00:00:00'),
(15, 6, 5, 10.00, 7.50, '2022-09-12 00:00:00'),
(16, 7, 6, 15.00, 0.10, '2022-09-17 00:00:00'),
(17, 8, 7, 6.00, 3.75, '2022-09-22 00:00:00'),
(18, 9, 8, 18.00, 2.99, '2022-09-27 00:00:00'),
(19, 10, 9, 3.00, 1.80, '2022-10-02 00:00:00'),
(20, 1, 10, 9.00, 0.99, '2022-10-07 00:00:00'),
(21, 3, 1, 6.00, 2.10, '2022-08-28 00:00:00'),
(22, 4, 2, 12.00, 2.80, '2022-08-28 00:00:00'),
(23, 5, 3, 8.00, 1.99, '2022-09-02 00:00:00'),
(24, 6, 4, 5.00, 7.50, '2022-09-07 00:00:00'),
(25, 7, 5, 10.00, 1.50, '2022-09-12 00:00:00'),
(26, 8, 6, 15.00, 2.10, '2022-09-17 00:00:00'),
(27, 9, 7, 6.00, 7.80, '2022-09-22 00:00:00'),
(28, 10, 8, 18.00, 2.99, '2022-09-27 00:00:00'),
(29, 1, 9, 3.00, 0.80, '2022-10-02 00:00:00'),
(30, 2, 10, 9.00, 0.99, '2022-10-07 00:00:00'),
(31, 9, 6, 10.00, 1.75, '2022-10-07 00:00:00'),
(32, 4, 7, 10.00, 1.00, '2022-10-07 00:00:00'),
(33, 6, 7, 10.00, 2.35, '2022-10-07 00:00:00');

INSERT INTO `produto_lista_compra` (`id`, `id_lista`, `id_produto`, `quantidade`) VALUES
(1, 1, 1, 2);
INSERT INTO `produto_lista_compra` (`id`, `id_lista`, `id_produto`, `quantidade`) VALUES
(2, 1, 5, 1);
INSERT INTO `produto_lista_compra` (`id`, `id_lista`, `id_produto`, `quantidade`) VALUES
(3, 1, 10, 3);
INSERT INTO `produto_lista_compra` (`id`, `id_lista`, `id_produto`, `quantidade`) VALUES
(4, 2, 3, 4),
(5, 2, 8, 2),
(6, 2, 5, 1),
(7, 2, 2, 3),
(8, 3, 2, 3),
(9, 3, 7, 2),
(10, 3, 3, 2),
(11, 3, 9, 1),
(12, 3, 4, 4),
(13, 3, 8, 2),
(14, 3, 5, 3),
(15, 3, 6, 1),
(16, 3, 10, 2),
(17, 3, 1, 3),
(18, 4, 4, 1),
(19, 4, 9, 3),
(20, 4, 8, 2),
(21, 5, 6, 2),
(22, 5, 7, 2),
(23, 5, 8, 3),
(24, 5, 9, 1),
(25, 6, 1, 3),
(26, 6, 2, 1),
(27, 6, 3, 2),
(28, 7, 4, 2),
(29, 7, 1, 3),
(30, 7, 7, 2),
(31, 7, 5, 1),
(32, 8, 9, 3),
(33, 8, 10, 2),
(34, 8, 6, 1),
(35, 8, 8, 2),
(36, 8, 3, 3),
(37, 8, 2, 4),
(38, 8, 1, 1),
(39, 8, 7, 2),
(40, 8, 5, 3),
(41, 8, 4, 2);

INSERT INTO `seccao` (`id`, `nome`) VALUES
(1, 'Bebidas');
INSERT INTO `seccao` (`id`, `nome`) VALUES
(2, 'Higiene Pessoal');
INSERT INTO `seccao` (`id`, `nome`) VALUES
(3, 'Enlatados');
INSERT INTO `seccao` (`id`, `nome`) VALUES
(4, 'Frutas'),
(5, 'Laticínios'),
(6, 'Talho'),
(7, 'Peixaria'),
(8, 'Padaria'),
(9, 'Limpeza'),
(10, 'Congelados'),
(11, 'Snacks'),
(12, 'Molhos e Temperos'),
(13, 'Massas'),
(14, 'Sobremesas'),
(15, 'Salgadinhos'),
(16, 'Biscoitos e Doces'),
(17, 'Salgados'),
(18, 'Café e Chá'),
(19, 'Charcutaria');

INSERT INTO `talao_desconto` (`id`, `id_utilizador`, `id_desconto`) VALUES
(8, 14, 3);
INSERT INTO `talao_desconto` (`id`, `id_utilizador`, `id_desconto`) VALUES
(9, 14, 8);
INSERT INTO `talao_desconto` (`id`, `id_utilizador`, `id_desconto`) VALUES
(10, 14, 15);
INSERT INTO `talao_desconto` (`id`, `id_utilizador`, `id_desconto`) VALUES
(11, 14, 12),
(12, 14, 3),
(13, 1, 3),
(14, 1, 9),
(15, 14, 9);

INSERT INTO `unidade_medida` (`id`, `nome`) VALUES
(1, 'unidade');
INSERT INTO `unidade_medida` (`id`, `nome`) VALUES
(2, 'kg');
INSERT INTO `unidade_medida` (`id`, `nome`) VALUES
(3, 'g');
INSERT INTO `unidade_medida` (`id`, `nome`) VALUES
(4, 'l'),
(5, 'ml'),
(6, 'pack 12 unidades'),
(7, 'caixa 2 unidades'),
(8, 'embalagem'),
(9, 'pack 4 unidades'),
(10, 'pack 6 unidades'),
(11, '16 rolos');

INSERT INTO `utilizador` (`id`, `nome`, `email`, `telefone`, `morada`, `id_localidade`) VALUES
(1, 'Carlos Ferreira', 'carlosferreira@email.com', '111111111', 'Morada1', 3);
INSERT INTO `utilizador` (`id`, `nome`, `email`, `telefone`, `morada`, `id_localidade`) VALUES
(2, 'Ana Rodrigues', 'anarodrigues@email.com', '222222222', 'Morada2', 4);
INSERT INTO `utilizador` (`id`, `nome`, `email`, `telefone`, `morada`, `id_localidade`) VALUES
(3, 'Rui Almeida', 'rdealmeida@email.com', '333333333', 'Morada3', 5);
INSERT INTO `utilizador` (`id`, `nome`, `email`, `telefone`, `morada`, `id_localidade`) VALUES
(4, 'Sara Costa', 'saracosta@email.com', '444444444', 'Morada4', 6),
(5, 'Paulo Sousa', 'paulosousa@email.com', '555555555', 'Morada5', 7),
(6, 'Marta Gomes', 'martagomes@email.com', '666666666', 'Morada6', 8),
(7, 'Hugo Santos', 'hugosantos@email.com', '777777777', 'Morada7', 9),
(8, 'Inês Oliveira', 'inesoliveira@email.com', '888888888', 'Morada8', 10),
(9, 'Vasco Marques', 'vascomarques@email.com', '202020202', 'Morada9', 23),
(10, 'Miguel Pereira', 'miguelpereira@email.com', '999999999', 'Morada10', 11),
(11, 'Carolina Martins', 'carolinamartins@email.com', '101010101', 'Morada11', 12),
(12, 'Tiago Santos', 'tiagosantos@email.com', '121212121', 'Morada12', 13),
(13, 'Inês Carvalho', 'inescarvalho@email.com', '131313131', 'Morada13', 14),
(14, 'Pedro Costa', 'pedrocosta@email.com', '141414141', 'Morada14', 15),
(15, 'Sofia Fernandes', 'sofiafernandes@email.com', '151515151', 'Morada15', 16),
(16, 'Ricardo Silva', 'ricardosilva@email.com', '161616161', 'Morada16', 17),
(17, 'Catarina Rodrigues', 'catarinarodrigues@email.com', '171717171', 'Morada17', 18),
(18, 'Luisa Pereira', 'luisapereira@email.com', '191919191', 'Morada18', 22),
(19, 'Gustavo Santos', 'gustavosantos@email.com', '212020202', 'Morada19', 19),
(20, 'Rita Ferreira', 'ritaferreira@email.com', '212121212', 'Morada20', 20),
(21, 'João Silva', 'joaosilva@email.com', '181818181', 'Morada21', 21),
(22, 'Mariana Santos', 'marianasantos@email.com', '202020212', 'Morada22', 22),
(23, 'Daniel Pereira', 'danielpereira@email.com', '212124212', 'Morada23', 23),
(24, 'Patrícia Gomes', 'patriciagomes@email.com', '232323232', 'Morada24', 24),
(25, 'Rui Martins', 'ruimartins@email.com', '242424242', 'Morada25', 25),
(26, 'Ana Sousa', 'anasousa@email.com', '252525252', 'Morada26', 26),
(27, 'Diogo Fernandes', 'diogofernandes@email.com', '262626262', 'Morada27', 27),
(28, 'Sílvia Costa', 'silviacosta@email.com', '272727272', 'Morada28', 28),
(29, 'Rui Carvalho', 'ruicarvalho@email.com', '282828282', 'Morada29', 29),
(30, 'Teresa Oliveira', 'teresaoliveira@email.com', '292929292', 'Morada30', 30),
(31, 'Mário Santos', 'mariosantos@email.com', '303030303', 'Morada31', 31);
INSERT INTO `utilizador` (`id`, `nome`, `email`, `telefone`, `morada`, `id_localidade`) VALUES
(32, 'Inês Ferreira', 'inesferreira@email.com', '313131313', 'Morada32', 32),
(33, 'Paulo Almeida', 'pauloalmeida@email.com', '323232323', 'Morada33', 33),
(34, 'Marta Costa', 'martacosta@email.com', '333443333', 'Morada34', 34),
(35, 'Hugo Rodrigues', 'hugorodrigues@email.com', '343434343', 'Morada35', 35),
(36, 'Sara Gomes', 'saragomes@email.com', '353535353', 'Morada36', 36),
(37, 'Tiago Fernandes', 'tiagofernandes@email.com', '363636363', 'Morada37', 37),
(38, 'Ana Carvalho', 'anacarvalho@email.com', '373737373', 'Morada38', 38),
(39, 'Ricardo Pereira', 'ricardopereira@email.com', '383838383', 'Morada39', 39),
(40, 'Catarina Santos', 'catarinasantos@email.com', '393939393', 'Morada40', 40),
(41, 'Joana Silva', 'joanasilva@email.com', '404040404', 'Morada41', 41),
(42, 'Miguel Santos', 'miguelsantos@email.com', '414141414', 'Morada42', 42),
(43, 'Rita Pereira', 'ritapereira@email.com', '424242424', 'Morada43', 43),
(44, 'Diogo Gomes', 'diogogomes@email.com', '434343434', 'Morada44', 44),
(45, 'Sofia Martins', 'sofiamartins@email.com', '423444444', 'Morada45', 45),
(46, 'Ricardo Almeida', 'ricardoalmeida@email.com', '454545454', 'Morada46', 46),
(47, 'Mariana Rodrigues', 'marianarodrigues@email.com', '464646464', 'Morada47', 47),
(48, 'Daniel Costa', 'danielcosta@email.com', '474747474', 'Morada48', 48),
(49, 'Marta Fernandes', 'martafernandes@email.com', '484848484', 'Morada49', 49),
(50, 'Hugo Sousa', 'hugosousa@email.com', '494949494', 'Morada50', 50),
(51, 'Inês Costa', 'inescosta@email.com', '505050505', 'Morada51', 51),
(52, 'Pedro Rodrigues', 'pedrorodrigues@email.com', '515151515', 'Morada52', 52),
(53, 'Sara Almeida', 'saraalmeida@email.com', '525252525', 'Morada53', 53),
(54, 'João Gomes', 'joaogomes@email.com', '535353535', 'Morada54', 54),
(55, 'Mariana Fernandes', 'marianafernandes@email.com', '545454545', 'Morada55', 55),
(56, 'André Silva', 'andresilva@email.com', '555545555', 'Morada56', 56),
(57, 'Carolina Costa', 'carolinacosta@email.com', '565656565', 'Morada57', 57);

INSERT INTO `utilizador_hipermercado` (`id_utilizador`, `id_hipermercado_localidade`) VALUES
(3, 1);
INSERT INTO `utilizador_hipermercado` (`id_utilizador`, `id_hipermercado_localidade`) VALUES
(6, 1);
INSERT INTO `utilizador_hipermercado` (`id_utilizador`, `id_hipermercado_localidade`) VALUES
(8, 1);
INSERT INTO `utilizador_hipermercado` (`id_utilizador`, `id_hipermercado_localidade`) VALUES
(11, 1),
(15, 1),
(19, 1),
(21, 1),
(24, 1),
(28, 1),
(32, 1),
(36, 1),
(39, 1),
(43, 1),
(49, 1),
(53, 1),
(57, 1),
(1, 2),
(13, 2),
(17, 2),
(23, 2),
(26, 2),
(30, 2),
(35, 2),
(40, 2),
(45, 2),
(47, 2),
(51, 2),
(56, 2),
(2, 3),
(9, 3),
(11, 3),
(14, 3),
(18, 3),
(22, 3),
(26, 3),
(29, 3),
(33, 3),
(37, 3),
(41, 3),
(44, 3),
(47, 3),
(50, 3),
(54, 3),
(2, 4),
(7, 4),
(10, 4),
(15, 4),
(19, 4),
(25, 4),
(31, 4),
(33, 4),
(38, 4),
(41, 4),
(46, 4),
(52, 4),
(54, 4),
(4, 5),
(6, 5),
(12, 5),
(16, 5),
(20, 5),
(22, 5),
(27, 5),
(30, 5),
(34, 5),
(37, 5),
(42, 5),
(45, 5),
(48, 5),
(51, 5),
(55, 5),
(1, 6),
(5, 6),
(8, 6),
(10, 6),
(14, 6),
(17, 6),
(21, 6),
(25, 6),
(28, 6),
(32, 6),
(36, 6),
(40, 6),
(43, 6),
(46, 6),
(49, 6),
(53, 6),
(57, 6),
(1, 7),
(3, 7),
(5, 7),
(13, 7),
(14, 7),
(16, 7),
(24, 7),
(27, 7),
(31, 7),
(35, 7),
(39, 7),
(42, 7),
(48, 7),
(52, 7),
(56, 7),
(2, 8),
(4, 8),
(5, 8),
(7, 8),
(9, 8),
(12, 8),
(18, 8),
(20, 8),
(23, 8),
(29, 8),
(34, 8),
(38, 8),
(44, 8),
(50, 8),
(55, 8);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;