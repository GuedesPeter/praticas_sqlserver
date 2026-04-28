USE AdventureWorks
GO

-- 🧠 CENÁRIO 1 — CLIENTES ATIVOS
--A empresa considera um cliente ATIVO quando ele já realizou pelo menos um pedido.
--Você precisa gerar uma lista desses clientes.

/*

O que exatamente você precisa descobrir?
	Se existe algum registro ligado ao cliente na tabela de Vendas(Pedidos).
Quais tabelas estão envolvidas?
	Tabela de clientes e tabela de Vendas(Pedidos) (Ou apenas a tabela da venda, desde que haja um campo que revele uma ligação com os clientes)
Como você sabe se um cliente é ativo?
	Verificando se este cliente possui algum registro na tabela de Vendas(Pedidos).
Isso envolve:
validação de existência?
	Isso já resolveria basicamente o cenário
agregação?
	Seria útil para "compilar" algumas informações do clientes e seus pedidos em cenário de análise.
junção?
	Não se faz tão útil, talvez gere certas duplicidades de registro.
Qual seria a ideia geral da solução (em português mesmo)?

	Basicamente eu verificaria se o código(ID) do cliente, ou alguma informação que esteja vinculada ao cliente, existe na tabela de Vendas(Pedidos).
	Isso garantiria que ele fez pelo menos 1 pedido, o que o tornaria ATIVO.

*/

-- 🧠 CENÁRIO 2 — CLIENTES ESTRATÉGICOS
-- O time comercial quer focar apenas em clientes que fizeram MAIS DE 10 pedidos.

/*

O que muda em relação ao cenário anterior?
	Aqui a junção e agregação tomam o lugar da existencia.
	Eu preciso contar a quantidade de pedidos que cada cliente fez e retornar apenas os clientes que fizeram mais de 10 pedidos.
Agora você precisa contar algo? O quê?
	Preciso contar a quantidade de pedidos que cada cliente fez
Em que momento o filtro deve acontecer:
antes ou depois da agregação?
	Ele ocorre depois da agregação. Primeiro eu exibo a quantidade de pedidos agrupadas por cliente.
	Depois eu filtro os clientes que possuem a quantidade de seus pedidos maior que 10
Qual conceito entra aqui que não entrou no cenário 1?
	Pelo que pude perceber, aqui entra o conceito de filtragem na agregação.
	No cenário 1, eu precisava apenas gerar uma lista.
	Já no cenário 2, eu preciso segregar pelos clientes que possuem uma quantidade de pedidos realizados superior a 10.

*/

-- 🧠 CENÁRIO 3 — RECEITA POR TERRITÓRIO
-- A diretoria quer saber quais territórios geram mais receita.

/*

O que exatamente precisa ser medido?
	Eu preciso medir os territórios com maior receita, que faturaram mais.
Qual é a métrica principal?
	Segregar por território apresentando a soma dos valores vendidos por cada um.
Onde está essa informação?
	Posso obter as informações de territorio e total de vendas apenas da tabela de vendas
	(TerritoryId - TotalDue - [Sales].[SalesOrderHeader])
Você precisa juntar tabelas? Por quê?
	Eu até posso juntar tabelas, mas consigo obter as informações apenas na tabela de Vendas.
Precisa agrupar? Por qual campo?
	Preciso agrupar por territorio para saber qual vendeu mais.
Esse cenário se parece mais com:
EXISTS?
GROUP BY?
HAVING?
ou combinação?

O cenário se parece mais com o Group By apenas.
Para incrmentar posso incluir um Order By DESC para saber qual territorio gerou maior receita.
(Gerando uma espécie de ranking)

*/

-- 🧠 CENÁRIO 1 — CLIENTES ATIVOS
--A empresa considera um cliente ATIVO quando ele já realizou pelo menos um pedido.
--Você precisa gerar uma lista desses clientes.

SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
);


-- 🧠 CENÁRIO 2 — CLIENTES ESTRATÉGICOS
-- O time comercial quer focar apenas em clientes que fizeram MAIS DE 10 pedidos.
SELECT 
	CustomerID,
	COUNT(SalesOrderID) AS QtPedidos
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 10
ORDER BY QtPedidos DESC;


-- 🧠 CENÁRIO 3 — RECEITA POR TERRITÓRIO
SELECT
	TerritoryID,
	SUM(TotalDue) AS Receita
FROM [Sales].[SalesOrderHeader]
GROUP BY TerritoryID
ORDER BY Receita DESC;

-- Formatado, para uma melhor análise da diretoria
SELECT
	TerritoryID,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Receita
FROM [Sales].[SalesOrderHeader]
GROUP BY TerritoryID
ORDER BY SUM(TotalDue) DESC;
-----------------------------------------------------------------------------------------------

