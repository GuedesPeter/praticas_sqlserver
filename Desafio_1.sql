USE AdventureWorks;
GO

/*
-------------------------------------------------------------------------------------------
AdventureWorks - SUMÁRIO:

-- Person.Person           → Pessoa
-- Sales.Customer           → Cliente
-- Sales.SalesOrderHeader   → Cabeçalho do Pedido
-- Sales.SalesOrderDetail   → Detalhes do Pedido
-- Production.Product       → Produto
-- Production.ProductSubcategory → Subcategoria de Produto
-- Production.ProductCategory    → Categoria de Produto
-- Production.ProductInventory   → Estoque de Produto
-- HumanResources.Employee       → Funcionário
-- Sales.Store                   → Loja
-- Sales.SalesPerson             → Vendedor
-- Sales.SalesTerritory          → Território de Vendas
-- Person.Address                → Endereço
-- Person.StateProvince          → Estado/Província
-- Person.CountryRegion          → País/Região
-- HumanResources.Department      → Departamento
-- HumanResources.Shift           → Turno
-- HumanResources.EmployeeDepartmentHistory → Histórico Departamento do Funcionário
-- Production.Location            → Localização
-- Production.WorkOrder           → Ordem de Produção
-- Production.TransactionHistory  → Histórico de Transações
-- Production.UnitMeasure         → Unidade de Medida
-- Production.BillOfMaterials     → Lista de Materiais
-- Sales.SalesTaxRate             → Taxa de Imposto
-- Sales.SalesTerritoryHistory    → Histórico do Território de Vendas
-- Purchasing.Vendor              → Fornecedor
-- Purchasing.PurchaseOrderHeader → Cabeçalho da Ordem de Compra
-- Purchasing.PurchaseOrderDetail → Detalhe da Ordem de Compra
-- Purchasing.ProductVendor       → Produto do Fornecedor
-------------------------------------------------------------------------------------------
*/

-- =========================================
-- DESAFIO 1 - SQL SERVER (AdventureWorks) 
-- PRÁTICAS E DESENVOLVIMENTO
-- =========================================

-- EXERCÍCIO 1
-- Verifique o valor de SalesYTD de um vendedor.
-- Se for maior que 3.000.000 → "Alto desempenho"
-- Entre 1.000.000 e 3.000.000 → "Desempenho médio"
-- Caso contrário → "Baixo desempenho"

DECLARE @ID INT
SET @ID = 275

IF (SELECT SalesYTD 
    FROM Sales.SalesPerson 
    WHERE BusinessEntityID = @ID) > 3000000 
BEGIN
    PRINT 'Alto desempenho';
END
ELSE IF (SELECT SalesYTD 
         FROM Sales.SalesPerson 
         WHERE BusinessEntityID = @ID) BETWEEN 1000000 AND 3000000
BEGIN
    PRINT 'Desempenho médio';
END
ELSE
BEGIN
    PRINT 'Baixo desempenho';
END

-- Tratando NULL e repetições
DECLARE @ID INT = 274;
DECLARE @SalesYTD MONEY;

SELECT @SalesYTD = SalesYTD
FROM Sales.SalesPerson
WHERE BusinessEntityID = @ID;

IF @SalesYTD IS NULL
BEGIN
    PRINT 'Vendedor não encontrado';
END
ELSE IF @SalesYTD > 3000000
BEGIN
    PRINT 'Alto desempenho';
END
ELSE IF @SalesYTD BETWEEN 1000000 AND 3000000
BEGIN
    PRINT 'Desempenho médio';
END
ELSE
BEGIN
    PRINT 'Baixo desempenho';
END

------------------------------------------------------------

-- EXERCÍCIO 2
-- Receba um ProductID e verifique o ListPrice.
-- Se maior que 1000 → "Produto Premium"
-- Caso contrário → "Produto comum"

DECLARE @ID INT = 706;
DECLARE @SQL MONEY


SELECT @SQL = ListPrice
FROM [Production].[Product]
WHERE ProductID = @ID;

IF @SQL IS NULL
BEGIN
    PRINT 'Valor não encontrado!';
END
ELSE IF @SQL > 1000
BEGIN
    PRINT 'Produto Premium';
END
ELSE
BEGIN
    PRINT 'Produto Comum';
