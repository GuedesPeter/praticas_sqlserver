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
	Clientes que compraram nos últimos dois anos
   2. Onde está a data do pedido?
    Na tabela de Vendas/Pedidos
   3. Você precisa verificar existência ou ausência?
    Posso verificasr sim, se existem pedidos de um determinado cliente nos últimos dois anos
   4. A validação de data deve ocorrer dentro ou fora da subquery?
	Se eu for validar a existencia, ela deve ocorrer dentro da subquery
   5. Como garantir que clientes antigos (com pedidos antigos) sejam incluídos corretamente?
	O cenário visa identificar os clientes que não compram a bastante tempo, determinando que estes são identificados por não terem
	realizado pedidos nos últimos 2 anos.
	Clientes antigos serão considerados como recentes caso tenham algum pedido nos últimos 2 anos, do contrário, não estarão entre 
	os recentes.

   ========================================================= */
   SELECT
    C.CustomerID
FROM Sales.Customer AS C
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader AS H
    WHERE H.CustomerID = C.CustomerID
    AND H.OrderDate >= DATEADD(YEAR, -2, GETDATE())
);


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
	Pedidos de um mesmo cliente em anos distintos
   2. Como identificar anos distintos?
    Através de pedidos de um mesmo cliente realizados em anos diferentes.
	ex.: Pedido 1, realizado em 2012 / Pedido 2, realizado em 2013
   3. Você precisa eliminar duplicidades?
	Posso considerar o Id unico de cada pedido onde ao realizar os agrupamentos eliminariam chances de duplicidade pois não existem
	pedidos com Id(chave-primarias) repetidos.
   4. O agrupamento deve ocorrer por cliente ou por cliente+ano?
	Cliente e ano ou cliente,quantidade por ano
   5. O filtro ocorre antes ou depois da agregação?
	Realizaria contagem de pedidose separação por ano antes ou no momento da agragação.
	Não faria o Having após a agragação.
   ========================================================= */

SELECT
    CustomerID
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(DISTINCT YEAR(OrderDate)) > 1;

-- Nota: Se você quer contar "conceitos diferentes"
-- → use COUNT(DISTINCT ...)

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
   Na tabela de vendas, no campo LineTotal
   2. Você precisa somar valores por produto?
   Eu preciso somar o valor total dos produtos vendidos
   3. Como garantir que apenas produtos vendidos sejam considerados?
   Considerando a junção entre Produtos e Vendas, onde vou considerar apenas produtos que constam na tabela de vendas
   4. O filtro ocorre antes ou depois da soma?
   Depois da soma
   5. Você precisa combinar mais de uma tabela?
   Sim, tabela de Produtos e Tabela de Vendas

   ========================================================= */

   SELECT
		P.ProductID,
		SUM(S.LineTotal) AS Faturamento
   FROM [Production].[Product] P
   JOIN [Sales].[SalesOrderDetail] S
   ON S.ProductID = P.ProductID
   GROUP BY P.ProductID
   HAVING SUM(S.LineTotal) < 5000;

   -- Uma opção com formatação visual (para análise do setor de negócios)

    SELECT
		P.ProductID,
		FORMAT(SUM(S.LineTotal),'C','pt-BR') AS Faturamento
   FROM [Production].[Product] P
   JOIN [Sales].[SalesOrderDetail] S
   ON S.ProductID = P.ProductID
   GROUP BY P.ProductID
   HAVING SUM(S.LineTotal) < 5000
   ORDER BY SUM(S.LineTotal) DESC;

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
		Eu preciso verificar se o cliente possui ao menos 1 pedido com valor > 10000
   2. Isso é validação ou agregação?
		Validação
   3. Qual abordagem é mais simples e eficiente?
		verificar se o cliente possui ao menos 1 pedido com valor > 10000, garantindo assim que ele
		tenha realizado uma compra expressiva
   4. Você precisa agrupar resultados?
		Ao verificar a existencia já ocorre o agrupamento
   5. Como garantir que cada cliente apareça apenas uma vez?
		Ao realizar o agrupamento, validação ou distinção

   ========================================================= */

   SELECT 
	C.CustomerID
   FROM [Sales].[Customer] C
   WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] S
	WHERE S.CustomerID = C.CustomerID
	AND S.TotalDue > 10000
   )
   -- Opção com agregação
   SELECT
	CustomerID
   FROM [Sales].[SalesOrderHeader]
   WHERE TotalDue > 10000
   GROUP BY CustomerID

   -- Nota:
--	Se a pergunta for:
--“existe pelo menos um?”

--→ EXISTS

--Se a pergunta for:
--“quantos existem?”

--→ GROUP BY


/* =========================================================
   🧠 EX 5 — TERRITÓRIOS COM BAIXO VOLUME
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar regiões com baixo número de pedidos.

   Regra:
   👉 Território com menos de 500 pedidos

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. O que precisa ser contado?
	A quantidade de pedidos por território
   2. Onde está essa informação?
	Na tabela de Pedidos/Vendas
   3. Você precisa agrupar por qual campo?
	Preciso agrupar por territorio
   4. O filtro deve ser aplicado antes ou depois da contagem?
	Depois da contagem
   5. Qual função resolve esse problema?
	Posso resolver com COUNT() para contar os pedidos 

   ========================================================= */
   SELECT
	TerritoryID,
	COUNT(*) AS QtPedidos -- Ou COUNT(SalesOrderID)
   FROM [Sales].[SalesOrderHeader]
   GROUP BY TerritoryID
   HAVING COUNT(*) < 500
   ORDER BY QtPedidos;


