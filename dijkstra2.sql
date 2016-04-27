DROP TABLE IF EXISTS Nodo;
CREATE TABLE Nodo (
  id_nodo int(11) NOT NULL AUTO_INCREMENT,
  name varchar(1) NOT NULL,
  PRIMARY KEY (id_nodo)
);

INSERT INTO Nodo (name) VALUES ('a');
INSERT INTO Nodo (name) VALUES ('b');
INSERT INTO Nodo (name) VALUES ('c');
INSERT INTO Nodo (name) VALUES ('d');
INSERT INTO Nodo (name) VALUES ('e');
INSERT INTO Nodo (name) VALUES ('f');

  
DROP TABLE IF EXISTS Arista;
CREATE TABLE Arista (
  id_arista int(11) NOT NULL AUTO_INCREMENT,
  nodo_a int(11) NOT NULL,
  nodo_b int(11) NOT NULL,
  peso int(11) NOT NULL,
  PRIMARY KEY (id_arista)
);

INSERT INTO Arista (nodo_a, nodo_b, peso) VALUES (1, 2, 3); # a--(3)--> b
INSERT INTO Arista (nodo_a, nodo_b, peso) VALUES (1, 3, 1); # a--(1)--> c
INSERT INTO Arista (nodo_a, nodo_b, peso) VALUES (2, 4, 1); # b--(1)--> d
INSERT INTO Arista (nodo_a, nodo_b, peso) VALUES (3, 5, 2); # c--(1)--> e
INSERT INTO Arista (nodo_a, nodo_b, peso) VALUES (4, 6, 1); # d--(1)--> f
INSERT INTO Arista (nodo_a, nodo_b, peso) VALUES (5, 6, 5); # d--(1)--> f


DROP PROCEDURE IF EXISTS dijkstra;

DELIMITER //
CREATE PROCEDURE dijkstra (startNode INT,endNode INT)
BEGIN
  DECLARE paso,nodoActual,papi,costo,pasoActual,hijoActual,costoHijo INT;
  SET paso = 0;
  SET nodoActual = startNode; 
  
  DROP TABLE IF EXISTS plan;
  CREATE TEMPORARY TABLE plan (
    paso int(11) NOT NULL,
    dondeViene int(11) NOT NULL,
    nodo int(11) NOT NULL,
    costo int(11) NOT NULL
  );
  DROP TABLE IF EXISTS camino; 
  CREATE TEMPORARY TABLE camino(
    de varchar(25) NOT NULL,
    a varchar(25) NOT NULL,
    costo int(11) NOT NULL
  );
  
  BEGIN
         
    
    INSERT INTO plan VALUES (0,-1, startNode,0);
    #INSERT INTO camino (nombre,costo) VALUES (startNode,0);
    
    
    guail: WHILE paso < 10 DO
      BEGIN  
        #cursor para recorrer los nodos en el paso actual
        DECLARE nodosListo INT DEFAULT FALSE;
        DECLARE nodos CURSOR FOR SELECT plan.dondeViene, plan.nodo, plan.costo FROM plan WHERE plan.paso = paso;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET nodosListo = TRUE;
        OPEN nodos;  
        loophijos: LOOP   #rrecorres todos los hijos del nodoActual    
          FETCH NEXT FROM nodos INTO papi, nodoActual, costo; #obtiene los datos de
          IF nodosListo THEN
            LEAVE loophijos;
          END IF;
          BEGIN
            DECLARE hijosListo INT DEFAULT FALSE;
            DECLARE hijos CURSOR FOR SELECT Arista.nodo_b, Arista.peso FROM Arista 
              WHERE Arista.nodo_a = nodoActual;      
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET hijosListo = TRUE;
            OPEN hijos;
            loopinsert: LOOP              
              FETCH NEXT FROM hijos INTO hijoActual, costoHijo;    
              IF hijosListo THEN
                LEAVE loopinsert;
              END IF;
              INSERT INTO plan VALUES (paso+1, nodoActual, hijoActual, costo+costoHijo);                        
            END LOOP;
            CLOSE hijos;
          END;
        END LOOP;             
      CLOSE nodos;
      END;
      
      
      /*BEGIN
        DECLARE nodos2Listo INT DEFAULT FALSE;
        DECLARE nodos2 CURSOR FOR SELECT * FROM plan WHERE paso = paso AND nodo != nodoActual;         
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET nodos2Listo = TRUE;
        OPEN nodos2;
        loopnodos2: LOOP            
          FETCH NEXT FROM nodos2 INTO pasoActual, papi, nodoActual, costo;
          IF nodos2Listo THEN
            LEAVE loopnodos2;
          END IF;
          INSERT INTO plan VALUES (pasoActual+1, papi, nodoActual, costo);
        END LOOP;  
        CLOSE nodos2;       
      END;*/
      
    SET paso = paso+1;
    SELECT MIN(plan.costo) FROM plan WHERE plan.paso = paso INTO costo;
      BEGIN
        # SELECT ... FROM plan INTO nodo, costo...
        DECLARE mejorListo INT DEFAULT FALSE;
        DECLARE mejor CURSOR FOR SELECT plan.nodo, plan.costo FROM plan 
          WHERE plan.paso = paso AND plan.costo = costo;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET mejorListo = TRUE;
        OPEN mejor;
        loopmejor: LOOP
          FETCH NEXT FROM mejor INTO nodoActual,costo;
          IF mejorListo THEN
            LEAVE loopmejor;
          END IF;
          # y si hay dos buenos caminos, cual elijo?
          #INSERT INTO camino (nombre,costo) VALUES (nodoActual,costo);
          IF nodoActual = endNode THEN
            CLOSE mejor;
            LEAVE guail;
          END IF;
        END LOOP;
        CLOSE mejor;
      END;
    END WHILE;  
    
    #quitable 
    SELECT * FROM plan ;
    WHILE paso > 0 DO
      SELECT MIN(plan.costo) FROM plan WHERE plan.paso = paso && plan.nodo = nodoActual INTO costo;
      SELECT plan.nodo, plan.dondeViene, plan.costo FROM plan 
        WHERE plan.paso = paso AND plan.nodo = nodoActual AND plan.costo = costo
        INTO nodoActual, papi, costo;
      INSERT INTO camino VALUES (papi, nodoActual, costo);
      SET nodoActual = papi;
      SET paso = paso-1;
    END WHILE;
    
  END;
  SELECT * FROM plan ;
  SELECT * FROM camino ORDER BY camino.costo;
END//
DELIMITER ;