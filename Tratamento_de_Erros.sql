
USE AdventureWorks
GO

/************************************************************************
SQL SERVER - TRATAMENTO DE ERROS E CONTROLE DE TRANSAÇÕES

👉 DICA! Faça na ordem para evoluir gradualmente:
1 → 2 → 5 → 6 → 8 → 9 → 4 → 3 → 10 → 7
************************************************************************/

-- 1. Exercício: Tratamento de erro com TRY...CATCH
-- Descrição: Crie um procedimento armazenado que insira um novo produto na tabela [Production].[Product]. 
-- O procedimento deve verificar se o [ProductNumber] já existe na tabela. Caso exista, o erro deve ser capturado e 
-- uma mensagem personalizada de erro deve ser retornada.
-- Utilize TRY...CATCH para capturar qualquer erro durante a inserção e retornar uma mensagem apropriada.

-- 2. Exercício: Validando NULL em dados inseridos
-- Descrição: Crie uma consulta que atualize os dados de um cliente na tabela [Sales].[Customer]. 
-- Antes de realizar a atualização, valide se o campo [EmailAddress] não é NULL. Se for NULL, a operação de atualização 
-- deve ser interrompida e uma mensagem de erro deve ser exibida para o usuário, usando TRY...CATCH.

-- 3. Exercício: Usando ROLLBACK em transações com erro
-- Descrição: Crie um bloco de código que insira dados na tabela [Production].[Product] e [Production].[ProductSubcategory]. 
-- Se a inserção na tabela [ProductSubcategory] falhar (por exemplo, devido a violação de chave estrangeira), 
-- a transação inteira deve ser revertida com um ROLLBACK e um erro apropriado deve ser gerado usando TRY...CATCH.

-- 4. Exercício: Verificação de NULL em condições de atualização
-- Descrição: Crie uma consulta que atualize o preço de todos os produtos na tabela [Production].[Product] 
-- onde o campo [StandardCost] não é NULL. Se o campo [StandardCost] for NULL, uma exceção personalizada 
-- deve ser gerada informando que o preço de custo não pode ser NULL para produtos selecionados.

-- 5. Exercício: Tratando erros de conversão de tipo de dados
-- Descrição: Crie um código que tente inserir um valor de tipo incompatível na tabela [HumanResources].[Employee]. 
-- Por exemplo, tente inserir uma string no campo [EmployeeID], que é do tipo INT. O erro deve ser tratado com TRY...CATCH 
-- e uma mensagem de erro personalizada deve ser retornada ao usuário.

-- 6. Exercício: Tratamento de erro para violação de chave primária
-- Descrição: Crie um bloco de código que tente inserir um novo registro na tabela [Sales].[SalesOrderDetail]. 
-- O código deve verificar se a chave primária ([SalesOrderID] e [SalesOrderDetailID]) já existe na tabela.
-- Caso exista, um erro deve ser lançado e capturado com TRY...CATCH, retornando uma mensagem informando a duplicação de chave.

-- 7. Exercício: Tratamento de erro com múltiplos blocos de CATCH
-- Descrição: Crie um procedimento armazenado que envolva a inserção de dados nas tabelas [Production].[Product] e 
-- [Sales].[SalesOrderHeader]. No bloco CATCH, diferentes tipos de erro devem ser tratados separadamente, 
-- como erros de violação de chave estrangeira e erros de violação de restrições de dados. Cada tipo de erro deve 
-- gerar uma mensagem de erro específica.

-- 8. Exercício: Lidando com dados duplicados usando TRY...CATCH
-- Descrição: Crie uma consulta que insira vários registros na tabela [Sales].[Customer]. 
-- Caso a inserção falhe devido à duplicação de dados (por exemplo, duplicação do [CustomerID]), 
-- o erro deve ser capturado e o processo de inserção deve ser interrompido. Utilize TRY...CATCH para capturar o erro.

-- 9. Exercício: Tratamento de erro para divisões por zero
-- Descrição: Crie um código que realize uma operação de divisão utilizando o valor de [TotalDue] 
-- da tabela [Sales].[SalesOrderHeader]. Caso o valor seja 0 ou NULL, a divisão não deve ser realizada, 
-- e o erro deve ser tratado adequadamente com TRY...CATCH, evitando a falha da consulta.

-- 10. Exercício: Gerenciamento de erro em transações com COMMIT/ROLLBACK
-- Descrição: Crie um código que realize a atualização de preço para um grupo de produtos da tabela [Production].[Product]. 
-- A atualização deve ser feita dentro de uma transação, e caso ocorra um erro durante a execução, 
-- a transação deve ser revertida com ROLLBACK. Se não houver erro, o código deve realizar o COMMIT. 
-- Certifique-se de capturar o erro com TRY...CATCH e garantir que a transação seja tratada corretamente.