END


------------------------------------------------------------

-- EXERCÍCIO 3
-- Verifique a quantidade de pedidos (SalesOrderID) de um cliente.
-- Se > 50 → "Cliente frequente"
-- Caso contrário → "Cliente ocasional"

DECLARE @CLI INT = 29825
DECLARE @ORDER INT

SELECT @ORDER = COUNT(SalesOrderID)
FROM [Sales].[SalesOrderHeader]
WHERE CustomerID = @CLI

IF @ORDER = 0
BEGIN
    PRINT 'Cliente sem pedidos.';;
END
ELSE IF @ORDER > 50
BEGIN
    PRINT 'Cliente frequente';
END
ELSE
BEGIN
    PRINT 'Cliente ocasional';
END


------------------------------------------------------------

-- EXERCÍCIO 4
-- Verifique se um produto possui Weight NULL.
-- Se for NULL → "Peso não informado"
-- Caso contrário → "Peso disponível"

DECLARE @ID INT = 29825
DECLARE @WEIGHT DECIMAL

SELECT @WEIGHT = Weight
FROM [Production].[Product]
WHERE ProductID = @ID;

IF @WEIGHT IS NULL AND NOT EXISTS (
    SELECT 1 FROM [Production].[Product] WHERE ProductID = @ID
)
BEGIN
    PRINT 'Peso não informado';
END
ELSE
BEGIN
    PRINT 'Peso disponível';
END

------------------------------------------------------------

-- EXERCÍCIO 5
-- Verifique se o ano do OrderDate é anterior a 2013.
-- Se sim → "Pedido antigo"
-- Caso contrário → "Pedido recente"

DECLARE @ORDERID INT = 43660
DECLARE @ORDERYEAR INT 

-- Op.1
SELECT @ORDERYEAR = YEAR(OrderDate) -- [Função YEAR converte o ano para INT]
FROM [Sales].[SalesOrderHeader]
WHERE SalesOrderID = @ORDERID

IF @ORDERYEAR IS NULL
BEGIN
    PRINT 'ERRO';
END
ELSE IF @ORDERYEAR < 2013
BEGIN 
    PRINT 'Pedido antigo';
END
ELSE
BEGIN
    PRINT 'Pedido recente';
END

-- Op.2
DECLARE @ORDERID INT = 69730;
DECLARE @ORDERDATE DATETIME;

SELECT @ORDERDATE = OrderDate
FROM [Sales].[SalesOrderHeader]
WHERE SalesOrderID = @ORDERID;

IF @ORDERDATE IS NULL
BEGIN
    PRINT 'ERRO';
END
ELSE IF @ORDERDATE < '2013-01-01'
BEGIN 
    PRINT 'Pedido antigo';
END
ELSE
BEGIN
    PRINT 'Pedido recente';
END


-- EXERCÍCIO 6
-- Liste produtos ordenando por ListPrice crescente.

SELECT ProductID,Name, ListPrice
FROM [Production].[Product]
ORDER BY ListPrice;

------------------------------------------------------------

-- EXERCÍCIO 7
-- Liste clientes ordenando por LastName decrescente.
SELECT C.PersonID,CONCAT(P.FirstName,' ',P.LastName) AS FullName
FROM [Sales].[Customer] C
JOIN [Person].[Person] P ON C.PersonID = P.BusinessEntityID
ORDER BY P.LastName DESC;

------------------------------------------------------------

-- EXERCÍCIO 8
-- Liste pedidos ordenando por OrderDate mais recente primeiro.
SELECT SalesOrderID, CAST(OrderDate AS DATE) AS OrderDateOnly
FROM [Sales].[SalesOrderHeader]
ORDER BY OrderDateOnly DESC;


------------------------------------------------------------

-- EXERCÍCIO 9
-- Liste produtos ordenando por preço (desc) e nome (asc).
SELECT Name, ListPrice
FROM [Production].[Product]
ORDER BY ListPrice DESC, Name ASC;

------------------------------------------------------------

-- EXERCÍCIO 10
-- Liste funcionários ordenando por HireDate e depois por JobTitle.
SELECT BusinessEntityID, HireDate, JobTitle
FROM [HumanResources].[Employee]
ORDER BY HireDate, JobTitle;