/* =========================================================
   🧠 EX 1 — CLIENTES SEM PEDIDOS RECENTES
   =========================================================

   🎯 CENÁRIO:
   A empresa deseja identificar clientes que não compram há bastante tempo.

   Regra:
   👉 Cliente alvo = não realizou pedidos nos últimos 2 anos

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. O que caracteriza “recente”?
   2. Onde está a data do pedido?
   3. Você precisa verificar existência ou ausência?
   4. A validação de data deve ocorrer dentro ou fora da subquery?
   5. Como garantir que clientes antigos (com pedidos antigos) sejam incluídos corretamente?

   ========================================================= */



/* =========================================================
   🧠 EX 2 — CLIENTES COM ATIVIDADE EM DIFERENTES PERÍODOS
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar clientes com recorrência ao longo do tempo.

   Regra:
   👉 Cliente relevante = realizou pedidos em mais de um ano distinto

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. O que você precisa contar: pedidos ou anos?
   2. Como identificar anos distintos?
   3. Você precisa eliminar duplicidades?
   4. O agrupamento deve ocorrer por cliente ou por cliente+ano?
   5. O filtro ocorre antes ou depois da agregação?

   ========================================================= */



/* =========================================================
   🧠 EX 3 — PRODUTOS COM BAIXO FATURAMENTO
   =========================================================

   🎯 CENÁRIO:
   O setor de negócios quer identificar produtos com baixa performance.

   Regra:
   👉 Produto com faturamento total inferior a 5000

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. Onde está o valor de venda?
   2. Você precisa somar valores por produto?
   3. Como garantir que apenas produtos vendidos sejam considerados?
   4. O filtro ocorre antes ou depois da soma?
   5. Você precisa combinar mais de uma tabela?

   ========================================================= */



/* =========================================================
   🧠 EX 4 — CLIENTES COM PEDIDOS DE ALTO VALOR
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar clientes que já realizaram compras expressivas.

   Regra:
   👉 Cliente relevante = possui pelo menos um pedido com valor > 10000

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. Você precisa avaliar todos os pedidos ou apenas verificar um?
   2. Isso é validação ou agregação?
   3. Qual abordagem é mais simples e eficiente?
   4. Você precisa agrupar resultados?
   5. Como garantir que cada cliente apareça apenas uma vez?

   ========================================================= */



/* =========================================================
   🧠 EX 5 — TERRITÓRIOS COM BAIXO VOLUME
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar regiões com baixo número de pedidos.

   Regra:
   👉 Território com menos de 50 pedidos

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. O que precisa ser contado?
   2. Onde está essa informação?
   3. Você precisa agrupar por qual campo?
   4. O filtro deve ser aplicado antes ou depois da contagem?
   5. Qual função resolve esse problema?

   ========================================================= */



/* =========================================================
   🧠 EX 6 — PRODUTOS COM DESCONTO
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar produtos que já foram vendidos com desconto.

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. Onde está a informação de desconto?
   2. Você precisa validar existência ou calcular algo?
   3. O desconto é por pedido ou por item?
   4. Como relacionar produto com venda?
   5. Você precisa retornar produtos únicos?

   ========================================================= */



/* =========================================================
   🧠 EX 7 — CLIENTES COM ALTO FATURAMENTO TOTAL
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar clientes mais lucrativos.

   Regra:
   👉 Cliente com faturamento total acima de 100000

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. Onde está o valor total?
   2. Você precisa somar por cliente?
   3. O filtro ocorre antes ou depois da soma?
   4. Qual cláusula será usada para filtrar?
   5. Como ordenar os resultados para análise?

   ========================================================= */



/* =========================================================
   🧠 EX 8 — ANÁLISE DE VENDAS POR ANO
   =========================================================

   🎯 CENÁRIO:
   A diretoria quer acompanhar o desempenho ao longo do tempo.

   ---------------------------------------------------------

   🧠 DESAFIO:

   Para cada ano:
   - total de vendas
   - quantidade de pedidos

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. Como extrair o ano da data?
   2. Você precisa de quantas métricas?
   3. Como combinar múltiplas agregações?
   4. Qual será o agrupamento?
   5. Como ordenar para facilitar análise?

   ========================================================= */



/* =========================================================
   🧠 EX 9 — CLIENTES COM MUITOS PEDIDOS
   =========================================================

   🎯 CENÁRIO:
   O time comercial quer identificar clientes frequentes.

   Regra:
   👉 Cliente com mais de 20 pedidos

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. O que precisa ser contado?
   2. Qual tabela contém essa informação?
   3. Como agrupar corretamente?
   4. Em qual momento aplicar o filtro?
   5. Qual cláusula usar para isso?

   ========================================================= */



/* =========================================================
   🧠 EX 10 — PRODUTOS MAIS VENDIDOS
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar produtos com maior volume de vendas.

   ---------------------------------------------------------

   🧠 DESAFIO:

   Liste os produtos mais vendidos por quantidade.

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. O que significa “mais vendido” neste contexto?
   2. Onde está a quantidade vendida?
   3. Você precisa somar quantidades?
   4. Como relacionar produto com vendas?
   5. Como ordenar os resultados?

   ========================================================= */