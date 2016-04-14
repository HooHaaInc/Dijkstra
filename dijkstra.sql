-- MySQL dump 10.13  Distrib 5.6.26, for Linux (x86_64)
--
-- Host: localhost    Database: e5ingsoft2
-- ------------------------------------------------------

DROP TABLE IF EXISTS 'Nodo';
CREATE TABLE 'Nodo' (
  'id_nodo' int(11) NOT NULL AUTO_INCREMENT,
  'name' varchar(1) NOT NULL,
  PRIMARY KEY ('id_nodo'),
);

DROP TABLE IF EXISTS 'Arista';
CREATE TABLE 'Arista' (
  'id_arista' int(11) NOT NULL AUTO_INCREMENT,
  'nodo_a' int(11) NOT NULL,
  'nodo_b' int(11) NOT NULL,
  'peso' int(11) NOT NULL,
  PRIMARY KEY ('id_arista'),
);

CREATE FUNCTION dijkstra(@startNode int, @endNode int)
RETURNS INT
BEGIN
	DECLARE paso int = 0;
	CREATE TEMPORARY TABLE plan(
		'paso' int(11) NOT NULL,
		'donde' int(11) NOT NULL,
		'nodo' int(11) NOT NULL,
		'costo' int(11) NOT NULL,
		FOREIGN KEY ('donde') REFERENCES 'Nodo'('id_nodo'),
		FOREIGN KEY ('nodo') REFERENCES 'Nodo'('id_nodo')
	);

	INSERT INTO plan VALUES (0, -1, startNode, 0);

	DECLARE fin boolean = startNode == endNode;
	DECLARE pasoActual int, nodoActual int, papi int, costo int;
	WHILE !fin DO
		DECLARE nodos CURSOR FOR SELECT 'nodo' FROM 'plan' WHERE 'paso' = paso;
		LOOP
			FETCH nodos INTO pasoActual, papi, nodoActual, costo;
			DECLARE hijos CURSOR FOR SELECT * FROM 'Arista' WHERE 'nodo_a' = nodoActual;
			
			LOOP
				FETCH hijos INTO
			END LOOP
		END LOOP;

	END

END