-- EXERCÍCIO 11
-- Conte quantos produtos existem por ProductSubcategoryID.
SELECT ProductSubcategoryID,COUNT(*) AS QtProd
FROM [Production].[Product]
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

------------------------------------------------------------

-- EXERCÍCIO 12
-- Agrupe pedidos por CustomerID e conte quantos cada cliente possui.
SELECT CustomerID, COUNT(SalesOrderID) AS QtSales
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID;


------------------------------------------------------------

-- EXERCÍCIO 13
-- Agrupe vendas por TerritoryID e calcule o total de pedidos.
SELECT TerritoryID, SUM(TotalDue) AS TotSales
FROM [Sales].[SalesOrderHeader]
GROUP BY TerritoryID
ORDER BY TerritoryID;


------------------------------------------------------------

-- EXERCÍCIO 14
-- Agrupe produtos por Color e conte quantos existem de cada cor.

-- Op.1 - NULL
SELECT Color, COUNT(*) AS QtProd
FROM [Production].[Product]
GROUP BY Color
ORDER BY QtProd;

-- Op.2 - NOT NULL
SELECT Color, COUNT(*) AS QtProd
FROM [Production].[Product]
WHERE Color IS NOT NULL AND Color <> ''
GROUP BY Color
ORDER BY QtProd;

------------------------------------------------------------

-- EXERCÍCIO 15
-- Agrupe pedidos por ano (OrderDate) usando funções de data.

-- Op.1
SELECT 
    YEAR(OrderDate) AS YearOrder,
    COUNT(*) AS QtSales
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY YearOrder;

-- Op.2
SELECT 
    COUNT(SalesOrderID) QtSales, 
    YEAR(OrderDate) YearOrder
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY YearOrder;

-- EXERCÍCIO 16
-- Calcule o preço médio dos produtos.
SELECT AVG(ListPrice) AS Vl_Prod_Med
FROM [Production].[Product]
WHERE ListPrice IS NOT NULL AND ListPrice <> 0;

------------------------------------------------------------

-- EXERCÍCIO 17
-- Encontre o maior e o menor ListPrice.
SELECT
    MAX(ListPrice) AS MaxVL,
    MIN(ListPrice) As MinVL
FROM [Production].[Product]
WHERE ListPrice > 0;


------------------------------------------------------------

-- EXERCÍCIO 18
-- Some o TotalDue de todos os pedidos.
SELECT SUM(TotalDue) AS Soma_total
FROM [Sales].[SalesOrderHeader]
WHERE TotalDue > 0;

------------------------------------------------------------

-- EXERCÍCIO 19
-- Conte o número total de clientes.

SELECT COUNT(CustomerID) AS TotCli
FROM [Sales].[Customer];

SELECT COUNT(*) AS TotCli
FROM [Sales].[Customer];

------------------------------------------------------------

-- EXERCÍCIO 20
-- Calcule a média de dias entre OrderDate e ShipDate.
SELECT 
    AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS Media_Dias
FROM [Sales].[SalesOrderHeader]
WHERE ShipDate IS NOT NULL;
/*
 ---------- Dica importante ----------

Sempre que o problema envolver:

- “diferença entre datas” → use DATEDIFF
- “média” → use AVG
- “por linha” → evite variáveis, use direto na tabela

*/
----------------------------------------------------------
--************************ EXTRAS ************************
----------------------------------------------------------
-- Extra 1
-- Calcule a quantidade de dias entre OrderDate e ShipDate para cada pedido.
-- Exiba: SalesOrderID, OrderDate, ShipDate e a diferença em dias.
SELECT 
    SalesOrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(DAY, OrderDate, ShipDate) DIF_Days
FROM [Sales].[SalesOrderHeader]
WHERE ShipDate IS NOT NULL;

-- Extra 2
-- Liste os pedidos onde o tempo entre OrderDate e ShipDate foi maior que 7 dias.
-- Exiba: SalesOrderID, datas e a diferença em dias.
--Op1
SELECT
    SalesOrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(DAY, OrderDate, ShipDate) AS DIF_Days
FROM [Sales].[SalesOrderHeader]
WHERE DATEDIFF(DAY, OrderDate, ShipDate) > 7;

