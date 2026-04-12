USE [AdventureWorks];
GO

-- =========================================
-- EX2.: - SQL SERVER (AdventureWorks)
-- =========================================

-- -------------------------------
-- 📦 BATCH 
-- -------------------------------
-- 1. Execute dois SELECTs simples separados por GO usando a tabela Person.Person.
SELECT CONCAT(FirstName, ' ', MiddleName, '  ',LastName) AS Compl_Name
FROM [Person].[Person]
ORDER BY FirstName;
GO

SELECT BusinessEntityID,PersonType FROM [Person].[Person];
GO

-- 2. Crie um batch que declare uma variável e faça um SELECT, depois outro batch com outro SELECT.
DECLARE @ID INT
SET @ID = 10;

SELECT BusinessEntityID, CONCAT(FirstName, ' ', MiddleName, '  ',LastName) AS Compl_Name
FROM [Person].[Person]
WHERE BusinessEntityID = @ID;
GO

DECLARE @NAME VARCHAR(30)
SET @NAME = 'Michael';

SELECT BusinessEntityID, CONCAT(FirstName, ' ', MiddleName, '  ',LastName) AS Compl_Name
FROM [Person].[Person]
WHERE FirstName LIKE '%Michael%'
ORDER BY BusinessEntityID;
GO

-- 3. Teste declarar uma variável antes do GO e utilizá-la depois.

DECLARE @VAR INT
SET @VAR = 10;
GO

SELECT BusinessEntityID, (FirstName + ' ' + LastName) AS Name
FROM [Person].[Person]
WHERE BusinessEntityID = @VAR; -- ERRO

-- 4. Faça dois SELECTs em batches diferentes consultando Production.Product.

SELECT TOP 20 ProductID, Name, MakeFlag
FROM [Production].[Product];
GO

SELECT TOP 10 ProductID,ReorderPoint 
FROM [Production].[Product];
GO

-- 5. Execute um SELECT antes e depois de um GO e observe o comportamento.
SELECT SalesOrderID, CustomerID, TotalDue 
FROM [Sales].[SalesOrderHeader]
ORDER BY SalesOrderID;

SELECT SalesOrderID, CustomerID, TotalDue 
FROM [Sales].[SalesOrderHeader]
ORDER BY SalesOrderID;
GO

-- -------------------------------
-- 🏷️ NOMES DE OBJETOS (5 exercícios)
-- -------------------------------
-- 1. Faça um SELECT usando alias simples para a tabela Person.Person.
SELECT PP.BusinessEntityID,PP.FirstName
FROM [Person].[Person] AS PP;
GO

-- 2. Use alias com colchetes para colunas com nomes personalizados.
SELECT SS.BusinessEntityID [Id], SS.Bonus [Plus]
FROM [Sales].[SalesPerson] AS SS;
GO

-- 3. Crie um SELECT usando alias diferentes para colunas de Production.Product.
SELECT  
	PP.ProductID [Id_Produto],
	PP.Color [Cor], 
	PP.Name [Nome_Produto]
FROM [Production].[Product] PP
WHERE PP.Color IS NOT NULL
ORDER BY PP.ProductID;
GO

-- 4. Use nomes de colunas com e sem alias na mesma query.
SELECT 
	P.FirstName,
	P.LastName,
	CONCAT(P.FirstName,' ',P.LastName) AS COMP_NAME
FROM [Person].[Person] P;
GO

-- 5. Teste usar um alias com espaço (utilizando colchetes).
SELECT 
	HE.BusinessEntityID [Id Funcionário],
	CONCAT(PP.FirstName,' ',PP.LastName) [Nome Funcionário]
FROM [HumanResources].[Employee] HE
JOIN [Person].[Person] PP ON PP.BusinessEntityID = HE.BusinessEntityID
ORDER BY HE.BusinessEntityID;
GO


-- -------------------------------
-- 🔢 VARIÁVEIS
-- -------------------------------
-- 1. Declare uma variável INT e atribua um valor fixo, depois exiba.
DECLARE @VALOR INT
SET @VALOR = 100;

IF (@VALOR = 100)
	PRINT 'VALE CEM'
ELSE
	PRINT 'OUTRO VALOR'


-- 2. Declare uma variável para armazenar um preço e use no WHERE em Production.Product.
DECLARE @VLR MONEY
SET @VLR = 539.99;

SELECT 
	ProductID,
	Name,
	ListPrice
FROM [Production].[Product]
WHERE ListPrice = @VLR


-- 3. Declare uma variável para FirstName e filtre na tabela Person.Person.
DECLARE @NAME VARCHAR(30)
SET @NAME = 'Michael'

SELECT CONCAT(FirstName, ' ', MiddleName, ' ',LastName) AS Compl_Name
FROM [Person].[Person]
WHERE FirstName = @NAME;

-- 4. Atribua o resultado de um COUNT da tabela Person.Person a uma variável.
DECLARE @CONTAGEM INT
SET @CONTAGEM = (SELECT COUNT (*) FROM [Person].[Person])

SELECT @CONTAGEM AS Tot_Linhas;

-- 5. Use uma variável para limitar resultados com TOP.
DECLARE @NUM INT
SET @NUM = 5

SELECT TOP (@NUM) *
FROM [Person].[Person]
ORDER BY BusinessEntityID;

-- -------------------------------
-- ➕ OPERADORES 
-- -------------------------------
-- 1. Liste produtos com preço maior que 100 usando operador de comparação.
SELECT ProductID, ListPrice
FROM [Production].[Product]
WHERE ListPrice > 100.00
ORDER BY ListPrice;

