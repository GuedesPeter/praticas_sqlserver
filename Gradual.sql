USE AdventureWorks
GO 
/* =========================================================
   📚 BATERIA COMPLETA - TREINAMENTO SQL SERVER (AdventureWorks)
   🎯 Objetivo: Evolução progressiva → Base → Intermediário → Profissional
   ========================================================= */

/* =========================================================
   🧠 MAPA MENTAL DE PROGRESSÃO

   Nível 1 → EXISTS (validar existência)
   Nível 2 → GROUP BY (agrupar)
   Nível 3 → HAVING (filtrar agregação)
   Nível 4 → JOIN + agregação
   Nível 5 → EXISTS + regra de negócio
   Nível 6 → TRANSACTION + TRY...CATCH
   Nível 7 → PROCEDURE completa
   ========================================================= */


/* =========================================================
   🔥 BLOCO 1 — FUNDAMENTOS (EXISTS + GROUP BY)
   ========================================================= */

-- EX 1 - EXISTS (base)
-- Retorne 'OK' se existirem pedidos na tabela Sales.SalesOrderHeader

IF EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader]
	WHERE SalesOrderID > 0
)
PRINT 'OK';


-- EX 2 - EXISTS (correlação)
-- Liste CustomerID que possuem pedidos

SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] O
	WHERE O.CustomerID = C.CustomerID
)

-- EX 3 - NOT EXISTS
-- Liste CustomerID que NÃO possuem pedidos

SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE NOT EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] O
	WHERE O.CustomerID = C.CustomerID
)

-- EX 4 - GROUP BY (contagem)
-- Conte pedidos por CustomerID

SELECT
	CustomerID,
	COUNT(SalesOrderID) AS QtPed
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID;

-- EX 5 - GROUP BY + ORDER
-- Liste clientes com maior número de pedidos
SELECT
	CustomerID,
	COUNT(SalesOrderID) AS QtPed
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY QtPed DESC;

/* =========================================================
   🔥 BLOCO 2 — CONSOLIDAÇÃO (HAVING + MÉTRICAS)
   ========================================================= */

-- EX 6 - HAVING
-- Liste clientes com mais de 10 pedidos

SELECT 
	CustomerID,
	COUNT(SalesOrderID) AS QTPED
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 10
ORDER BY QTPED DESC;

-- EX 7 - GROUP BY + SUM
-- Some TotalDue por CustomerID

SELECT
	CustomerID,
	SUM(TotalDue) AS SomaTicket
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY SomaTicket DESC;

-- Formatado para relatório [Opcional]
SELECT
	CustomerID,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS SomaTicket
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY SUM(TotalDue) DESC;

-- EX 8 - GROUP BY + AVG
-- Calcule ticket médio por cliente

SELECT
	CustomerID,
	AVG(TotalDue) AS TkTMedio
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY TkTMedio DESC;
-- Formatado para relatório [Opcional]
SELECT
	CustomerID,
	FORMAT(AVG(TotalDue),'C','pt-BR') AS TkTMedio
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY AVG(TotalDue) DESC;

-- EX 9 - GROUP BY + MULTI COLUNA
-- Agrupe pedidos por CustomerID e ano

SELECT 
    CustomerID,
    YEAR(OrderDate) AS ANO,
    COUNT(*) AS QtPedidos
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, YEAR(OrderDate);

-- EX 10 - HAVING + SUM
-- Liste clientes com faturamento total acima de 50000

SELECT 
	CustomerID,
	SUM(TotalDue) AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING SUM(TotalDue) > 50000
ORDER BY FATURAMENTO DESC;
-- Opção para relatório
SELECT 
	CustomerID,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING SUM(TotalDue) > 50000
ORDER BY FATURAMENTO DESC;


/* =========================================================
   🔥 BLOCO 3 — EXISTS AVANÇADO (REGRAS DE NEGÓCIO)
   ========================================================= */