--Op2
WITH Pedidos AS (
    SELECT
        SalesOrderID,
        OrderDate,
        ShipDate,
        DATEDIFF(DAY, OrderDate, ShipDate) AS DIF_Days
    FROM [Sales].[SalesOrderHeader]
)
SELECT *
FROM Pedidos
WHERE DIF_Days > 7;


-- Extra 3
-- Calcule a média de dias entre OrderDate e DueDate (prazo) para todos os pedidos.
-- Considere apenas registros com DueDate não nulo.
SELECT 
    AVG(DATEDIFF(DAY, OrderDate, DueDate)) AS Media_Dias
FROM [Sales].[SalesOrderHeader]
WHERE DueDate IS NOT NULL;


-- Extra 4
-- Encontre o pedido com o maior tempo (em dias) entre OrderDate e ShipDate.
-- Exiba o SalesOrderID e a diferença de dias.
WITH PED AS (
    SELECT
        SalesOrderID,
        DATEDIFF(DAY, OrderDate, ShipDate) AS MaxTime
    FROM [Sales].[SalesOrderHeader]
    WHERE ShipDate IS NOT NULL
)
SELECT TOP 1 *
FROM PED
ORDER BY MaxTime DESC;
/*
Conceito-chave
MAX() → retorna o maior valor
TOP 1 ... ORDER BY DESC → retorna a linha completa com o maior valor

👉 Quando o exercício pede “o registro”, quase sempre TOP + ORDER BY é o caminho.
*/
--Op2
SELECT TOP 1
    SalesOrderID,
    DATEDIFF(DAY, OrderDate, ShipDate) AS MaxTime
FROM [Sales].[SalesOrderHeader]
WHERE ShipDate IS NOT NULL
ORDER BY MaxTime DESC;

-- Extra 5
-- Calcule o tempo (em dias) entre a primeira e a última compra de cada cliente.
-- Exiba: CustomerID e a diferença de dias entre MIN(OrderDate) e MAX(OrderDate).
-- Ordene do maior para o menor intervalo.
SELECT 
    CustomerID,
    DATEDIFF(
        DAY,
        MIN(OrderDate), --→ primeira compra
        MAX(OrderDate) --→ última compra
    ) AS DIF
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY DIF DESC;

/*
🚀 Regra de ouro

👉 Se o enunciado diz:

    “de cada cliente”

👉 Sempre precisa de:

    GROUP BY CustomerID
*/

------------------------------------------------------------

-- EXERCÍCIO 21
-- Crie um script com duas partes separadas por GO:
-- 1ª parte: declarar variável e atribuir valor
DECLARE @ID INT;
SET @ID = 16350;
GO
-- 2ª parte: utilizar a variável em uma consulta
DECLARE @ID INT -- Redeclarar pois é encerrada após o GO acima
SET @ID = 16350;

SELECT 
    CustomerID,
    DATEDIFF(
        DAY,
        MIN(OrderDate),
        MAX(OrderDate)
    ) AS DIF
FROM [Sales].[SalesOrderHeader]
WHERE CustomerID = @ID
GROUP BY CustomerID;
GO

------------------------------------------------------------

-- EXERCÍCIO 22
-- Crie uma tabela temporária em um batch
-- e tente utilizá-la em outro batch separado

SELECT 
    ProductID,
    Name,
    Color,
    ProductSubcategoryID
INTO #TempProduct
FROM [Production].[Product]
GO

SELECT TOP 10 *
FROM #TempProduct
GO

------------------------------------------------------------

-- EXERCÍCIO 23
-- Declare variáveis em um batch e teste sua visibilidade após GO

-- 1ª parte
DECLARE @FirstName NVARCHAR(50) = 'Gigi';
DECLARE @MiddleName NVARCHAR(50) = 'N';
DECLARE @LastName NVARCHAR(50) = 'Matthew';
GO

-- 2ª parte (isso vai dar erro propositalmente)
SELECT 
    @FirstName,
    @MiddleName,
    @LastName
FROM [Person].[Person];

-- 👉 Resultado esperado: elas NÃO existem após GO

------------------------------------------------------------

-- EXERCÍCIO 24
-- Crie um procedimento armazenado em um batch separado
CREATE PROCEDURE sp_SaleDetail
    @IdProduto INT
