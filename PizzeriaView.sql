--VIEWS


--VISTA DEL MENù CON TUTTI I DATI
CREATE VIEW VistaGenerale(Pizza, [Prezzo Pizza], Ingrediente, [Costo Ingrediente], [Numero Scorte], [Unità di Misura])
AS(
	SELECT p.Nome AS Pizza, p.Prezzo as [Prezzo Pizza], i.Nome as Ingrediente, i.Costo AS [Costo Ingrediente],
		   i.NumeroScorte AS [Numero Scorte], i.UnitaMisura AS [Unità di Misura]
	FROM Pizza p
	JOIN Composizione c ON c.IdPizza = p.IdPizza
	JOIN Ingrediente i ON i.IdIngrediente = c.IdIngrediente
)

SELECT *
FROM VistaGenerale

--VISTA DEL MENù INGREDIENTI DIVISI PER PIZZA
CREATE FUNCTION ListaIngredientiPerPizza(@pizza NVARCHAR(50))
RETURNS NVARCHAR(MAX) 
AS
BEGIN
DECLARE @listaIngredienti NVARCHAR(MAX) --PER CONSIDERARE LA LISTA COME UN UNICA STRINGA
SELECT @listaIngredienti = COALESCE(@listaIngredienti + ', ' + i.Nome, i.Nome) --@listaIngredienti dà una stringa con valori separati da ','
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON i.IdIngrediente = c.IdIngrediente
WHERE p.Nome = @pizza

RETURN @listaIngredienti
END

-- SELECT dbo.ListaIngredientiPerPizza('Margherita')

CREATE VIEW VistaIngredientiUnitiPerPizza(Pizza, [Prezzo Pizza], Ingredienti)
AS(
	SELECT DISTINCT p.Nome AS Pizza, p.Prezzo as [Prezzo Pizza], dbo.ListaIngredientiPerPizza(p.Nome) as Ingredienti
	FROM Pizza p
	JOIN Composizione c ON c.IdPizza = p.IdPizza
	JOIN Ingrediente i ON i.IdIngrediente = c.IdIngrediente
)

SELECT *
FROM VistaIngredientiUnitiPerPizza