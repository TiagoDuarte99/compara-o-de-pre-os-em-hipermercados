# Projeto: We Are Here To Help LDA

## Descrição do Projeto
Este projeto é desenvolvido para gerenciar dados de uma empresa fictícia chamada "We Are Here To Help LDA". O sistema utiliza consultas SQL para realizar operações no banco de dados, incluindo queries, triggers, e scripts de inicialização para a base de dados da empresa. O objetivo é permitir a manipulação de informações de maneira eficiente através de consultas otimizadas.

## Estrutura do Projeto

- **Diagrama.pdf**: Este arquivo contém o diagrama ER (Entidade-Relacionamento) que descreve a estrutura do banco de dados, incluindo as relações entre as tabelas principais como `users`, `orders`, etc.
- **Queries a mais.sql**: Contém consultas SQL adicionais para gerenciamento dos dados.
- **Queries enunciado.sql**: Contém as consultas principais requeridas para o projeto, conforme o enunciado.
- **Trigger.sql**: Script SQL contendo gatilhos (triggers) para automatizar ações dentro do banco de dados com base em eventos específicos.
- **weareheretohelplda.sql**: Script SQL que inicializa o banco de dados da empresa com os dados e a estrutura necessária para operar o sistema.

## Instalação e Configuração

1. **Pré-requisitos**:
   - Um servidor MySQL configurado.
   - Acesso à ferramenta de administração do banco de dados, como MySQL Workbench ou phpMyAdmin.

2. **Passos para configurar o banco de dados**:
   - Faça o upload do arquivo `weareheretohelplda.sql` no seu ambiente de banco de dados.
   - Execute os scripts SQL na seguinte ordem:
     1. `weareheretohelplda.sql` - Inicializa o banco de dados.
     2. `Queries enunciado.sql` - Executa as consultas requeridas.
     3. `Queries a mais.sql` - Executa consultas adicionais para manipulação de dados.
     4. `Trigger.sql` - Cria os gatilhos automáticos no banco de dados.

3. **Diagrama**:
   - Consulte o arquivo `Diagrama.pdf` para visualizar a estrutura das tabelas e as relações entre elas.

## Utilização
Após configurar o banco de dados, o sistema permitirá consultas e a realização de operações automáticas através dos triggers implementados. Para mais detalhes sobre as queries e os triggers, veja os respectivos arquivos SQL.

## Autores
Este projeto foi desenvolvido como parte de um exercício prático em SQL e banco de dados relacionais.
