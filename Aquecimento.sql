USE AdventureWorks
GO

-- =========================================
-- ESQUENTA - PRÁTICAS DE SQLSERVER [EXISTS / GROUP BY]
-- SINTXES
-- EXISTS:
		--IF EXISTS (SELECT 1 FROM tabela WHERE condicao)
-- GROUP BY: 
		--SELECT coluna, COUNT(*) FROM tabela
		--GROUP BY coluna
-- =========================================

-- =========================================
---------- PARTE 1 ---------------
-- =========================================
-- EXERCÍCIO 1 - EXISTS (Validação simples)
-- Contexto:
-- Verificar se existem pedidos.
-- Enunciado:
-- Crie uma consulta que retorne apenas se EXISTEM pedidos na tabela Sales.SalesOrderHeader.

IF EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader]
)
PRINT 'EXISTEM PEDIDOS';
ELSE
	PRINT 'NÃO EXISTEM PEDIDOS';

-- Nota
/*
IF EXISTS → valida tabela inteira
WHERE EXISTS → valida linha a linha
*/

-- =========================================
-- EXERCÍCIO 2 - EXISTS (Filtro por cliente)
-- Contexto:
-- Clientes com pedidos.
-- Enunciado:
-- Liste CustomerID da tabela Sales.Customer apenas se EXISTIREM pedidos relacionados.

SELECT
    C.CustomerID
FROM Sales.Customer C
WHERE EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader O
    WHERE O.CustomerID = C.CustomerID
);
-- Nota
/*
IF EXISTS → valida tabela inteira
WHERE EXISTS → valida linha a linha
*/

-- =========================================
-- EXERCÍCIO 3 - EXISTS (NOT EXISTS)
-- Contexto:
-- Clientes sem pedidos.
-- Enunciado:
-- Liste CustomerID que NÃO possuem pedidos utilizando NOT EXISTS.

SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE NOT EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] S
	WHERE S.CustomerID = C.CustomerID
)

-- =========================================
-- EXERCÍCIO 4 - EXISTS (Validação com condição)
-- Contexto:
-- Pedidos de alto valor.
-- Enunciado:
-- Liste clientes que possuem pelo menos um pedido com TotalDue maior que 5000.

SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] S
	WHERE C.CustomerID = S.CustomerID
	AND S.TotalDue > 5000
)

-- =========================================
-- EXERCÍCIO 5 - EXISTS (Subquery correlacionada)
-- Contexto:
-- Relacionamento entre tabelas.
-- Enunciado:
-- Liste produtos que possuem registros na tabela Sales.SalesOrderDetail.

SELECT
	P.ProductID,
	P.Name
FROM [Production].[Product] P
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
)

-- Produtos que não existem [Outra opção de análise]
SELECT
	P.ProductID,
	P.Name
FROM [Production].[Product] P
WHERE NOT EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
)


-- =========================================
---------- PARTE 2 ---------------
-- =========================================
-- EXERCÍCIO 6 - EXISTS (Filtro por data)
-- Contexto:
-- Clientes com pedidos recentes.
-- Enunciado:
-- Liste CustomerID da tabela Sales.Customer que possuem pelo menos um pedido
-- na tabela Sales.SalesOrderHeader realizado no ano de 2014.

SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.OrderDate >= '20140101'
	AND H.OrderDate <  '20150101'
)


-- =========================================
-- EXERCÍCIO 7 - EXISTS (Validação com múltiplas condições)
-- Contexto:
-- Clientes com pedidos relevantes.
-- Enunciado:
-- Liste CustomerID que possuem pedidos com TotalDue maior que 1000
-- E que tenham sido realizados após o ano de 2013.

SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.TotalDue > 1000
	AND H.OrderDate >= '20140101'
)

-- =========================================
-- EXERCÍCIO 8 - EXISTS (Relacionamento indireto)
-- Contexto:
-- Produtos vendidos com desconto.
-- Enunciado:
-- Liste produtos (Production.Product) que possuem registros na tabela
-- Sales.SalesOrderDetail onde UnitPriceDiscount seja maior que 0.

SELECT
	P.ProductID,
	P.Name
FROM [Production].[Product] P
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
	AND D.UnitPriceDiscount > 0
)



-- =========================================
-- EXERCÍCIO 9 - NOT EXISTS (Validação por categoria)
-- Contexto:
-- Produtos nunca vendidos.
-- Enunciado:
-- Liste produtos que NÃO possuem registros na tabela Sales.SalesOrderDetail
-- e possuem ListPrice maior que 100.

