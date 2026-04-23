USE AdventureWorks
GO

/************************************************************************
			SQL SERVER - OBJETOS DE PROGRAMAÇÃO
-------------------------------------------------------------------------
Stored Procedures - Views - Functions - Triggers
Try...Catch + THROW - Output Parameters - Control Flow (IF / WHILE)
-------------------------------------------------------------------------
************************************************************************/

-- =========================================
-- EXERCÍCIO 1 - STORED PROCEDURE (SELECT)
-- Contexto:
-- O time de vendas precisa consultar pedidos por cliente.
-- Enunciado:
-- Crie uma stored procedure que receba @CustomerID e retorne
-- todos os pedidos (SalesOrderID, OrderDate, TotalDue) da tabela Sales.SalesOrderHeader.

-- =========================================
-- EXERCÍCIO 2 - STORED PROCEDURE (INSERT)
-- Contexto:
-- Cadastro de novos produtos.
-- Enunciado:
-- Crie uma stored procedure que insira um novo produto na tabela Production.Product.
-- Receba parâmetros como Name, ProductNumber e ListPrice.

-- =========================================
-- EXERCÍCIO 3 - STORED PROCEDURE (UPDATE)
-- Contexto:
-- Ajuste de preços.
-- Enunciado:
-- Crie uma stored procedure que atualize o ListPrice de um produto com base no ProductID.

-- =========================================
-- EXERCÍCIO 4 - STORED PROCEDURE (DELETE)
-- Contexto:
-- Limpeza de dados.
-- Enunciado:
-- Crie uma stored procedure que delete um produto com base no ProductID.

-- =========================================
-- EXERCÍCIO 5 - STORED PROCEDURE (OUTPUT)
-- Contexto:
-- Monitoramento de operações.
-- Enunciado:
-- Crie uma stored procedure que retorne a quantidade de pedidos de um cliente via parâmetro OUTPUT.

-- =========================================
-- EXERCÍCIO 6 - TRANSACTION (INSERT)
-- Contexto:
-- Inserção segura de dados.
-- Enunciado:
-- Crie um script que insira um produto na tabela Production.Product dentro de uma transação.
-- Em caso de erro, execute ROLLBACK.

-- =========================================
-- EXERCÍCIO 7 - TRANSACTION (UPDATE)
-- Contexto:
-- Atualização crítica de dados.
-- Enunciado:
-- Atualize o preço de vários produtos dentro de uma transação.
-- Caso qualquer atualização falhe, reverta toda a operação.

-- =========================================
-- EXERCÍCIO 8 - TRANSACTION (DELETE)
-- Contexto:
-- Exclusão controlada.
-- Enunciado:
-- Exclua pedidos antigos da tabela Sales.SalesOrderHeader dentro de uma transação.

-- =========================================
-- EXERCÍCIO 9 - TRANSACTION (MULTI-TABLE)
-- Contexto:
-- Consistência entre tabelas.
-- Enunciado:
-- Insira dados em duas tabelas relacionadas (Product e ProductInventory).
-- Se uma falhar, faça rollback de tudo.

-- =========================================
-- EXERCÍCIO 10 - TRANSACTION (MANUAL TEST)
-- Contexto:
-- Testes controlados.
-- Enunciado:
-- Crie uma transação que insira um produto e utilize ROLLBACK manualmente para validar o comportamento.

-- =========================================
-- EXERCÍCIO 26 - VIEW (JOIN)
-- Contexto:
-- Relatório de pedidos por cliente.
-- Enunciado:
-- Crie uma VIEW que relacione Sales.Customer com Sales.SalesOrderHeader
-- exibindo CustomerID, SalesOrderID, OrderDate e TotalDue.

-- =========================================
-- EXERCÍCIO 27 - VIEW (FILTRO)
-- Contexto:
-- Produtos ativos.
-- Enunciado:
-- Crie uma VIEW que retorne apenas produtos com ListPrice maior que 0.

-- =========================================
-- EXERCÍCIO 28 - VIEW (AGREGAÇÃO)
-- Contexto:
-- Análise de vendas.
-- Enunciado:
-- Crie uma VIEW que mostre a quantidade de pedidos por CustomerID.

-- =========================================
-- EXERCÍCIO 29 - VIEW (FORMATAÇÃO)
-- Contexto:
-- Relatório amigável.
-- Enunciado:
-- Crie uma VIEW que exiba Name e ListPrice formatado como moeda.

-- =========================================
-- EXERCÍCIO 30 - VIEW (COMPLETA)
-- Contexto:
-- Dashboard de produtos.
-- Enunciado:
-- Crie uma VIEW com ProductID, Name, ListPrice e uma classificação usando CASE.

