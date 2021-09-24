--PROCEDURES

--1. INSERIMENTO DI UNA NUOVA PIZZA (parametri: nome, prezzo)
CREATE PROCEDURE InserisciPizza
@nome NVARCHAR(50),
@prezzo DECIMAL(5,2)

AS
BEGIN
	BEGIN TRY

	INSERT INTO Pizza VALUES(@nome, @prezzo)

	END TRY
	BEGIN CATCH

	SELECT ERROR_MESSAGE(), ERROR_LINE()

	END CATCH
END

EXECUTE InserisciPizza 'Prosciutto e Funghi', 6.80

--2. ASSEGNAZIONE DI UN INGREDIENTE A UNA PIZZA (parametri: nome pizza, nome ingrediente)
CREATE PROCEDURE AssegnaIngrediente
@nomePizza NVARCHAR(50),
@nomeIngr NVARCHAR(50)

AS
BEGIN
	BEGIN TRY

	DECLARE @IdPizza INT
	DECLARE @IdIngrediente INT

	SELECT @IdPizza = IdPizza
	FROM Pizza
	WHERE Nome = @nomePizza

	SELECT @IdIngrediente = IdIngrediente
	FROM Ingrediente
	WHERE Nome = @nomeIngr
	

	INSERT INTO Composizione VALUES(@IdPizza, @IdIngrediente)

	END TRY
	BEGIN CATCH

	SELECT ERROR_MESSAGE(), ERROR_LINE()

	END CATCH
END

EXECUTE AssegnaIngrediente 'Prosciutto e Funghi', 'Cotto'

--3. AGGIORNAMENTO DEL PREZZO DI UNA PIZZA (parametri: nome pizza e nuovo prezzo)
CREATE PROCEDURE AggiornaPrezzo
@pizza NVARCHAR(50),
@nuovoPrezzo DECIMAL(5,2)

AS
BEGIN
	BEGIN TRY

	DECLARE @idPizza INT

	SELECT @IdPizza = IdPizza
	FROM Pizza
	WHERE Nome = @pizza

	UPDATE Pizza SET Prezzo = @nuovoPrezzo WHERE IdPizza = @idPizza

	END TRY
	BEGIN CATCH

	SELECT ERROR_MESSAGE(), ERROR_LINE()

	END CATCH
END

EXECUTE AggiornaPrezzo 'Porcini', 7.50

--4. ELIMINAZIONE DI UN INGREDIENTE DA UNA PIZZA (parametri: nome pizza, nome ingrediente)
CREATE PROCEDURE EliminaIngrediente
@pizza NVARCHAR(50),
@ingrediente NVARCHAR(50)

AS
BEGIN
	BEGIN TRY

	DECLARE @idPizza INT
	DECLARE @idIngr INT

	SELECT @idPizza = IdPizza
	FROM Pizza
	WHERE Nome = @pizza

	SELECT @idIngr = IdIngrediente
	FROM Ingrediente
	WHERE Nome = @ingrediente

	DELETE FROM Composizione WHERE IdPizza = @idPizza AND IdIngrediente = @idIngr

	END TRY
	BEGIN CATCH

	SELECT ERROR_MESSAGE(), ERROR_LINE()

	END CATCH
END

EXECUTE EliminaIngrediente 'Quattro Stagioni', 'Carciofi'

--5. INCREMENTO DEL 10% DEL PREZZO DELLE PIZZE CONTENENTI UN INGREDIENTE (parametro: nome ingrediente)
CREATE PROCEDURE IncrementaPrezzo
@ingrediente NVARCHAR(50)

AS
BEGIN
	BEGIN TRY

	DECLARE @idIngrediente INT

	SELECT @idIngrediente = IdIngrediente
	FROM Ingrediente
	WHERE Nome = @ingrediente

	UPDATE Pizza SET Prezzo = Prezzo*(1.10) 
	WHERE IdPizza IN (SELECT c.IdPizza FROM Composizione c
						WHERE c.IdIngrediente = @idIngrediente)

	END TRY
	BEGIN CATCH

	SELECT ERROR_MESSAGE(), ERROR_LINE()

	END CATCH
END

EXECUTE IncrementaPrezzo 'Mozzarella di Bufala'
EXECUTE IncrementaPrezzo 'Rucola'

SELECT * FROM Ingrediente
SELECT * FROM Pizza
select * from Composizione