-- Versão para relatório / apresentação - Com FORMAT
SELECT
	P.ProductID,
	P.Name,
	FORMAT(P.ListPrice,'C','pt-BR') AS Price
FROM [Production].[Product] P
WHERE NOT EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
) AND P.ListPrice > 100; 

-- Versão com melhor performance - CONVERT
SELECT
	P.ProductID,
	P.Name,
	CONVERT(VARCHAR(20),P.ListPrice) AS Price
FROM [Production].[Product] P
WHERE NOT EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
) AND P.ListPrice > 100; 


-- =========================================
-- EXERCÍCIO 10 - EXISTS (Validação em múltiplas tabelas)
-- Contexto:
-- Clientes com atividade completa.
-- Enunciado:
-- Liste clientes que possuem pedidos (SalesOrderHeader)
-- E também possuem registros associados na tabela Sales.SalesOrderDetail.
-- Utilize EXISTS em ambas as validações.

SELECT 
    C.CustomerID
FROM Sales.Customer C
WHERE EXISTS (
    SELECT 1 
    FROM Sales.SalesOrderHeader H
    JOIN Sales.SalesOrderDetail D
        ON D.SalesOrderID = H.SalesOrderID
    WHERE H.CustomerID = C.CustomerID
);

-- =========================================
---------- PARTE 3 ---------------
-- =========================================
-- EXERCÍCIO 6 - GROUP BY (Contagem)
-- Contexto:
-- Volume de pedidos.
-- Enunciado:
-- Conte a quantidade de pedidos por CustomerID.

SELECT 
	CustomerID AS Cliente,
	COUNT(SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY QtPedidos DESC; -- Retorna os clientes com mais pedidos


-- =========================================
-- EXERCÍCIO 7 - GROUP BY (Soma)
-- Contexto:
-- Faturamento por cliente.
-- Enunciado:
-- Some o TotalDue por CustomerID.
SELECT
    CustomerID,
    SUM(TotalDue) AS TotalFaturado
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalFaturado DESC;

-- =========================================
-- EXERCÍCIO 8 - GROUP BY (Média)
-- Contexto:
-- Ticket médio.
-- Enunciado:
-- Calcule o valor médio dos pedidos por CustomerID.

SELECT 
	CustomerID AS Cliente,
	AVG(CAST(TotalDue AS DECIMAL(10,2))) AS TicketMédio
FROM [Sales].[SalesOrderHeader]
WHERE TotalDue > 0 -- Elimina valores zerados da análise
GROUP BY CustomerID
ORDER BY TicketMédio DESC;


-- =========================================
-- EXERCÍCIO 9 - GROUP BY (Filtro com HAVING)
-- Contexto:
-- Clientes ativos.
-- Enunciado:
-- Liste clientes com mais de 5 pedidos.

SELECT
	CustomerID AS Cliente,
	COUNT(SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 5
ORDER BY QtPedidos DESC; -- Evidencia Clientes com mais pedidos


-- =========================================
-- EXERCÍCIO 10 - GROUP BY (Múltiplas colunas)
-- Contexto:
-- Análise por período.
-- Enunciado:
-- Agrupe pedidos por CustomerID e ano (OrderDate).

SELECT
	CustomerID AS Cliente,
	COUNT(SalesOrderID) AS QtPedidos,
	YEAR(OrderDate) AS ANO
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID, YEAR(OrderDate)
ORDER BY QtPedidos DESC;

-- Quantidade de pedidos por ano

SELECT
	COUNT(SalesOrderID) AS QtPedidos,
	YEAR(OrderDate) AS ANO
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY QtPedidos DESC;

----------------------------------EXTRAS----------------------------------------

-- =========================================
-- EXERCÍCIO 1 - EXISTS + DATA
-- Contexto:
-- Clientes recentes.
-- Enunciado:
-- Liste clientes que possuem pelo menos um pedido realizado após 01/01/2013.

SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND OrderDate > '20130101'
)


-- =========================================
-- EXERCÍCIO 2 - NOT EXISTS
-- Contexto:
-- Clientes inativos.
-- Enunciado:
-- Liste clientes que NÃO possuem pedidos na tabela Sales.SalesOrderHeader.

SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE NOT EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
)

-- =========================================
-- EXERCÍCIO 3 - GROUP BY + COUNT
-- Contexto:
-- Volume de pedidos por território.
-- Enunciado:
-- Conte a quantidade de pedidos por TerritoryID.

