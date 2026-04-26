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

-- EX 2 - EXISTS (correlação)
-- Liste CustomerID que possuem pedidos

-- EX 3 - NOT EXISTS
-- Liste CustomerID que NÃO possuem pedidos

-- EX 4 - GROUP BY (contagem)
-- Conte pedidos por CustomerID

-- EX 5 - GROUP BY + ORDER
-- Liste clientes com maior número de pedidos


/* =========================================================
   🔥 BLOCO 2 — CONSOLIDAÇÃO (HAVING + MÉTRICAS)
   ========================================================= */

-- EX 6 - HAVING
-- Liste clientes com mais de 10 pedidos

-- EX 7 - GROUP BY + SUM
-- Some TotalDue por CustomerID

-- EX 8 - GROUP BY + AVG
-- Calcule ticket médio por cliente

-- EX 9 - GROUP BY + MULTI COLUNA
-- Agrupe pedidos por CustomerID e ano

-- EX 10 - HAVING + SUM
-- Liste clientes com faturamento total acima de 50000


/* =========================================================
   🔥 BLOCO 3 — EXISTS AVANÇADO (REGRAS DE NEGÓCIO)
   ========================================================= */

-- EX 11 - EXISTS + condição
-- Clientes com pedidos acima de 10000

-- EX 12 - EXISTS + data
-- Clientes com pedidos após 2013

-- EX 13 - EXISTS + múltiplas condições
-- Clientes com pedidos > 5000 E após 2012

-- EX 14 - EXISTS (produto vendido)
-- Liste produtos que foram vendidos

-- EX 15 - NOT EXISTS (produto nunca vendido)
-- Liste produtos que nunca foram vendidos


/* =========================================================
   🔥 BLOCO 4 — JOIN + AGREGAÇÃO (VISÃO ANALÍTICA)
   ========================================================= */

-- EX 16 - JOIN + COUNT
-- Conte pedidos por TerritoryID

-- EX 17 - JOIN + SUM
-- Some TotalDue por TerritoryID

-- EX 18 - JOIN + AVG
-- Calcule média de vendas por território

-- EX 19 - JOIN + HAVING
-- Liste territórios com mais de 100 pedidos

-- EX 20 - MULTI DIMENSÃO
-- Agrupe pedidos por território e ano


/* =========================================================
   🔥 BLOCO 5 — TRANSAÇÕES (INÍCIO NÍVEL PROFISSIONAL)
   ========================================================= */

-- EX 21 - TRANSACTION simples
-- Faça um INSERT em Production.Product com BEGIN TRAN e COMMIT

-- EX 22 - TRANSACTION + erro manual
-- Gere um erro proposital e use ROLLBACK

-- EX 23 - TRY...CATCH
-- Capture erro ao inserir dados inválidos

-- EX 24 - THROW
-- Lance erro se ProductNumber já existir

-- EX 25 - TRANSACTION + validação
-- Valide e insira produto com controle total


/* =========================================================
   🔥 BLOCO 6 — DESAFIOS REAIS (INTEGRAÇÃO COMPLETA)
   ========================================================= */

-- EX 26 - INSERT com FK
-- Insira ProductSubcategory e Product corretamente

-- EX 27 - TRANSACTION completa
-- Se qualquer INSERT falhar → ROLLBACK

-- EX 28 - VALIDAÇÃO COMPLETA
-- Valide categoria e duplicidade antes de inserir

-- EX 29 - PROCEDURE (básica)
-- Crie procedure para inserir produto

-- EX 30 - PROCEDURE (nível profissional)
-- Crie procedure com:
-- - parâmetros
-- - validações
-- - transaction
-- - try...catch
-- - throw
