USE [AdventureWorks];
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
-- EX3.: - SQL SERVER (AdventureWorks)
-- =========================================
-- Considere tabelas como:
-- Person.Person
-- Sales.Customer
-- Sales.SalesOrderHeader
-- Sales.SalesOrderDetail
-- Production.Product
-- Sales.SalesTerritory
-- =========================================

-- 1. Liste a quantidade de clientes por território (SalesTerritory).
SELECT 
    ST.TerritoryID,
    ST.Name AS TerritoryName,
    COUNT(SC.CustomerID) AS Clients
FROM [Sales].[Customer] SC
JOIN [Sales].[SalesTerritory] ST ON SC.TerritoryID = ST.TerritoryID
GROUP BY ST.TerritoryID, ST.Name;

-- 2. Calcule o total de pedidos por cliente.
SELECT SC.CustomerID, COUNT(*) AS TotPed
FROM [Sales].[SalesOrderHeader] SO
JOIN [Sales].[Customer] SC ON SO.CustomerID = SC.CustomerID
GROUP BY SC.CustomerID;

-- 3. Mostre o valor total de vendas por cliente.
SELECT CustomerID, SUM(TotalDue) AS Total_Vendas
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY Total_Vendas DESC;

-- 4. Liste a média de valor dos pedidos por cliente.
SELECT CustomerID, AVG(TotalDue) AS MedPed
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY MedPed;


-- 5. Exiba a quantidade de pedidos por ano.
SELECT 
    YEAR(OrderDate) AS Ano,
    COUNT(*) AS TOT_PED
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY Ano;

-- 6. Faça um INNER JOIN entre Customer e Person mostrando nome do cliente.
SELECT 
    SC.PersonID, 
    CONCAT(PP.FirstName, ' ',PP.LastName) AS FullName
FROM [Sales].[Customer] SC
JOIN [Person].[Person] PP ON SC.PersonID = PP.BusinessEntityID
ORDER BY SC.PersonID;

-- 7. Liste todos os clientes e seus pedidos (incluindo clientes sem pedidos).
SELECT
    SC.CustomerID, 
    SO.SalesOrderID
FROM [Sales].[Customer] SC
LEFT JOIN [Sales].[SalesOrderHeader] SO ON SC.CustomerID = SO.CustomerID
ORDER BY SC.CustomerID;

-- 8. Liste todos os pedidos e seus clientes (incluindo pedidos sem cliente).
SELECT 
    SO.SalesOrderID,
    SC.CustomerID
FROM [Sales].[SalesOrderHeader] SO
LEFT JOIN [Sales].[Customer] SC ON SC.CustomerID = SO.CustomerID
ORDER BY SO.SalesOrderID;

-- 9. Mostre todos os clientes e pedidos, mesmo sem correspondência (FULL JOIN).
SELECT 
    SC.CustomerID,
    SO.SalesOrderID
FROM [Sales].[SalesOrderHeader] SO
FULL JOIN [Sales].[Customer] SC 
    ON SO.CustomerID = SC.CustomerID
ORDER BY COALESCE(SC.CustomerID, SO.CustomerID);

-- 10. Gere todas as combinações possíveis entre Product e SalesTerritory (CROSS JOIN).
--SELECT *
--FROM [Production].[Product]
--CROSS JOIN [Sales].[SalesTerritory];

SELECT 
    P.ProductID,
    P.Name,
    ST.TerritoryID,
    ST.Name AS TerritoryName
FROM [Production].[Product] P
CROSS JOIN [Sales].[SalesTerritory] ST;


-- 11. Calcule o total de produtos vendidos por produto.
-- 12. Mostre o faturamento total por produto.
-- 13. Liste o total de vendas por território.
-- 14. Mostre a quantidade de produtos diferentes por pedido.
-- 15. Exiba o maior valor de pedido por cliente.

-- 16. Liste clientes que fizeram mais de 10 pedidos (usar GROUP BY + HAVING).
-- 17. Mostre produtos com média de quantidade vendida maior que 5.
-- 18. Liste territórios com total de vendas acima de 1.000.000.
-- 19. Mostre o total de pedidos por cliente, incluindo apenas os que têm pedidos.
-- 20. Exiba clientes e o total gasto, ordenando do maior para o menor.