AS
BEGIN
    SELECT 
        S.SalesOrderID AS IdVenda,
        S.ProductID AS IdProduto,
        P.Name AS Produto,
        S.OrderQty AS Qtde,
        S.UnitPrice AS VlUnidade,
        S.LineTotal AS Tot_VlPago
    FROM [Sales].[SalesOrderDetail] S
    JOIN [Production].[Product] P 
        ON S.ProductID = P.ProductID
    WHERE S.ProductID = @IdProduto;
END;
GO

DROP PROCEDURE sp_SaleDetail


------------------------------------------------------------

-- EXERCÍCIO 25
-- Teste múltiplos comandos separados por GO simulando execução em etapas

SELECT
    ProductID,
    Name,
    Color,
    ProductSubcategoryID
INTO #Aux_Product
FROM [Production].[Product];
GO

SELECT * 
FROM #Aux_Product
WHERE Color LIKE '%Black%';
GO


-- EXERCÍCIO 26
-- Use operadores aritméticos para calcular desconto sobre ListPrice.
DECLARE @ID INT = 999

SELECT 
    ProductID,
    Name,
    (ListPrice - (ListPrice * 10/100)) AS Desconto
FROM [Production].[Product]
WHERE ProductID = @ID

------------------------------------------------------------

-- EXERCÍCIO 27
-- Use operadores de comparação para filtrar produtos com preço > 500.
SELECT 
    ProductID,
    Name
FROM [Production].[Product]
WHERE ListPrice > 500;


------------------------------------------------------------

-- EXERCÍCIO 28
-- Use operadores lógicos (AND/OR) para filtrar produtos por cor e preço.

SELECT
    ProductID,
    Name,
    ListPrice
FROM [Production].[Product]
WHERE ListPrice > 500 AND Color LIKE '%Black%';

SELECT
    ProductID,
    Name,
    ListPrice
FROM [Production].[Product]
WHERE ListPrice <= 500 OR Color LIKE '%Red%';


------------------------------------------------------------

-- EXERCÍCIO 29
-- Use operador LIKE para buscar nomes que contenham 'Bike'.
SELECT
    ProductID,
    Name
FROM [Production].[Product]
WHERE Name LIKE '%Bike%'
ORDER BY ProductID;

------------------------------------------------------------

-- EXERCÍCIO 30
-- Use operador IN para filtrar múltiplos ProductID.
SELECT 
    *
INTO #DetalhesVenda
FROM [Sales].[SalesOrderDetail];
GO

-- IN
SELECT 
    ProductID,
    Name
FROM [Production].[Product]
WHERE ProductID IN (
    SELECT ProductID FROM #DetalhesVenda
);

-- NOT IN
SELECT 
    ProductID,
    Name
FROM [Production].[Product]
WHERE ProductID NOT IN (
    SELECT ProductID FROM #DetalhesVenda
);

--************************************************************************
-- BONUS
--************************************************************************

-- EXERCÍCIO 1 - IF / ELSE
-- Contexto: Controle de bônus de vendedores
-- Enunciado:
-- Crie um script que verifique o total de vendas (SalesYTD) de um vendedor na tabela Sales.SalesPerson.
-- Se o valor for maior que 2.000.000, exiba a mensagem "Bônus máximo".
-- Caso esteja entre 1.000.000 e 2.000.000, exiba "Bônus médio".
-- Caso contrário, exiba "Sem bônus".

DECLARE @TotVendas MONEY
DECLARE @Vendedor INT = 280

SELECT @TotVendas = SalesYTD
FROM [Sales].[SalesPerson]
WHERE BusinessEntityID = @Vendedor
AND SalesYTD IS NOT NULL;

IF @TotVendas > 2000000
BEGIN
    PRINT 'BONUS MÁXIMO';
END
ELSE IF @TotVendas BETWEEN 1000000 AND 2000000
BEGIN
    PRINT 'BONUS MÉDIO';
END
ELSE
BEGIN
    PRINT 'SEM BONUS';
END

------------------------------------------------------------

-- EXERCÍCIO 2 - ORDER BY
-- Contexto: Ordenação de produtos
-- Enunciado:
-- Liste os produtos da tabela Production.Product mostrando Name, ListPrice e SellStartDate.
-- Ordene os resultados primeiro pelo preço (decrescente) e, em caso de empate,
-- pela data de início de venda (mais antiga primeiro).

