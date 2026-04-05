USE [AdventureWorks]
GO

-- =========================================
-- EXERCÍCIOS - SQL SERVER (AdventureWorks)
-- =========================================

-- -------------------------------
-- 📦 BATCH (5 exercícios)
-- -------------------------------
-- 1. Crie dois batches separados: um que declare uma variável e outro que tente utilizá-la. Observe o comportamento.
-- 2. Crie uma tabela temporária em um batch e tente acessá-la em outro.
-- 3. Execute dois SELECTs separados por GO e verifique se há dependência entre eles.
-- 4. Crie um batch que insere dados e outro que faz SELECT desses dados.
-- 5. Teste o uso de GO dentro de um script com múltiplas instruções DML.

-- -------------------------------
-- 🏷️ REGRAS PARA NOMES DE OBJETOS (5 exercícios)
-- -------------------------------
-- 1. Crie uma tabela com nome válido e outra usando colchetes com espaço no nome.
-- 2. Tente criar uma tabela com nome de palavra reservada e corrija usando delimitadores.
-- 3. Crie uma tabela com nome iniciando com underscore (_).
-- 4. Tente criar um objeto com mais de 128 caracteres no nome e observe o erro.
-- 5. Crie colunas com nomes que diferem apenas por maiúsculas/minúsculas e teste o comportamento.

-- -------------------------------
-- 🔢 VARIÁVEIS (5 exercícios)
-- -------------------------------
-- 1. Declare uma variável para armazenar o nome de um produto da tabela Production.Product e exiba o valor.
-- 2. Use uma variável para armazenar um preço e filtre produtos com base nesse valor.
-- 3. Declare duas variáveis e faça uma operação matemática entre elas.
-- 4. Utilize uma variável em uma cláusula WHERE na tabela Person.Person.
-- 5. Armazene o resultado de um COUNT em uma variável e exiba o valor.

-- -------------------------------
-- ➕ OPERADORES (5 exercícios)
-- -------------------------------
-- 1. Utilize operadores aritméticos para calcular o preço com desconto em Production.Product.
-- 2. Use operadores de comparação para filtrar produtos com preço maior que um valor específico.
-- 3. Combine condições com AND e OR na tabela Sales.SalesOrderHeader.
-- 4. Utilize operador de concatenação para juntar nome e sobrenome em Person.Person.
-- 5. Use operador NOT para excluir registros com determinada condição.

-- -------------------------------
-- ⚙️ INSTRUÇÕES DINÂMICAS (5 exercícios)
-- -------------------------------
-- 1. Monte uma query dinâmica para selecionar todos os registros de Production.Product.
-- 2. Crie uma instrução dinâmica que filtre produtos por cor.
-- 3. Use sp_executesql com parâmetros para buscar dados de Person.Person.
-- 4. Crie uma query dinâmica que selecione colunas específicas com base em variável.
-- 5. Monte uma instrução dinâmica que conte registros de uma tabela escolhida via variável.

-- -------------------------------
-- 🔁 CONTROLADOR DE FLUXO (5 exercícios)
-- -------------------------------
-- 1. Use IF...ELSE para verificar se existem produtos com preço acima de um valor.
-- 2. Crie um WHILE que percorra IDs de produtos e exiba informações básicas.
-- 3. Use BEGIN...END para agrupar múltiplas instruções dentro de um IF.
-- 4. Utilize BREAK para interromper um loop ao atingir certa condição.
-- 5. Utilize CONTINUE para pular uma iteração em um loop.

-- -------------------------------
-- 📊 GROUP BY (5 exercícios)
-- -------------------------------
-- 1. Agrupe produtos por cor e conte quantos existem em cada grupo.
-- 2. Agrupe vendas por cliente na tabela Sales.SalesOrderHeader e calcule total de pedidos.
-- 3. Agrupe produtos por categoria e calcule o preço médio.
-- 4. Utilize GROUP BY com HAVING para filtrar grupos com contagem maior que um valor.
-- 5. Agrupe dados por ano de venda e calcule o total vendido por ano.

-- =========================================
-- FIM DOS EXERCÍCIOS
-- =========================================