-- =========================================
-- EXERCÍCIO 31 - FUNCTION (ESCALAR)
-- Contexto:
-- Cálculo simples.
-- Enunciado:
-- Crie uma função escalar que receba um valor e retorne o valor com 10% de acréscimo.

-- =========================================
-- EXERCÍCIO 32 - FUNCTION (ESCALAR COM DATA)
-- Contexto:
-- Cálculo de tempo.
-- Enunciado:
-- Crie uma função que receba duas datas e retorne a diferença em dias.

-- =========================================
-- EXERCÍCIO 33 - FUNCTION (TABLE-VALUED)
-- Contexto:
-- Consulta reutilizável.
-- Enunciado:
-- Crie uma função que retorne todos os pedidos de um cliente.

-- =========================================
-- EXERCÍCIO 34 - FUNCTION (FILTRO)
-- Contexto:
-- Produtos por faixa.
-- Enunciado:
-- Crie uma função que receba um valor mínimo e retorne produtos acima desse valor.

-- =========================================
-- EXERCÍCIO 35 - FUNCTION (AGREGAÇÃO)
-- Contexto:
-- Métricas.
-- Enunciado:
-- Crie uma função que retorne o total de vendas de um CustomerID.

-- =========================================
-- EXERCÍCIO 36 - TRIGGER (INSERT)
-- Contexto:
-- Auditoria de inserção.
-- Enunciado:
-- Crie um trigger AFTER INSERT na tabela Production.Product
-- que registre o ProductID inserido em uma tabela de log.

-- =========================================
-- EXERCÍCIO 37 - TRIGGER (UPDATE)
-- Contexto:
-- Monitoramento de alterações.
-- Enunciado:
-- Crie um trigger que registre alterações no ListPrice.

-- =========================================
-- EXERCÍCIO 38 - TRIGGER (DELETE)
-- Contexto:
-- Controle de exclusões.
-- Enunciado:
-- Crie um trigger que registre produtos deletados.

-- =========================================
-- EXERCÍCIO 39 - TRIGGER (VALIDAÇÃO)
-- Contexto:
-- Regra de negócio.
-- Enunciado:
-- Impedir inserção de produtos com ListPrice <= 0 utilizando trigger.

-- =========================================
-- EXERCÍCIO 40 - TRIGGER (MULTI-LINHA)
-- Contexto:
-- Processamento em lote.
-- Enunciado:
-- Crie um trigger que funcione corretamente para múltiplas linhas inseridas.
-- Utilize a tabela INSERTED.

-- =========================================
-- EXERCÍCIO 11 - TRY...CATCH (INSERT)
-- Contexto:
-- Tratamento de erro em inserção.
-- Enunciado:
-- Crie um bloco TRY...CATCH para inserir um produto.
-- Capture erros e exiba mensagem personalizada.

-- =========================================
-- EXERCÍCIO 12 - TRY...CATCH (UPDATE)
-- Contexto:
-- Segurança na atualização.
-- Enunciado:
-- Atualize o preço de um produto e trate erros com TRY...CATCH.

-- =========================================
-- EXERCÍCIO 13 - THROW (VALIDAÇÃO)
-- Contexto:
-- Validação de dados.
-- Enunciado:
-- Lance um erro com THROW se o ListPrice for menor ou igual a zero.

-- =========================================
-- EXERCÍCIO 14 - TRY...CATCH + TRANSACTION
-- Contexto:
-- Operações críticas.
-- Enunciado:
-- Combine TRY...CATCH com transação para inserir um produto.
-- Faça rollback em caso de erro.

-- =========================================
-- EXERCÍCIO 15 - THROW (DUPLICIDADE)
-- Contexto:
-- Evitar duplicação.
-- Enunciado:
-- Verifique se ProductNumber já existe.
-- Caso exista, lance erro com THROW.

-- =========================================
-- EXERCÍCIO 21 - IF
-- Contexto:
-- Validação de entrada.
-- Enunciado:
-- Verifique se um produto existe antes de realizar um SELECT.

-- =========================================
-- EXERCÍCIO 22 - IF ELSE
-- Contexto:
-- Classificação.
-- Enunciado:
-- Classifique produtos como 'Caro' ou 'Barato' usando IF.

-- =========================================
-- EXERCÍCIO 23 - WHILE
-- Contexto:
-- Processamento iterativo.
-- Enunciado:
-- Crie um loop WHILE que percorra IDs de produtos e exiba seus nomes.

-- =========================================
-- EXERCÍCIO 24 - WHILE + INSERT
-- Contexto:
-- Geração de dados.
-- Enunciado:
-- Insira registros em uma tabela temporária usando WHILE.

-- =========================================
-- EXERCÍCIO 25 - IF + THROW
-- Contexto:
-- Validação crítica.
-- Enunciado:
-- Lance erro com THROW se um valor não atender uma regra de negócio.