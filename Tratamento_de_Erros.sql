
USE AdventureWorks
GO

/************************************************************************
SQL SERVER - TRATAMENTO DE ERROS E CONTROLE DE TRANSAÇÕES
************************************************************************/

-- 1. Exercício: Tratamento de erro com TRY...CATCH
-- Descrição: Crie um procedimento armazenado que insira um novo produto na tabela [Production].[Product]. 
-- O procedimento deve verificar se o [ProductNumber] já existe na tabela. Caso exista, o erro deve ser capturado e 
-- uma mensagem personalizada de erro deve ser retornada.
-- Utilize TRY...CATCH para capturar qualquer erro durante a inserção e retornar uma mensagem apropriada.

CREATE OR ALTER PROCEDURE sp_InsertProduct
    @ProductNumber NVARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON; -- Evita mensagens desnecessárias

    BEGIN TRY
        BEGIN TRAN;

        IF EXISTS (
            SELECT 1
            FROM Production.Product
            WHERE ProductNumber = @ProductNumber
        )
        BEGIN
            THROW 50001, 'ProductNumber já existe.', 1;
        END

        INSERT INTO Production.Product
        (
            Name,
            ProductNumber,
            MakeFlag,
            FinishedGoodsFlag,
            SafetyStockLevel,
            ReorderPoint,
            StandardCost,
            ListPrice,
            DaysToManufacture,
            SellStartDate,
            rowguid,
            ModifiedDate
        )
        VALUES
        (
            'Road-750 Black, 100',
            @ProductNumber,
            0,
            1,
            100,
            50,
            10.00,
            25.99,
            0,
            GETDATE(),
            NEWID(),
            GETDATE()
        );

        COMMIT;

        PRINT 'Produto inserido com sucesso';

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT 'Erro ao inserir produto';
        PRINT ERROR_MESSAGE();

    END CATCH
END

-- Executando 
EXEC sp_InsertProduct 'TESTE_BK-R100';

-- Validando
SELECT * FROM [Production].[Product]
WHERE ProductNumber LIKE '%TESTE_BK-R100%';



-- =========================================
-- EXERCÍCIO 2 - Validando NULL em dados inseridos (AJUSTADO)
-- Contexto:
-- Atualização de dados de clientes com validação de informações obrigatórias.
-- Enunciado:
-- Crie uma consulta que atualize os dados de um cliente na tabela Sales.Customer.
-- Antes de realizar a atualização, valide se o cliente possui EmailAddress cadastrado.
-- Para isso, utilize JOIN com a tabela Person.EmailAddress.
-- Caso o EmailAddress seja NULL ou inexistente, a operação de atualização deve ser interrompida
-- e uma mensagem de erro deve ser exibida ao usuário utilizando TRY...CATCH.
-- CLIENTE 170 PARA TERRITORYID 1
DECLARE @CLI INT = 170;

BEGIN TRY
    SET NOCOUNT ON;
    BEGIN TRAN;

    IF NOT EXISTS (
        SELECT 1
        FROM Sales.Customer S
        JOIN Person.EmailAddress P 
            ON P.BusinessEntityID = S.PersonID
        WHERE S.CustomerID = @CLI
    )
    BEGIN
        THROW 50001, 'Cliente sem EmailAddress - UPDATE não permitido.', 1;
    END

    UPDATE Sales.Customer
    SET TerritoryID = 1
    WHERE CustomerID = @CLI
      AND TerritoryID <> 1;

    COMMIT;

    PRINT 'UPDATE REALIZADO!';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK;

    PRINT ERROR_MESSAGE();
END CATCH



-- 3. Exercício: Usando ROLLBACK em transações com erro
-- Descrição: Crie um bloco de código que insira dados na tabela [Production].[Product] e [Production].[ProductSubcategory]. 
-- Se a inserção na tabela [ProductSubcategory] falhar (por exemplo, devido a violação de chave estrangeira), 
-- a transação inteira deve ser revertida com um ROLLBACK e um erro apropriado deve ser gerado usando TRY...CATCH.
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @SubcategoryID INT;

    -- 1. Validar se categoria existe
    IF NOT EXISTS (
        SELECT 1 
        FROM Production.ProductCategory 
        WHERE ProductCategoryID = 1
    )
    BEGIN
        THROW 50001, 'Categoria não existe.', 1;
    END

    -- 2. Inserir subcategoria
    INSERT INTO Production.ProductSubcategory
    (
        ProductCategoryID,
        Name,
        rowguid,
        ModifiedDate
    )
    VALUES
    (
        1,
        'Subcategoria Teste SQL',
        NEWID(),
        GETDATE()
    );

    -- 3. Recuperar ID gerado
    SET @SubcategoryID = SCOPE_IDENTITY();

    -- 4. Inserir produto
    INSERT INTO Production.Product
    (
        Name,
        ProductNumber,
        MakeFlag,
        FinishedGoodsFlag,
        Color,
        SafetyStockLevel,
        ReorderPoint,
        StandardCost,
        ListPrice,
        DaysToManufacture,
        SellStartDate,
        ProductSubcategoryID,
        rowguid,
        ModifiedDate
    )
    VALUES
    (
        'Produto Teste SQL',
        'SQL-TEST-001',
        0,
        1,
        'Black',
        100,
        50,
        10.00,
        25.99,
        0,
        GETDATE(),
        @SubcategoryID,
        NEWID(),
        GETDATE()
    );

    COMMIT;

    PRINT 'INSERT OK!';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK;

    PRINT 'ERRO!';
    PRINT ERROR_MESSAGE();
END CATCH;



-- Crie uma STORED PROCEDURE chamada:
-- sp_InsertProductCompleto

-- Requisitos:

-- 1) Receber parâmetros:
-- @ProductNumber
-- @ProductName
-- @ListPrice
-- @ProductCategoryID

-- 2) Validar:
-- - Se ProductCategory existe
-- - Se ProductNumber já existe

-- 3) Inserir:
-- - ProductSubcategory (criar nova)
-- - Product (usando a subcategoria criada)

-- 4) Usar:
-- - BEGIN TRAN
-- - TRY...CATCH
-- - THROW
-- - SET NOCOUNT ON

-- 5) Regras:
-- - Se qualquer validação falhar → THROW
-- - Se qualquer erro acontecer → ROLLBACK
-- - Se tudo ok → COMMIT + mensagem de sucesso