--FUNCTIONS

--1.	Tabella listino pizze (nome, prezzo) ordinato alfabeticamente (parametri: nessuno) 
CREATE FUNCTION ListinoPizze()
RETURNS TABLE
AS
RETURN

SELECT DISTINCT p.Nome AS Pizza, p.Prezzo
FROM Pizza p

SELECT *
FROM dbo.ListinoPizze() AS Listino
ORDER BY Pizza

--2.	Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome ingrediente) 
CREATE FUNCTION ListinoPizzeConIngrediente(@ingrediente NVARCHAR(50))
RETURNS TABLE
AS
RETURN

SELECT DISTINCT p.Nome AS Pizza, p.Prezzo
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
WHERE i.Nome = @ingrediente

SELECT *
FROM dbo.ListinoPizzeConIngrediente('Rucola')

--3.	Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente (parametri: nome ingrediente) 
CREATE FUNCTION ListinoPizzeSenzaIngrediente(@ingrediente NVARCHAR(50))
RETURNS TABLE
AS
RETURN

SELECT DISTINCT p.Nome AS Pizza
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
WHERE i.Nome != @ingrediente AND p.Nome NOT IN (SELECT p.Nome AS Pizza
											    FROM Pizza p
											    JOIN Composizione c ON c.IdPizza = p.IdPizza
											    JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
											    WHERE i.Nome = @ingrediente)

SELECT *
FROM dbo.ListinoPizzeSenzaIngrediente('Pomodoro')

--4.	Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente) 
CREATE FUNCTION NumeroPizzeConIngrediente(@ingrediente NVARCHAR(50))
RETURNS INT
AS
BEGIN
DECLARE @numeroPizze INT

SELECT @numeroPizze = COUNT(*)
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
WHERE i.Nome = @ingrediente

RETURN @numeroPizze
END

SELECT dbo.NumeroPizzeConIngrediente('Rucola') AS [Pizze con Rucola]

--5.	Calcolo numero pizze che non contengono un ingrediente (parametri: codice ingrediente) 
CREATE FUNCTION NumeroPizzeSenzaIngrediente(@ingrediente NVARCHAR(50))
RETURNS INT
AS
BEGIN
DECLARE @numeroPizze INT

SELECT @numeroPizze = COUNT(*)
FROM (SELECT DISTINCT p.Nome
	  FROM Pizza p
	  JOIN Composizione c ON c.IdPizza = p.IdPizza
	  JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
	  WHERE i.Nome != @ingrediente AND p.Nome NOT IN (SELECT p.Nome AS Pizza
	   											      FROM Pizza p
													  JOIN Composizione c ON c.IdPizza = p.IdPizza
													  JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
													  WHERE i.Nome =@ingrediente
													  ) 
	 )PizzaSenzaIngr
WHERE PizzaSenzaIngr.Nome IS NOT NULL

RETURN @numeroPizze
END

SELECT dbo.NumeroPizzeSenzaIngrediente('Pomodoro') AS [Pizze senza Pomodoro]
SELECT dbo.NumeroPizzeSenzaIngrediente('Mozzarella') AS [Pizze senza Mozzarella]

--6.	Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza) 
CREATE FUNCTION NumeroIngredientiPizza(@pizza NVARCHAR(50))
RETURNS INT
AS
BEGIN
DECLARE @numeroIngredienti INT

SELECT @numeroIngredienti = COUNT(i.Nome)
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
WHERE p.Nome = @pizza

RETURN @numeroIngredienti
END

SELECT dbo.NumeroIngredientiPizza('Margherita') AS [Numero Ingredienti Margherita]
SELECT dbo.NumeroIngredientiPizza('Dioniso') AS [Numero Ingredienti Dioniso]