-- 2. Use AND para filtrar produtos com preço maior que 50 e cor não nula.
SELECT ProductID, Name, Color, ListPrice
FROM [Production].[Product]
WHERE ListPrice > 50.00 AND Color IS NOT NULL
ORDER BY ProductID;

-- 3. Use OR para buscar produtos de duas cores diferentes.
SELECT ProductID, Name, Color
FROM [Production].[Product]
WHERE Color = 'Red' OR Color = 'Silver'
ORDER BY ProductID;

-- 4. Concatene FirstName e LastName na tabela Person.Person.
SELECT 
	CONCAT(FirstName,' ', LastName) AS COMP_NAME
FROM [Person].[Person]
ORDER BY COMP_NAME;

-- 5. Use NOT para excluir produtos sem preço definido.
SELECT ProductID, Name, ListPrice
FROM [Production].[Product]
WHERE ListPrice IS NOT NULL AND ListPrice <> 0.00
ORDER BY ProductID;

-- -------------------------------
-- ⚙️ INSTRUÇÕES DINÂMICAS 
-- -------------------------------
-- 1. Crie uma string com SELECT * FROM Person.Person e execute com EXEC.
DECLARE @SQL VARCHAR(50)
SET @SQL = 'SELECT * FROM Person.Person'

EXEC(@SQL);

-- 2. Monte uma query dinâmica simples para Production.Product.
DECLARE @DADOSPROD VARCHAR (100)
SET @DADOSPROD = 'SELECT ProductID, Name, ListPrice FROM Production.Product'

EXEC (@DADOSPROD);

-- 3. Use uma variável para armazenar nome da tabela e montar SELECT.
DECLARE @TABELA VARCHAR(50)
DECLARE @SQL NVARCHAR(MAX)

SET @TABELA = 'Person.Person'

SET @SQL = '
SELECT (FirstName + '' '' + LastName) AS NomeCompleto
FROM ' + @TABELA

EXEC(@SQL);

-- 4. Execute uma query dinâmica filtrando por ProductID.
DECLARE @ProductID INT
DECLARE @SQL NVARCHAR(MAX)

SET @ProductID = 100

SET @SQL = 'SELECT * FROM [Production].[Product] WHERE ProductID = ' 
           + CAST(@ProductID AS NVARCHAR)

EXEC(@SQL);

-- 5. Teste sp_executesql com uma consulta simples sem parâmetros.
DECLARE @QUERY NVARCHAR(100)

SET @QUERY = N'SELECT * FROM Production.Product'

EXEC sp_executesql @QUERY;


-- -------------------------------
-- 🔁 CONTROLE DE FLUXO 
-- -------------------------------
-- 1. Use IF para verificar se existe algum registro em Person.Person.
IF EXISTS (SELECT 1 FROM [Person].[Person])
	PRINT 'Existem registros na tabela.'
ELSE
	PRINT 'A tabela não possui registros'

-- 2. Use IF...ELSE para verificar se há produtos com preço acima de 1000.
IF EXISTS (SELECT 1 FROM [Production].[Product] WHERE ListPrice > 1000)
	PRINT 'EXISTEM PRODUTOS ACIMA DE R$ 1000'
ELSE
	PRINT 'NÃO EXISTEM PRODUTOS ACIMA DE R$ 1000'

-- 3. Crie um WHILE simples que conte de 1 até 5.
DECLARE @CONT INT
SET @CONT = 1

WHILE @CONT <= 5
BEGIN
	SELECT @CONT AS NUMERO
    SET @CONT = @CONT + 1
END

-- 4. Dentro de um WHILE, exiba números usando PRINT.
DECLARE @NUMERO INT
SET @NUMERO = 1

WHILE @NUMERO <= 20
BEGIN
	PRINT @NUMERO
	SET @NUMERO = @NUMERO + 1
END

-- 5. Use BEGIN...END dentro de um IF.
IF (SELECT COUNT(*) FROM [Production].[Product])  > 100
BEGIN
	SELECT TOP 10 ProductID, Name FROM [Production].[Product]
	ORDER BY ProductID
END
ELSE
	PRINT 'Erro!'

IF (SELECT COUNT(*) FROM [Production].[Product])  > 1000
BEGIN
	SELECT TOP 10 ProductID, Name FROM [Production].[Product]
	ORDER BY ProductID
END
ELSE
	PRINT 'Erro!'

-- -------------------------------
-- 📊 GROUP BY 
-- -------------------------------
-- 1. Agrupe produtos por Color e conte quantos existem.
SELECT Color, COUNT(ProductID) AS TotalProducts
FROM [Production].[Product]
GROUP BY Color;

-- 2. Agrupe produtos por SafetyStockLevel.
SELECT SafetyStockLevel, COUNT(*) AS TotalProducts
FROM [Production].[Product]
GROUP BY SafetyStockLevel;

-- 3. Agrupe pessoas por tipo (PersonType) na tabela Person.Person.
SELECT PersonType, COUNT(*) AS QTD_Person
FROM [Person].[Person]
GROUP BY PersonType;

-- 4. Conte quantos produtos existem por classe (Class).
SELECT Class, COUNT(*) AS QTD_Product
FROM [Production].[Product]
WHERE Class IS NOT NULL
GROUP BY Class;

-- 5. Use GROUP BY com HAVING para mostrar grupos com mais de 30 registros.
SELECT Color, COUNT(*) AS QtdProduct
FROM [Production].[Product]
WHERE Color IS NOT NULL
GROUP BY Color
HAVING COUNT(*) > 30
ORDER BY Color;

-- =========================================