SELECT
    Name,
    ListPrice,
    SellStartDate
FROM [Production].[Product]
ORDER BY ListPrice DESC, SellStartDate;


------------------------------------------------------------

-- EXERCÍCIO 3 - GROUP BY
-- Contexto: Análise por território
-- Enunciado:
-- Agrupe os registros da tabela Sales.SalesOrderHeader por TerritoryID.
-- Exiba o total de pedidos por território.
-- Considere apenas pedidos realizados após o ano de 2012.

SELECT
    S.TerritoryID As ID,
    T.Name AS Territorio,
    COUNT(S.SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader] S
JOIN [Sales].[SalesTerritory] T ON S.TerritoryID = T.TerritoryID
WHERE YEAR(OrderDate) > 2012
GROUP BY S.TerritoryID,T.Name
ORDER BY ID;

------------------------------------------------------------

-- EXERCÍCIO 4 - FUNÇÕES DE AGREGAÇÃO
-- Contexto: Estatísticas de preço
-- Enunciado:
-- Calcule o preço médio, o maior preço e o menor preço dos produtos da tabela Production.Product.
-- Considere apenas produtos ativos (SellEndDate NULL).

SELECT 
    AVG(ListPrice) AS PrecoMedio,
    MAX(ListPrice) AS MaiorPreco,
    MIN(ListPrice) AS MenorPreco
FROM [Production].[Product]
WHERE SellEndDate IS NULL;

-- SEM VALOR ZERADO
SELECT 
    AVG(ListPrice) AS PrecoMedio,
    MAX(ListPrice) AS MaiorPreco,
    MIN(ListPrice) AS MenorPreco
FROM [Production].[Product]
WHERE SellEndDate IS NULL
AND ListPrice > 0;


------------------------------------------------------------

-- EXERCÍCIO 5 - BATCH + OPERADORES + INSTRUÇÕES DINÂMICAS
-- Contexto: Execução dinâmica de consulta
-- Enunciado:
-- Crie um script que utilize variáveis para montar dinamicamente uma consulta SQL.
-- A consulta deve retornar produtos com preço maior que um valor informado.
-- Utilize EXEC ou sp_executesql.
-- Separe o script em batches utilizando GO.
-- Inclua operadores de comparação na construção da query dinâmica.


--************************************************************************
-- VARIADOS
--************************************************************************

-- EXERCÍCIO 1 - CONVERT (Formatação de datas)
-- Contexto:
-- A equipe de relatórios precisa padronizar a exibição de datas no formato brasileiro.
-- Enunciado:
-- Consulte a tabela Sales.SalesOrderHeader e retorne as colunas SalesOrderID e OrderDate.
-- Converta a data OrderDate para o formato DD/MM/YYYY utilizando CONVERT.
-- Nomeie a coluna formatada como DataFormatada.

------------------------------------------------------------

-- EXERCÍCIO 2 - FORMAT (Formatação monetária)
-- Contexto:
-- O departamento financeiro deseja visualizar valores monetários formatados.
-- Enunciado:
-- Liste SalesOrderID e TotalDue da tabela Sales.SalesOrderHeader.
-- Utilize FORMAT para exibir o TotalDue no formato de moeda brasileira (R$).

------------------------------------------------------------

-- EXERCÍCIO 3 - COALESCE (Tratamento de NULL)
-- Contexto:
-- Alguns clientes não possuem MiddleName cadastrado.
-- Enunciado:
-- Consulte a tabela Person.Person e exiba FirstName, MiddleName e LastName.
-- Utilize COALESCE para substituir valores NULL de MiddleName por 'Não informado'.

------------------------------------------------------------

-- EXERCÍCIO 4 - STR (Conversão numérica para texto)
-- Contexto:
-- Um sistema legado exige valores numéricos como texto.
-- Enunciado:
-- Consulte Production.Product e retorne Name e ListPrice.
-- Converta o ListPrice para texto usando STR, com 2 casas decimais.

------------------------------------------------------------

-- EXERCÍCIO 5 - CONCAT (Junção de campos)
-- Contexto:
-- Criar nome completo para exibição em relatórios.
-- Enunciado:
-- Na tabela Person.Person, concatene FirstName, MiddleName e LastName.
-- Trate possíveis NULLs para evitar espaços extras.