-- EX 11 - EXISTS + condição
-- Clientes com pedidos acima de 10000

SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.TotalDue > 10000
);


-- EX 12 - EXISTS + data
-- Clientes com pedidos após 2013

SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.OrderDate >= '20140101'
)

-- EX 13 - EXISTS + múltiplas condições
-- Clientes com pedidos > 5000 E após 2012

SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.TotalDue > 5000
	AND H.OrderDate >= '20130101'
);

-- EX 14 - EXISTS (produto vendido)
-- Liste produtos que foram vendidos

SELECT
	P.ProductID,
	P.Name
FROM [Production].[Product] P
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
);


-- EX 15 - NOT EXISTS (produto nunca vendido)
-- Liste produtos que nunca foram vendidos

SELECT
	P.ProductID,
	P.Name
FROM [Production].[Product] P
WHERE NOT EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderDetail] D
	WHERE D.ProductID = P.ProductID
);


/* =========================================================
   🔥 BLOCO 4 — JOIN + AGREGAÇÃO (VISÃO ANALÍTICA)
   ========================================================= */

-- EX 16 - JOIN + COUNT
-- Conte pedidos por TerritoryID

SELECT 
	T.TerritoryID,
	COUNT(H.SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID
ORDER BY QtPedidos DESC; -- Territorios com mais pedidos	


-- EX 17 - JOIN + SUM
-- Some TotalDue por TerritoryID
SELECT 
	T.TerritoryID,
	SUM(H.TotalDue) AS Faturamento
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID
ORDER BY Faturamento DESC;
-- Opção para análise
SELECT 
	T.TerritoryID,
	FORMAT(SUM(H.TotalDue),'C','pt-BR') AS Faturamento
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID
ORDER BY SUM(H.TotalDue) DESC;

-- EX 18 - JOIN + AVG
-- Calcule média de vendas por território
SELECT 
	T.TerritoryID,
	AVG(H.TotalDue) AS TicketMedio
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID
ORDER BY TicketMedio DESC;
-- Opção para análise
SELECT 
	T.TerritoryID,
	FORMAT(AVG(H.TotalDue),'C','pt-BR') AS TicketMedio
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesTerritory] T
	ON T.TerritoryID = H.TerritoryID
GROUP BY T.TerritoryID
ORDER BY AVG(H.TotalDue) DESC;


-- EX 19 - JOIN + HAVING
-- Liste territórios com mais de 100 pedidos
SELECT
	T.TerritoryID,
	COUNT(H.SalesOrderID) AS QuantPed
FROM [Sales].[SalesTerritory] T
JOIN [Sales].[SalesOrderHeader] H
ON H.TerritoryID = T.TerritoryID
GROUP BY T.TerritoryID
HAVING COUNT(H.SalesOrderID) > 100
ORDER BY QuantPed DESC;

-- EX 20 - MULTI DIMENSÃO
-- Agrupe pedidos por território e ano
SELECT
	COUNT(H.SalesOrderID) AS QuantidadePed,
	H.TerritoryID,
	YEAR(H.OrderDate) AS ANO
FROM [Sales].[SalesOrderHeader] H
GROUP BY H.TerritoryID, YEAR(H.OrderDate)
ORDER BY ANO DESC;