-- Organiza pelo Território
SELECT
	H.TerritoryID AS IdTerritorio,
	T.Name AS Territorio,
	COUNT(H.SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY H.TerritoryID, T.Name
ORDER BY H.TerritoryID;

-- Mostra os Territórios com mais pedidos
SELECT
	H.TerritoryID AS IdTerritorio,
	T.Name AS Territorio,
	COUNT(H.SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY H.TerritoryID, T.Name
ORDER BY QtPedidos DESC; 


-- =========================================
-- EXERCÍCIO 4 - GROUP BY + SUM
-- Contexto:
-- Receita por território.
-- Enunciado:
-- Calcule o total de vendas (TotalDue) por TerritoryID.

SELECT
	T.TerritoryID,
	T.Name AS Território,
	SUM(H.TotalDue) AS Receita
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID,T.Name
ORDER BY T.TerritoryID;

-- Formatado para Exibição/Análise
SELECT
	T.TerritoryID,
	T.Name AS Território,
	FORMAT(SUM(H.TotalDue),'C','pt-BR') AS Receita
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID,T.Name
ORDER BY T.TerritoryID;


-- =========================================
-- EXERCÍCIO 5 - GROUP BY + HAVING
-- Contexto:
-- Territórios relevantes.
-- Enunciado:
-- Liste territórios que possuem mais de 100 pedidos.

SELECT
	T.TerritoryID,
	T.Name,
	COUNT(SalesOrderID) AS Qtde
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID, T.Name
HAVING COUNT(SalesOrderID) > 100
ORDER BY Qtde DESC;


-- =========================================
-- EXERCÍCIO 6 - EXISTS + CONDIÇÃO
-- Contexto:
-- Clientes VIP.
-- Enunciado:
-- Liste clientes que possuem pelo menos um pedido com TotalDue maior que 10000.

SELECT DISTINCT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.TotalDue > 10000
);

-- =========================================
-- EXERCÍCIO 7 - GROUP BY + AVG
-- Contexto:
-- Ticket médio por território.
-- Enunciado:
-- Calcule o ticket médio (AVG TotalDue) por TerritoryID.

SELECT 
	T.TerritoryID,
	AVG(H.TotalDue) AS TicketMedio
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
WHERE H.TotalDue > 0
GROUP BY T.TerritoryID
ORDER BY TicketMedio DESC;

-- Formatado para análise

SELECT 
	T.TerritoryID,
	FORMAT(AVG(H.TotalDue),'C','pt-BR') AS TicketMedio
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
WHERE H.TotalDue > 0
GROUP BY T.TerritoryID
ORDER BY AVG(H.TotalDue) DESC;

-- =========================================
-- EXERCÍCIO 8 - EXISTS + JOIN implícito
-- Contexto:
-- Produtos vendidos.
-- Enunciado:
-- Liste produtos que possuem registros na tabela Sales.SalesOrderDetail.

SELECT
	P.ProductID,
	P.Name
FROM [Production].[Product] P
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
)

-- =========================================
-- EXERCÍCIO 9 - NOT EXISTS + CONDIÇÃO
-- Contexto:
-- Produtos caros não vendidos.
-- Enunciado:
-- Liste produtos com ListPrice maior que 500 que nunca foram vendidos.

SELECT
	P.ProductID,
	P.Name,
	P.ListPrice
FROM [Production].[Product] P
WHERE P.ListPrice > 500
AND NOT EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
);

-- =========================================
-- EXERCÍCIO 10 - GROUP BY + MULTI COLUNA
-- Contexto:
-- Análise por território e ano.
-- Enunciado:
-- Agrupe pedidos por TerritoryID e ano (OrderDate), exibindo a quantidade de pedidos.

SELECT
	T.TerritoryID,
	YEAR(H.OrderDate) AS YearDt,
	COUNT(H.SalesOrderID) AS Qtde
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID, YEAR(H.OrderDate)
ORDER BY T.TerritoryID, YearDt;
---------------------------------------------------------------------

-- 1) EXISTS
-- Liste clientes que possuem pedidos após 2012
SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] S
	WHERE S.CustomerID = C.CustomerID
	AND S.OrderDate >= '20130101'
)


-- 2) GROUP BY
-- Conte pedidos por CustomerID

SELECT
	COUNT(SalesOrderID) AS QtPedidos,
	CustomerID
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY QtPedidos DESC;

-- 3) HAVING
-- Liste clientes com mais de 5 pedidos

SELECT
	CustomerID,
	COUNT(SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 5
ORDER BY QtPedidos DESC;