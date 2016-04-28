DROP TABLE IF EXISTS Nodo;
CREATE TABLE Nodo (
  id_nodo varchar(1) NOT NULL,
  PRIMARY KEY (id_nodo)
);

  
DROP TABLE IF EXISTS Arista;
CREATE TABLE Arista (
  id_arista int(11) NOT NULL AUTO_INCREMENT,
  nodo_a char(1) NOT NULL,
  nodo_b char(1) NOT NULL,
  costo int(11) NOT NULL,
  PRIMARY KEY (id_arista)
);

DROP PROCEDURE IF EXISTS dijkstra;

DELIMITER //
CREATE PROCEDURE dijkstra (startNode CHAR,endNode CHAR)
BEGIN
  DECLARE paso,costo,costoHijo,costoAux INT DEFAULT 0;
  DECLARE nodoActual,papi,hijoActual CHAR;
  SET nodoActual = startNode; 
  
  DROP TABLE IF EXISTS plan;
  CREATE TEMPORARY TABLE plan (
    #paso int(11) NOT NULL,
    seleccionado boolean DEFAULT FALSE,
    dondeViene char(1) DEFAULT NULL,
    nodo char(1) NOT NULL,
    costo int(11) NOT NULL DEFAULT 1024
  );
  
  DROP TABLE IF EXISTS camino; 
  CREATE TEMPORARY TABLE camino(
    de char(1) NOT NULL,
    a char(1) NOT NULL,
    costo int(11) NOT NULL
  );
  
  
  BEGIN
    DECLARE nodoName CHAR;
    DECLARE initListo INT DEFAULT FALSE;
    DECLARE init CURSOR FOR SELECT Nodo.id_nodo FROM Nodo 
        WHERE Nodo.id_nodo != startNode;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET initListo = TRUE;
    INSERT INTO plan (plan.seleccionado, plan.nodo, plan.costo) 
      VALUES(TRUE, startNode, 0);
    OPEN init;
    loopinit: LOOP
      FETCH NEXT FROM init INTO nodoName;
      IF initListo THEN
          LEAVE loopinit;
      END IF;
      INSERT INTO plan (plan.nodo) VALUES (nodoName);
    END LOOP;
    CLOSE init;
  END;
  
  #nomas por si se cicla
  guail: WHILE paso < 10000 DO
    #sacamos los datos del nodo actual
    SELECT plan.dondeViene, plan.costo FROM plan WHERE plan.nodo = nodoActual
      INTO papi, costo;
    BEGIN
      DECLARE hijosListo INT DEFAULT FALSE;
      DECLARE costoViejo INT;
      #hijos del nodo
      DECLARE hijos CURSOR FOR SELECT Arista.nodo_b, Arista.costo FROM Arista 
        WHERE Arista.nodo_a = nodoActual;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET hijosListo = TRUE;
      OPEN hijos;
      loopinsert: LOOP              
        FETCH NEXT FROM hijos INTO hijoActual, costoHijo;    
        IF hijosListo THEN
          LEAVE loopinsert;
        END IF;
        SELECT plan.costo FROM plan WHERE plan.nodo = hijoActual INTO costoViejo;
        #solo update si es mejor
        IF costoViejo > costoHijo+costo THEN
          UPDATE plan SET plan.dondeViene =  nodoActual,
            plan.costo = costo+costoHijo
            WHERE plan.nodo = hijoActual;
        END IF;
      END LOOP;
      CLOSE hijos;
    END;  
    
  SET paso = paso+1;
  BEGIN
    DECLARE nextCursor CURSOR FOR SELECT plan.dondeViene, plan.nodo, plan.costo FROM plan 
      WHERE plan.seleccionado = FALSE ORDER BY plan.costo;
    OPEN nextCursor;
    FETCH NEXT FROM nextCursor INTO papi, nodoActual, costo;
    CLOSE nextCursor;
    UPDATE plan SET plan.seleccionado = TRUE WHERE plan.nodo = nodoActual;
    IF nodoActual = endNode THEN
      LEAVE guail;
    END IF;
  END;
  END WHILE;  
  
  WHILE nodoActual != startNode DO
    SELECT plan.dondeViene, plan.costo FROM plan 
      WHERE plan.nodo = nodoActual INTO papi, costo;
    INSERT INTO camino VALUES (papi, nodoActual, costo);
    SET nodoActual = papi;
  END WHILE;
    
  SELECT * FROM plan;
  SELECT * FROM camino ORDER BY camino.costo;
END//
DELIMITER ;