/* =========================================================
   🔥 EXERCÍCIO BLOCO 5 — CONTROLE TRANSACIONAL COMPLETO
   =========================================================

   🎯 CENÁRIO REAL:
   Você está implementando uma rotina de cadastro de produtos.
   Esse cadastro é crítico: se algo falhar, NÃO pode deixar dados inconsistentes.

   Um erro comum no sistema é:
   - inserir produto duplicado
   - falhar no meio da operação
   - deixar dados parcialmente gravados

   Sua responsabilidade é garantir:
   👉 integridade total da operação

   ---------------------------------------------------------

   🧠 OBJETIVO:
   Criar um bloco de código que:

   ✔ valide regras de negócio
   ✔ execute inserção controlada
   ✔ trate erros corretamente
   ✔ garanta consistência com transação

   ---------------------------------------------------------

   📌 REQUISITOS OBRIGATÓRIOS:

   1) ATIVAR CONTROLE:
      - SET NOCOUNT ON

   2) USAR BLOCO DE PROTEÇÃO:
      - BEGIN TRY / BEGIN CATCH

   3) USAR TRANSAÇÃO:
      - BEGIN TRAN
      - COMMIT
      - ROLLBACK

   4) VALIDAR REGRA DE NEGÓCIO:
      - NÃO permitir ProductNumber duplicado
      - usar EXISTS

   5) CONTROLE DE ERRO:
      - Se duplicado → THROW (erro manual)
      - Se erro inesperado → capturar no CATCH

   6) EXECUTAR INSERT:
      - Apenas se passar nas validações

   ---------------------------------------------------------

   ⚠️ PONTOS CRÍTICOS (ONDE ERROS ACONTECEM):

   - Validar DEPOIS do insert ❌
   - Não usar ROLLBACK ❌
   - Não verificar @@TRANCOUNT ❌
   - THROW mal posicionado ❌

   ---------------------------------------------------------

   🧠 FLUXO MENTAL (DECORA ISSO):

   1. O que pode dar errado?
      → duplicidade / erro de insert

   2. Como prevenir?
      → EXISTS + THROW

   3. Como proteger execução?
      → TRY...CATCH + TRAN

   4. Qual sequência correta?
      → VALIDAR → TRAN → INSERT → COMMIT

   5. Se falhar?
      → ROLLBACK

   ---------------------------------------------------------

   🎯 RESULTADO ESPERADO:

   ✔ Nenhum dado inconsistente
   ✔ Nenhum insert parcial
   ✔ Fluxo controlado
   ✔ Erro tratado corretamente

   ========================================================= */