/* =========================================================
   🧠 EX 6 — PRODUTOS COM DESCONTO
   =========================================================

   🎯 CENÁRIO:
   A empresa quer identificar produtos que já foram vendidos com desconto.

   ---------------------------------------------------------

   🧠 RACIOCÍNIO:

   1. Onde está a informação de desconto?
	Na tabela que contém os detalhes do Pedido/Venda
   2. Você precisa validar existência ou calcular algo?
	Posso validar se existem produtos vendidos com desconto
   3. O desconto é por pedido ou por item?
	No caso da tabela de detalhes da venda, o desconto ocorre por unidade do produto(item)
   4. Como relacionar produto com venda?
	Pelo ID do produto
   5. Você precisa retornar produtos únicos?
	Preciso retornar todos os produtos que foram vendidos com desconto
   ========================================================= */

   SELECT 
	P.ProductID,
	P.Name
   FROM [Production].[Product] P
   WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderDetail] S
	WHERE S.ProductID = P.ProductID
	AND S.UnitPriceDiscount > 0 -- Garante que houve desconto no valor unitário do produto
   );


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
	Na tabela de vendas, no campo TotalDue

   2. Você precisa somar por cliente?
	Preciso somar o faturamento de cada cliente para poder identificar os clientes mais lucrativos

   3. O filtro ocorre antes ou depois da soma?
	Ocorre após a soma

   4. Qual cláusula será usada para filtrar?
	Vou utilizar o HAVING para fazer o filtro

   5. Como ordenar os resultados para análise?
	Para isso vou utilizar a cláusula ORDER BY DESC, para assim ordenar do cliente mais lucrativo 
	para o menos lucrativo.(Ordenação na decrescente)

   ========================================================= */

   SELECT
	CustomerID,
	SUM(TotalDue) AS Faturamento
   FROM [Sales].[SalesOrderHeader]
   GROUP BY CustomerID
   HAVING SUM(TotalDue) > 100000
   ORDER BY Faturamento DESC;

   -- Opção visual para análise da empresa (Menos performática em produção)

   SELECT
	CustomerID,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Faturamento
   FROM [Sales].[SalesOrderHeader]
   GROUP BY CustomerID
   HAVING SUM(TotalDue) > 100000
   ORDER BY SUM(TotalDue) DESC;


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
	Utilizando a função YEAR()
   2. Você precisa de quantas métricas?
	Preciso saber a quantidade de pedidos, a soma total das vendas e seus respectivos anos de ocorrencia.

   3. Como combinar múltiplas agregações?
	Utilizando o agrupamento por ano.
	Assim as agregações serão exibidas ano a ano.

   4. Qual será o agrupamento?
	Se o desempenho é medido ao longo do tempo, o agrupamento deve ser realizado por ANO que é a medida de tempo pedida na análise.

   5. Como ordenar para facilitar análise?
	Posso ordenar por ano na descendente de modo a listar do ano mais atual para o mais antigo ou
	na ascendente para listar a ordem crescente permitindo a visualização ano a ano desde o inicio.

   ========================================================= */
   SELECT
	COUNT(SalesOrderID) AS QtPedidos,
	SUM(TotalDue) AS Faturamento,
	YEAR(OrderDate) AS Por_Ano
   FROM [Sales].[SalesOrderHeader]
   GROUP BY YEAR(OrderDate)
   ORDER BY Faturamento;

   -- Opção (Apenas para análise da diretoria)
   SELECT
	COUNT(SalesOrderID) AS QtPedidos,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Faturamento,
	YEAR(OrderDate) AS Por_Ano
   FROM [Sales].[SalesOrderHeader]
   GROUP BY YEAR(OrderDate)
   ORDER BY Por_Ano;


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
	A quantidade de pedidos por cliente
   2. Qual tabela contém essa informação?
	A tabela de Pedidos/Vendas
   3. Como agrupar corretamente?
	Agrupando por clientes
   4. Em qual momento aplicar o filtro?
	Após o agrupamento.
   5. Qual cláusula usar para isso?
	Vou usar o HAVING

   ========================================================= */

   SELECT
	CustomerID AS Cliente,
	COUNT(*) AS QtPedidos -- Também se aplica COUNT(SalesOrderID) 
   FROM [Sales].[SalesOrderHeader]
   GROUP BY CustomerID
   HAVING COUNT(*) > 20
   ORDER BY QtPedidos DESC; -- Evidencia os clientes com mais pedidos



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
	Acredito que sejam produtos que se repetem em vários pedidos
   2. Onde está a quantidade vendida?
	Na tabela de detalhes da Venda
   3. Você precisa somar quantidades?
	Preciso somar a quantidade de cada item dentro do pedido
   4. Como relacionar produto com vendas?
	Pelo Id do Produto
   5. Como ordenar os resultados?
   Na descendente para identificar o maior volume para o menor.

   ========================================================= */

   SELECT
	P.ProductID,
	SUM(S.OrderQty) AS QtItens
   FROM [Production].[Product] P
   JOIN [Sales].[SalesOrderDetail] S
	ON S.ProductID = P.ProductID
	GROUP BY P.ProductID
	ORDER BY QtItens DESC;

