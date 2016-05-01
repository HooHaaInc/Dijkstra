DROP TABLE IF EXISTS Nodo;
CREATE TABLE Nodo (
  id_nodo int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(20) NOT NULL,
  PRIMARY KEY (id_nodo),
  UNIQUE KEY name (nombre)
);

  
DROP TABLE IF EXISTS Arista;
CREATE TABLE Arista (
  id_arista int(11) NOT NULL AUTO_INCREMENT,
  nodo_a int(11) NOT NULL,
  nodo_b int(11) NOT NULL,
  costo float(10,2) NOT NULL,
  PRIMARY KEY (id_arista)
);

DROP PROCEDURE IF EXISTS dijkstra;

DELIMITER //
CREATE PROCEDURE dijkstra (startNode VARCHAR(20),endNode VARCHAR(20))
BEGIN
  DECLARE costo,costoHijo,costoAux FLOAT DEFAULT 0;
  DECLARE startId, endId, paso,nodoActual,papi,hijoActual INT DEFAULT 0;
  SELECT Nodo.id_nodo FROM Nodo WHERE Nodo.nombre = startNode INTO startId;
  SELECT Nodo.id_nodo FROM Nodo WHERE Nodo.nombre = endNode INTO endId;
  SET nodoActual = startId;
  
  DROP TABLE IF EXISTS plan;
  CREATE TEMPORARY TABLE plan (
    #paso int(11) NOT NULL,
    seleccionado int(11) DEFAULT -1,
    dondeViene int(11) DEFAULT NULL,
    nodo int(11) NOT NULL,
    costo float(12,2) NOT NULL DEFAULT 999999999.99 #max signed int
  );
  
  DROP TABLE IF EXISTS camino; 
  CREATE TEMPORARY TABLE camino(
    de varchar(20) NOT NULL,
    a varchar(20) NOT NULL,
    costo float(12,2) NOT NULL
  );
  
  
  BEGIN
    DECLARE nodoId INT;
    DECLARE initListo INT DEFAULT FALSE;
    DECLARE init CURSOR FOR SELECT Nodo.id_nodo FROM Nodo 
        WHERE Nodo.id_nodo != startId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET initListo = TRUE;
    #inserta el nodo inciial
    INSERT INTO plan (plan.seleccionado, plan.nodo, plan.costo) 
      VALUES(0, startId, 0);
    OPEN init;
    loopinit: LOOP
      FETCH NEXT FROM init INTO nodoId;
      IF initListo THEN
          LEAVE loopinit;
      END IF;
      INSERT INTO plan (plan.nodo) VALUES (nodoId);
    END LOOP;
    CLOSE init;
  END;
  #nomas por si se cicla
  guail: WHILE paso < 10000 DO
    #sacamos los datos del nodo actual
    #SELECT * FROM plan;
    SET paso = paso+1;
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
  
  BEGIN
    DECLARE nextCursor CURSOR FOR SELECT plan.nodo FROM plan 
      WHERE plan.seleccionado = -1 ORDER BY plan.costo;
    OPEN nextCursor;
    FETCH NEXT FROM nextCursor INTO nodoActual;
    CLOSE nextCursor;
    UPDATE plan SET plan.seleccionado = paso WHERE plan.nodo = nodoActual;
    IF nodoActual = endId THEN
      LEAVE guail;
    END IF;
  END;
  END WHILE;  
  
  BEGIN
    DECLARE actualName, papiName VARCHAR(20);
    WHILE nodoActual != startId DO
        SELECT plan.dondeViene, plan.costo FROM plan 
        WHERE plan.nodo = nodoActual INTO papi, costo;
        SELECT Nodo.nombre FROM Nodo WHERE Nodo.id_nodo = nodoActual INTO actualName;
        SELECT Nodo.nombre FROM Nodo WHERE Nodo.id_nodo = papi INTO papiName;
        INSERT INTO camino VALUES (papiName, actualName, costo);
        SET nodoActual = papi;
    END WHILE;
  END;
    
#debug
  SELECT * FROM camino ORDER BY camino.costo;
  DROP TABLE camino;
  DROP TABLE plan;
END//
DELIMITER ;