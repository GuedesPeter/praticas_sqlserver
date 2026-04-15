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

------------------------------------------------------------

-- EXERCÍCIO 3
-- Verifique a quantidade de pedidos (SalesOrderID) de um cliente.
-- Se > 50 → "Cliente frequente"
-- Caso contrário → "Cliente ocasional"

------------------------------------------------------------

-- EXERCÍCIO 4
-- Verifique se um produto possui Weight NULL.
-- Se for NULL → "Peso não informado"
-- Caso contrário → "Peso disponível"

------------------------------------------------------------

-- EXERCÍCIO 5
-- Verifique se o ano do OrderDate é anterior a 2013.
-- Se sim → "Pedido antigo"
-- Caso contrário → "Pedido recente"

-- EXERCÍCIO 6
-- Liste produtos ordenando por ListPrice crescente.

------------------------------------------------------------

-- EXERCÍCIO 7
-- Liste clientes ordenando por LastName decrescente.

------------------------------------------------------------

-- EXERCÍCIO 8
-- Liste pedidos ordenando por OrderDate mais recente primeiro.

------------------------------------------------------------

-- EXERCÍCIO 9
-- Liste produtos ordenando por preço (desc) e nome (asc).

------------------------------------------------------------

-- EXERCÍCIO 10
-- Liste funcionários ordenando por HireDate e depois por JobTitle.


-- EXERCÍCIO 11
-- Conte quantos produtos existem por ProductSubcategoryID.

------------------------------------------------------------

-- EXERCÍCIO 12
-- Agrupe pedidos por CustomerID e conte quantos cada cliente possui.

------------------------------------------------------------

-- EXERCÍCIO 13
-- Agrupe vendas por TerritoryID e calcule o total de pedidos.

------------------------------------------------------------

-- EXERCÍCIO 14
-- Agrupe produtos por Color e conte quantos existem de cada cor.

------------------------------------------------------------

-- EXERCÍCIO 15
-- Agrupe pedidos por ano (OrderDate) usando funções de data.

-- EXERCÍCIO 16
-- Calcule o preço médio dos produtos.

------------------------------------------------------------

-- EXERCÍCIO 17
-- Encontre o maior e o menor ListPrice.

------------------------------------------------------------

-- EXERCÍCIO 18
-- Some o TotalDue de todos os pedidos.

------------------------------------------------------------

-- EXERCÍCIO 19
-- Conte o número total de clientes.

------------------------------------------------------------

-- EXERCÍCIO 20
-- Calcule a média de dias entre OrderDate e ShipDate.

-- EXERCÍCIO 21
-- Crie um script com duas partes separadas por GO:
-- 1ª parte: declarar variável e atribuir valor
-- 2ª parte: utilizar a variável em uma consulta

------------------------------------------------------------

-- EXERCÍCIO 22
-- Crie uma tabela temporária em um batch
-- e tente utilizá-la em outro batch separado

------------------------------------------------------------

-- EXERCÍCIO 23
-- Declare variáveis em um batch e teste sua visibilidade após GO

------------------------------------------------------------

-- EXERCÍCIO 24
-- Crie um procedimento armazenado em um batch separado

------------------------------------------------------------

-- EXERCÍCIO 25
-- Teste múltiplos comandos separados por GO simulando execução em etapas

-- EXERCÍCIO 26
-- Use operadores aritméticos para calcular desconto sobre ListPrice.

------------------------------------------------------------

-- EXERCÍCIO 27
-- Use operadores de comparação para filtrar produtos com preço > 500.

------------------------------------------------------------

-- EXERCÍCIO 28
-- Use operadores lógicos (AND/OR) para filtrar produtos por cor e preço.

------------------------------------------------------------

-- EXERCÍCIO 29
-- Use operador LIKE para buscar nomes que contenham 'Bike'.

------------------------------------------------------------

-- EXERCÍCIO 30
-- Use operador IN para filtrar múltiplos ProductID.

-- EXERCÍCIO 31
-- Monte uma query dinâmica para buscar produtos por preço mínimo.

------------------------------------------------------------

-- EXERCÍCIO 32
-- Use sp_executesql para executar uma consulta com parâmetro.

------------------------------------------------------------

-- EXERCÍCIO 33
-- Crie uma query dinâmica que filtre produtos por nome.

------------------------------------------------------------

-- EXERCÍCIO 34
-- Monte dinamicamente um ORDER BY com base em variável.

------------------------------------------------------------

-- EXERCÍCIO 35
-- Crie uma query dinâmica que selecione colunas dinamicamente

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

------------------------------------------------------------

-- EXERCÍCIO 2 - ORDER BY
-- Contexto: Ordenação de produtos
-- Enunciado:
-- Liste os produtos da tabela Production.Product mostrando Name, ListPrice e SellStartDate.
-- Ordene os resultados primeiro pelo preço (decrescente) e, em caso de empate,
-- pela data de início de venda (mais antiga primeiro).

------------------------------------------------------------

-- EXERCÍCIO 3 - GROUP BY
-- Contexto: Análise por território
-- Enunciado:
-- Agrupe os registros da tabela Sales.SalesOrderHeader por TerritoryID.
-- Exiba o total de pedidos por território.
-- Considere apenas pedidos realizados após o ano de 2012.

------------------------------------------------------------

-- EXERCÍCIO 4 - FUNÇÕES DE AGREGAÇÃO
-- Contexto: Estatísticas de preço
-- Enunciado:
-- Calcule o preço médio, o maior preço e o menor preço dos produtos da tabela Production.Product.
-- Considere apenas produtos ativos (SellEndDate NULL).

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
