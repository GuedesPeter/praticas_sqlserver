USE AdventureWorks
GO 
-- =========================================
-- 🔥 BLOCO 1
-- =========================================

-- EX 1 - EXISTS (base)
-- Contexto:
-- Verificação simples
-- Enunciado:
-- Retorne 'OK' se existirem pedidos na tabela Sales.SalesOrderHeader

-- =========================================
-- EX 2 - EXISTS (correlação)
-- Contexto:
-- Clientes ativos
-- Enunciado:
-- Liste CustomerID que possuem pedidos

-- =========================================
-- EX 3 - NOT EXISTS
-- Contexto:
-- Clientes inativos
-- Enunciado:
-- Liste CustomerID que NÃO possuem pedidos

-- =========================================
-- EX 4 - GROUP BY (contagem)
-- Contexto:
-- Volume de pedidos
-- Enunciado:
-- Conte pedidos por CustomerID

-- =========================================
-- EX 5 - GROUP BY + ORDER
-- Contexto:
-- Ranking simples
-- Enunciado:
-- Liste clientes com maior número de pedidos

-- =========================================
-- 🔥 BLOCO 2
-- =========================================

-- =========================================
-- EX 6 - HAVING (filtro)
-- Contexto:
-- Clientes relevantes
-- Enunciado:
-- Liste clientes com mais de 10 pedidos

-- =========================================
-- EX 7 - GROUP BY + SUM
-- Contexto:
-- Receita
-- Enunciado:
-- Some TotalDue por CustomerID

-- =========================================
-- EX 8 - GROUP BY + AVG
-- Contexto:
-- Ticket médio
-- Enunciado:
-- Calcule ticket médio por cliente

-- =========================================
-- EX 9 - GROUP BY + MULTI COLUNA
-- Contexto:
-- Análise temporal
-- Enunciado:
-- Agrupe pedidos por CustomerID e ano

-- =========================================
-- EX 10 - HAVING + SUM
-- Contexto:
-- Clientes VIP
-- Enunciado:
-- Liste clientes com faturamento total acima de 50000


-- =========================================
-- 🔥 BLOCO 3
-- =========================================

-- =========================================
-- EX 11 - EXISTS + condição
-- Contexto:
-- Clientes VIP
-- Enunciado:
-- Liste clientes com pedidos acima de 10000

-- =========================================
-- EX 12 - EXISTS + data
-- Contexto:
-- Atividade recente
-- Enunciado:
-- Liste clientes com pedidos após 2013

-- =========================================
-- EX 13 - EXISTS + múltiplas condições
-- Contexto:
-- Filtro avançado
-- Enunciado:
-- Clientes com pedidos > 5000 E após 2012

-- =========================================
-- EX 14 - EXISTS (produto vendido)
-- Contexto:
-- Produtos ativos
-- Enunciado:
-- Liste produtos que foram vendidos

-- =========================================
-- EX 15 - NOT EXISTS (produto parado)
-- Contexto:
-- Produtos inativos
-- Enunciado:
-- Liste produtos nunca vendidos


-- =========================================
-- 🔥 BLOCO 4
-- =========================================

-- =========================================
-- EX 16 - JOIN + COUNT
-- Contexto:
-- Pedidos por território
-- Enunciado:
-- Conte pedidos por TerritoryID

-- =========================================
-- EX 17 - JOIN + SUM
-- Contexto:
-- Receita por território
-- Enunciado:
-- Some TotalDue por TerritoryID

-- =========================================
-- EX 18 - JOIN + AVG
-- Contexto:
-- Ticket médio territorial
-- Enunciado:
-- Calcule média de vendas por território

-- =========================================
-- EX 19 - JOIN + HAVING
-- Contexto:
-- Territórios fortes
-- Enunciado:
-- Liste territórios com mais de 100 pedidos

-- =========================================
-- 🔥 BLOCO 5
-- =========================================


-- =========================================
-- EX 20 - MULTI DIMENSÃO
-- Contexto:
-- BI básico
-- Enunciado:
-- Agrupe pedidos por território e ano

-- =========================================
-- EX 21 - TRANSACTION simples
-- Contexto:
-- Controle de inserção
-- Enunciado:
-- Faça um INSERT em Product com BEGIN TRAN e COMMIT

-- =========================================
-- EX 22 - TRANSACTION + erro manual
-- Contexto:
-- Simulação de erro
-- Enunciado:
-- Gere um erro proposital e use ROLLBACK

-- =========================================
-- EX 23 - TRY...CATCH
-- Contexto:
-- Tratamento de erro
-- Enunciado:
-- Capture erro ao inserir dados inválidos

-- =========================================
-- EX 24 - THROW
-- Contexto:
-- Validação
-- Enunciado:
-- Lance erro se ProductNumber já existir

-- =========================================
-- EX 25 - TRANSACTION + validação
-- Contexto:
-- Fluxo seguro
-- Enunciado:
-- Valide e insira produto com controle total

-- =========================================
-- 🔥 BLOCO 6
-- =========================================

-- =========================================
-- EX 26 - INSERT com FK
-- Contexto:
-- Dependência
-- Enunciado:
-- Insira ProductSubcategory e Product corretamente

-- =========================================
-- EX 27 - TRANSACTION completa
-- Contexto:
-- Integridade
-- Enunciado:
-- Se qualquer INSERT falhar → ROLLBACK

-- =========================================
-- EX 28 - VALIDAÇÃO COMPLETA
-- Contexto:
-- Regra de negócio
-- Enunciado:
-- Valide categoria e duplicidade antes de inserir

-- =========================================
-- EX 29 - PROCEDURE (básica)
-- Contexto:
-- Reutilização
-- Enunciado:
-- Crie procedure para inserir produto

-- =========================================
-- EX 30 - PROCEDURE (nível profissional)
-- Contexto:
-- Fluxo completo
-- Enunciado:
-- Crie procedure com:
-- - parâmetros
-- - validações
-- - transaction
-- - try...catch
-- - throw