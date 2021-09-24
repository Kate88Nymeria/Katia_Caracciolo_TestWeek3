--QUERIES

--1. ESTRARRE TUTTE LE PIZZE CON PREZZO SUPERIORE A 6 EURO
SELECT Nome as Pizza, Prezzo
FROM Pizza
WHERE Prezzo > 6

--2. ESTRARRE LA PIZZA PIù COSTOSA
SELECT Nome as Pizza, Prezzo
FROM Pizza
WHERE Prezzo >= ALL (SELECT MAX(Prezzo)
				 FROM Pizza
				 GROUP BY Prezzo
				 )

--3. ESTRARRE LE PIZZE BIANCHE
SELECT DISTINCT p.Nome AS Pizza
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
WHERE i.Nome != 'Pomodoro' AND p.Nome NOT IN (SELECT p.Nome AS Pizza
											  FROM Pizza p
											  JOIN Composizione c ON c.IdPizza = p.IdPizza
											  JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
											  WHERE i.Nome = 'Pomodoro')

--4. ESTRARRE LE PIZZE CHE CONTENGONO FUNGHI (di qualsiasi tipo)
SELECT p.Nome AS Pizza
FROM Pizza p
JOIN Composizione c ON c.IdPizza = p.IdPizza
JOIN Ingrediente i ON c.IdIngrediente = i.IdIngrediente
WHERE c.IdIngrediente IN (SELECT IdIngrediente
						  FROM Ingrediente
						  WHERE Nome LIKE 'Funghi%')