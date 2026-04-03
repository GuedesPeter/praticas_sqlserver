USE [AdventureWorks];

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


===========================================================
20 EXERCÍCIOS DE SQL SERVER (BANCO: ADVENTUREWORKS)
===========================================================
*/

--1. Liste todos os clientes (Person.Person) exibindo FirstName, LastName e BusinessEntityID.

SELECT FirstName, LastName, BusinessEntityID FROM Person.Person
ORDER BY FirstName;

SELECT CONCAT(FirstName, ' ', LastName) AS FullName, BusinessEntityID FROM Person.Person
ORDER BY FullName;

--2. Mostre os 10 produtos mais caros da tabela Production.Product, ordenados do maior para o menor preço.

SELECT TOP 10 ListPrice, Name
FROM Production.Product
ORDER BY ListPrice DESC, Name ASC;

--3. Liste todos os produtos que têm preço (ListPrice) maior que 1000.

SELECT DISTINCT Name, ListPrice
FROM Production.Product
WHERE ListPrice > 1000;

--4. Conte quantos produtos existem na tabela Production.Product.


SELECT COUNT(*) AS TotalProdutos 
FROM Production.Product;

--5. Exiba o preço médio (ListPrice) dos produtos.

SELECT AVG(ListPrice) AS PrecoMedio
FROM Production.Product;

--6. Liste todos os pedidos (Sales.SalesOrderHeader) com OrderDate no ano de 2013.

SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01' AND OrderDate < '2014-01-01';

--7. Mostre o total de pedidos por cliente (CustomerID) na tabela Sales.SalesOrderHeader.

SELECT COUNT(CustomerID) Tot_Ped FROM SalesOrderHeader;

--8. Liste os funcionários (HumanResources.Employee) com seu JobTitle.

SELECT CONCAT(PP.FirstName,' ',PP.LastName) EmployeeName, HE.JobTitle
FROM HumanResources.Employee HE
JOIN Person.Person PP ON PP.BusinessEntityID = HE.BusinessEntityID
ORDER BY EmployeeName ASC;


--9. Exiba todos os produtos com seus respectivos nomes de subcategoria (Production.ProductSubcategory).

SELECT PP.Name ProductName, PS.Name Subcategory 
FROM Production.Product PP
JOIN Production.ProductSubcategory PS ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
ORDER BY ProductName;

--10. Liste os produtos que nunca foram vendidos (sem registros em Sales.SalesOrderDetail).

SELECT PP.ProductID, PP.Name FROM Production.Product PP
JOIN Sales.SalesOrderDetail SS ON SS.ProductID = PP.ProductID
WHERE PP.ProductID NOT IN (SELECT ProductID FROM Sales.SalesOrderDetail);

--11. Mostre o total de vendas (TotalDue) por mês na tabela Sales.SalesOrderHeader.

SELECT 
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    SUM(TotalDue) AS Total
FROM Sales.SalesOrderHeader
GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY 
    OrderYear,
    OrderMonth;


--12. Liste os 5 clientes que mais gastaram (maior soma de TotalDue).

SELECT TOP 5 PP.FirstName,
SUM(SO.TotalDue) Vl_Total FROM Sales.SalesOrderHeader SO
JOIN Sales.Store SS ON SS.SalesPersonID = SO.SalesPersonID
JOIN Person.Person PP ON PP.BusinessEntityID = SS.BusinessEntityID
GROUP BY PP.FirstName, SO.TotalDue
ORDER BY SO.TotalDue DESC;


--13. Exiba todos os produtos com estoque abaixo de 50 unidades (Production.ProductInventory).

SELECT PP.Name, PI. Quantity FROM Production.ProductInventory PI
JOIN Production.Product PP ON PP.ProductID = PI.ProductID
WHERE PI.Quantity < 50
ORDER BY PP.Name;


--14. Liste o nome completo dos clientes concatenando FirstName e LastName.

SELECT CONCAT(FirstName,' ',LastName) AS NAME FROM Person.Person
ORDER BY NAME;

SELECT (FirstName +' '+LastName) AS NAME FROM Person.Person
ORDER BY NAME;

-- 15. Mostre todos os pedidos junto com o nome do cliente
-- (SalesOrderHeader, Customer e Person/Store)
SELECT 
    SO.SalesOrderID,
    COALESCE(P.FirstName + ' ' + P.LastName, SS.Name) AS CustomerName
FROM Sales.SalesOrderHeader SO
JOIN Sales.Customer SC 
    ON SC.CustomerID = SO.CustomerID
LEFT JOIN Person.Person P 
    ON P.BusinessEntityID = SC.PersonID
LEFT JOIN Sales.Store SS 
    ON SS.BusinessEntityID = SC.StoreID
ORDER BY CustomerName;



--16. Liste os produtos que possuem a palavra 'Bike' no nome.

SELECT [ProductID],[Name],[ListPrice] FROM [Production].[Product] PP
WHERE PP.Name LIKE '%bIKE%';


--17. Exiba o maior, menor e média de preços dos produtos.

SELECT MAX(ListPrice) MaxPrice,
MIN(ListPrice) MinPrice,
AVG(ListPrice) AvgPrice
FROM [Production].[Product];

--18. Liste os pedidos feitos entre duas datas específicas (use BETWEEN).

SELECT PP.Name, CAST(PP.SellStartDate AS DATE)SellStartDate, CAST(PP.SellEndDate AS DATE)SellEndDate
FROM [Production].[Product] PP
WHERE PP.SellStartDate BETWEEN '01-01-2011' AND '01-01-2014'
AND PP.SellEndDate IS NOT NULL;

--19. Mostre o total de itens vendidos por produto (Sales.SalesOrderDetail).

SELECT SUM(OrderQty) AS Tot_Items FROM [Sales].[SalesOrderDetail]

--20. Liste os clientes que não realizaram nenhum pedido.
SELECT *
FROM Sales.Customer C
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader SO
    WHERE SO.CustomerID = C.CustomerID
);

-- LEFT JOIN

SELECT C.*
FROM Sales.Customer C
LEFT JOIN Sales.SalesOrderHeader SO
    ON SO.CustomerID = C.CustomerID
WHERE SO.CustomerID IS NULL;