/* =========================================================
   🔥 EXERCÍCIO BLOCO 6 — PROCEDURE NÍVEL PROFISSIONAL
   =========================================================

   🎯 CENÁRIO REAL:
   Você foi designado para desenvolver uma Stored Procedure
   responsável pelo cadastro completo de produtos.

   Esse processo envolve múltiplas tabelas e regras críticas.

   O sistema atual tem problemas:
   ❌ produtos sem subcategoria
   ❌ duplicidade de ProductNumber
   ❌ falhas que deixam dados inconsistentes

   Sua missão:
   👉 criar uma solução robusta, segura e reutilizável

   ---------------------------------------------------------

   🧠 OBJETIVO:
   Construir uma STORED PROCEDURE com fluxo profissional

   ---------------------------------------------------------

   📌 PARÂMETROS:

   - @ProductName
   - @ProductNumber
   - @ListPrice
   - @ProductCategoryID

   ---------------------------------------------------------

   📌 REGRAS DE NEGÓCIO:

   1) A categoria DEVE existir
      → validar em Production.ProductCategory

   2) O ProductNumber NÃO pode existir
      → validar em Production.Product

   3) O produto DEVE ter subcategoria
      → criar nova automaticamente

   ---------------------------------------------------------

   📌 FLUXO OBRIGATÓRIO:

   1) SET NOCOUNT ON

   2) BEGIN TRY

   3) BEGIN TRAN

   4) VALIDAÇÕES:
      - categoria existe? → se NÃO → THROW
      - produto duplicado? → se SIM → THROW

   5) INSERÇÃO EM CASCATA:
      - inserir em ProductSubcategory
      - capturar ID (SCOPE_IDENTITY)
      - inserir em Product

   6) COMMIT

   7) BEGIN CATCH:
      - IF @@TRANCOUNT > 0 → ROLLBACK
      - retornar erro (THROW ou ERROR_MESSAGE)

   ---------------------------------------------------------

   ⚠️ PONTOS CRÍTICOS:

   - Ordem de execução ERRADA → quebra tudo
   - Não capturar ID → FK inválida
   - Não validar antes → erro desnecessário
   - Não usar transação → inconsistência

   ---------------------------------------------------------

   🧠 FLUXO MENTAL:

   1. Existe dependência?
      → SIM (subcategoria → produto)

   2. O que validar?
      → categoria / duplicidade

   3. Como proteger?
      → TRAN + TRY

   4. Ordem correta?
      → VALIDAR → INSERT SUB → PEGAR ID → INSERT PRODUTO

   5. Se der erro?
      → ROLLBACK

   ---------------------------------------------------------

   🎯 RESULTADO ESPERADO:

   ✔ Integridade referencial garantida
   ✔ Nenhum dado parcial
   ✔ Código reutilizável
   ✔ Estrutura profissional

   ========================================================= */

   /* =========================================================
   🔥 EXERCÍCIO BLOCO 1 — VALIDAÇÃO DE EXISTÊNCIA (EXISTS)
   =========================================================

   🎯 CENÁRIO REAL:
   Você está desenvolvendo um relatório de clientes ativos.

   A regra da empresa é:
   👉 Um cliente só é considerado ATIVO se ele já realizou pelo menos um pedido.

   Problema atual:
   ❌ O sistema lista todos os clientes
   ❌ Inclui clientes sem atividade (dados poluídos)

   ---------------------------------------------------------

   🧠 OBJETIVO:
   Retornar apenas clientes que possuem pedidos registrados.

   ---------------------------------------------------------

   📌 BASE CONCEITUAL:

   EXISTS serve para:
   ✔ validar existência de relacionamento
   ✔ evitar JOIN desnecessário
   ✔ trabalhar com lógica booleana (existe / não existe)

   ---------------------------------------------------------

   📌 REQUISITOS:

   1) Utilizar tabela:
      - Sales.Customer (cliente)
      - Sales.SalesOrderHeader (pedidos)

   2) Retornar:
      - CustomerID

   3) Regra:
      - Só deve aparecer cliente que possui pedido

   ---------------------------------------------------------

   ⚠️ ERROS COMUNS:

   ❌ Usar JOIN e duplicar linhas
   ❌ Não correlacionar subquery
   ❌ Usar COUNT ao invés de EXISTS

   ---------------------------------------------------------

   🧠 FLUXO MENTAL:

   1. O que define cliente ativo?
      → possuir pedido

   2. Como validar isso?
      → EXISTS

   3. Qual relação?
      → CustomerID

   4. O que quero evitar?
      → duplicidade e custo desnecessário

   ---------------------------------------------------------

   🎯 RESULTADO ESPERADO:

   ✔ Lista limpa
   ✔ Sem duplicidade
   ✔ Query eficiente

   ========================================================= */
   /* =========================================================
   🔥 EXERCÍCIO BLOCO 2 — AGREGAÇÃO DE DADOS (GROUP BY)
   =========================================================

   🎯 CENÁRIO REAL:
   A empresa quer entender o comportamento dos clientes.

   Pergunta do negócio:
   👉 “Quais clientes mais compram?”

   Problema atual:
   ❌ Não existe visão consolidada
   ❌ Dados estão linha a linha (transacional)

   ---------------------------------------------------------

   🧠 OBJETIVO:
   Transformar dados transacionais em visão analítica.

   ---------------------------------------------------------

   📌 BASE CONCEITUAL:

   GROUP BY serve para:
   ✔ agrupar dados
   ✔ transformar linhas em informação agregada
   ✔ responder perguntas de negócio

   ---------------------------------------------------------

   📌 REQUISITOS:

   1) Usar:
      - Sales.SalesOrderHeader

   2) Retornar:
      - CustomerID
      - Quantidade de pedidos

   3) Ordenar:
      - do maior para o menor

   ---------------------------------------------------------

   ⚠️ ERROS COMUNS:

   ❌ Agrupar sem métrica
   ❌ Não usar COUNT
   ❌ Misturar colunas fora do GROUP BY

   ---------------------------------------------------------

   🧠 FLUXO MENTAL:

   1. O que quero saber?
      → quem compra mais

   2. O que representa isso?
      → quantidade de pedidos

   3. Como calcular?
      → COUNT

   4. Como estruturar?
      → GROUP BY CustomerID

   ---------------------------------------------------------

   🎯 RESULTADO ESPERADO:

   ✔ Ranking de clientes
   ✔ Base para decisão de negócio

   ========================================================= */
   /* =========================================================
   🔥 EXERCÍCIO BLOCO 3 — FILTRO POR AGREGAÇÃO (HAVING)
   =========================================================

   🎯 CENÁRIO REAL:
   O setor comercial quer identificar clientes relevantes.

   Regra:
   👉 Clientes com mais de 10 pedidos são considerados estratégicos.

   Problema atual:
   ❌ Todos os clientes aparecem (inclusive irrelevantes)

   ---------------------------------------------------------

   🧠 OBJETIVO:
   Filtrar clientes com base em comportamento agregado.

   ---------------------------------------------------------

   📌 BASE CONCEITUAL:

   HAVING serve para:
   ✔ filtrar resultados agregados
   ✔ aplicar regra após GROUP BY

   ---------------------------------------------------------

   📌 REQUISITOS:

   1) Usar:
      - Sales.SalesOrderHeader

   2) Retornar:
      - CustomerID
      - Quantidade de pedidos

   3) Regra:
      - apenas clientes com mais de 10 pedidos

   ---------------------------------------------------------

   ⚠️ ERROS COMUNS:

   ❌ Usar WHERE ao invés de HAVING
   ❌ Filtrar antes da agregação
   ❌ Não entender diferença entre WHERE e HAVING

   ---------------------------------------------------------

   🧠 FLUXO MENTAL:

   1. Primeiro eu agrupo
   2. Depois eu filtro

   ---------------------------------------------------------

   🎯 RESULTADO ESPERADO:

   ✔ Lista de clientes estratégicos
   ✔ Dados prontos para ação comercial

   ========================================================= */
   /* =========================================================
   🔥 EXERCÍCIO BLOCO 4 — ANÁLISE GERENCIAL (JOIN + GROUP BY)
   =========================================================

   🎯 CENÁRIO REAL:
   A diretoria quer entender performance por território.

   Pergunta:
   👉 “Quais territórios geram mais receita?”

   Problema atual:
   ❌ Dados separados (pedidos em uma tabela, território em outra)
   ❌ Não há visão consolidada

   ---------------------------------------------------------

   🧠 OBJETIVO:
   Unir dados e gerar análise de negócio.

   ---------------------------------------------------------

   📌 BASE CONCEITUAL:

   JOIN + GROUP BY permite:
   ✔ integrar dados
   ✔ gerar visão analítica
   ✔ responder perguntas estratégicas

   ---------------------------------------------------------

   📌 REQUISITOS:

   1) Usar:
      - Sales.SalesOrderHeader
      - Sales.SalesTerritory

   2) Retornar:
      - TerritoryID
      - Nome do território
      - Soma de TotalDue (receita)

   3) Ordenar:
      - maior receita primeiro

   ---------------------------------------------------------

   ⚠️ ERROS COMUNS:

   ❌ JOIN incorreto
   ❌ não agrupar todas colunas
   ❌ esquecer SUM

   ---------------------------------------------------------

   🧠 FLUXO MENTAL:

   1. Onde estão os dados?
      → pedidos + território

   2. Como unir?
      → JOIN

   3. O que medir?
      → receita

   4. Como calcular?
      → SUM

   5. Como organizar?
      → GROUP BY

   ---------------------------------------------------------

   🎯 RESULTADO ESPERADO:

   ✔ Ranking de territórios
   ✔ Insight gerencial real

   ========================================================= */