------------------------------------------------------------

-- EXERCÍCIO 6 - UPPER / LOWER (Padronização de texto)
-- Contexto:
-- O sistema exige padronização de dados textuais.
-- Enunciado:
-- Consulte Production.Product e exiba Name em maiúsculo e minúsculo.

------------------------------------------------------------

-- EXERCÍCIO 7 - LEN (Tamanho de texto)
-- Contexto:
-- Analisar tamanho de nomes de produtos.
-- Enunciado:
-- Retorne Name e o tamanho do nome utilizando LEN.

------------------------------------------------------------

-- EXERCÍCIO 8 - SUBSTRING (Extração de texto)
-- Contexto:
-- Criar códigos abreviados de produtos.
-- Enunciado:
-- Extraia os primeiros 4 caracteres do campo Name da tabela Production.Product.

------------------------------------------------------------

-- EXERCÍCIO 9 - DATEPART (Extração de partes da data)
-- Contexto:
-- Relatórios por período.
-- Enunciado:
-- Extraia o ano e o mês da coluna OrderDate na tabela Sales.SalesOrderHeader.

------------------------------------------------------------

-- EXERCÍCIO 10 - DATEDIFF (Diferença entre datas)
-- Contexto:
-- Medir tempo de entrega.
-- Enunciado:
-- Calcule a diferença em dias entre OrderDate e ShipDate.

------------------------------------------------------------

-- EXERCÍCIO 11 - ISNULL (Substituição de NULL)
-- Contexto:
-- Alguns produtos não possuem peso informado.
-- Enunciado:
-- Substitua valores NULL da coluna Weight por 0 na tabela Production.Product.

------------------------------------------------------------

-- EXERCÍCIO 12 - CAST (Conversão de tipo)
-- Contexto:
-- Simplificar valores para análise.
-- Enunciado:
-- Converta ListPrice para inteiro usando CAST.

------------------------------------------------------------

-- EXERCÍCIO 13 - ROUND (Arredondamento)
-- Contexto:
-- Ajustar valores monetários.
-- Enunciado:
-- Arredonde ListPrice para 1 casa decimal.

------------------------------------------------------------

-- EXERCÍCIO 14 - CEILING e FLOOR (Arredondamentos específicos)
-- Contexto:
-- Simular cenários de arredondamento.
-- Enunciado:
-- Aplique CEILING (para cima) e FLOOR (para baixo) sobre ListPrice.

------------------------------------------------------------

-- EXERCÍCIO 15 - CASE (Classificação)
-- Contexto:
-- Classificação de produtos por preço.
-- Enunciado:
-- Classifique produtos como:
-- Até 100 → 'Barato'
-- 101 a 1000 → 'Intermediário'
-- Acima de 1000 → 'Caro'

------------------------------------------------------------

-- EXERCÍCIO 16 - LIKE (Busca textual)
-- Contexto:
-- Pesquisa de produtos.
-- Enunciado:
-- Liste produtos cujo nome contenha a palavra 'Road'.

------------------------------------------------------------

-- EXERCÍCIO 17 - IN (Filtro múltiplo)
-- Contexto:
-- Filtrar registros específicos.
-- Enunciado:
-- Consulte Sales.SalesOrderHeader filtrando múltiplos CustomerID.

------------------------------------------------------------

-- EXERCÍCIO 18 - BETWEEN (Intervalos)
-- Contexto:
-- Filtrar produtos por faixa de preço.
-- Enunciado:
-- Liste produtos com preço entre 200 e 800.

------------------------------------------------------------

-- EXERCÍCIO 19 - JOIN (Relacionamento)
-- Contexto:
-- Relacionar clientes e pedidos.
-- Enunciado:
-- Faça um JOIN entre Sales.Customer e Sales.SalesOrderHeader.
-- Exiba CustomerID e SalesOrderID.

------------------------------------------------------------

-- EXERCÍCIO 20 - HAVING (Filtro em agregação)
-- Contexto:
-- Identificar clientes com alta atividade.
-- Enunciado:
-- Agrupe pedidos por CustomerID e exiba apenas clientes com mais de 10 pedidos.
