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
    'donde_viene' int(11) NOT NULL,
    'nodo' int(11) NOT NULL,
    'costo' int(11) NOT NULL,
    FOREIGN KEY ('donde_viene') REFERENCES 'Nodo'('id_nodo'),
    FOREIGN KEY ('nodo') REFERENCES 'Nodo'('id_nodo')
  );

  CREATE TEMPORARY TABLE camino(
    'id' int(11) NOT NULL,
    'nombre' varchar(25) NOT NULL,
    'costo' int(11) NOT NULL,
    PRIMARY KEY ('id');
  );

  INSERT INTO plan VALUES (0,-1, startNode,0);

  DECLARE fin boolean = startNode == endNode;
  
  INSERT INTO camino (nombre,costo) VALUES (startNode,0);

  DECLARE pasoActual int, nodoActual int = startNode, papi int, costo int;
  DECLARE hijoActual int, costoHijo int;
  WHILE !fin DO
    DECLARE nodos CURSOR FOR SELECT * FROM 'plan' WHERE 'paso' = paso AND 'nodo' = nodoActual;
    LOOP
      FETCH nodos INTO pasoActual, papi, nodoActual, costo;
      DECLARE hijos CURSOR FOR SELECT 'nodo_b', 'costo' FROM 'Arista' WHERE 'nodo_a' = nodoActual;
      
      LOOP
        FETCH hijos INTO hijoActual, costoHijo;
        INSERT INTO plan VALUES (paso+1, nodoActual, hijoActual, costo+costoHijo);
      END LOOP
    END LOOP  
    DECLARE nodos2 CURSOR FOR SELECT * FROM 'plan' WHERE 'paso' = paso AND 'nodo' != nodoActual;
    LOOP
      FETCH nodos2 INTO pasoActual, papi, nodoActual, costo;
      INSERT INTO plan VALUES (pasoActual+1, papi, nodoActual, costo);

    END LOOP;
    DECLARE mejor CURSOR FOR SELECT 'nodo', 'costo' FROM 'plan' WHERE 'paso' = paso ORDER BY 'costo';

    FETCH mejor INTO nodoActual,costo;

    INSERT INTO camino (nombre,costo) VALUES (nodoActual,costo);
    fin = nodoActual == endNode;

  END

END
