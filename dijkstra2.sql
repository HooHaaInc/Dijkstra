DROP TABLE IF EXISTS Nodo;
CREATE TABLE Nodo (
  id_nodo int(11) NOT NULL AUTO_INCREMENT,
  name varchar(1) NOT NULL,
  PRIMARY KEY (id_nodo)
);

DROP TABLE IF EXISTS Arista;
CREATE TABLE Arista (
  id_arista int(11) NOT NULL AUTO_INCREMENT,
  nodo_a int(11) NOT NULL,
  nodo_b int(11) NOT NULL,
  peso int(11) NOT NULL,
  PRIMARY KEY (id_arista)
);


DROP PROCEDURE IF EXISTS dijkstra;
CREATE PROCEDURE dijkstra(startNode INT,endNode INT)
BEGIN
CREATE TEMPORARY TABLE plan(
    paso int(11) NOT NULL,
    donde_viene int(11) NOT NULL,
    nodo int(11) NOT NULL,
    costo int(11) NOT NULL,
    FOREIGN KEY (donde_viene) REFERENCES Nodo(id_nodo),
    FOREIGN KEY (nodo) REFERENCES Nodo(id_nodo)
  );
#  DROP TABLE IF EXISTS camino; 
  CREATE TEMPORARY TABLE camino(
    id int(11) NOT NULL,
    nombre varchar(25) NOT NULL,
    costo int(11) NOT NULL,
    PRIMARY KEY (id)
  );

BEGIN
  DECLARE paso INT DEFAULT 0;  
  DECLARE nodoActual INT;
  DECLARE papi INT;  
  DECLARE costo INT;
  DECLARE pasoActual INT;  
      
  DECLARE hijoActual INT;
  DECLARE costoHijo INT;        
  DECLARE endNode INT;
  SET nodoActual = StarNode;      
  
  INSERT INTO plan VALUES (0,-1, startNode,0);
  INSERT INTO camino (nombre,costo) VALUES (startNode,0);
  
  WHILE (nodoActual != endNode) do
  BEGIN  
    DECLARE nodos CURSOR FOR SELECT * FROM plan WHERE paso = paso AND nodo = nodoActual;
    OPEN nodos;  
    FETCH NEXT FROM nodos INTO pasoActual, papi, nodoActual, costo; #obtiene los datos de
    WHILE @@FETCH_STATUS = 0#rrecorres todos los hijos del nodoActual    
    BEGIN
      DECLARE hijos CURSOR FOR SELECT nodo_b, costo FROM Arista WHERE nodo_a = nodoActual;      
      OPEN hijos;
      FETCH NEXT FROM hijos INTO hijoActual, costoHijo;    
      WHILE @@FETCH_STATUS = 0                
            
            INSERT INTO plan VALUES (paso+1, nodoActual, hijoActual, costo+costoHijo);                        
            FETCH NEXT FROM hijos INTO hijoActual, costoHijo;
      END ;          
      FETCH NEXT FROM nodos INTO pasoActual, papi, nodoActual, costo; #obtiene los datos de
    END;
    #END;
    
     
    BEGIN
         DECLARE nodos2 CURSOR FOR SELECT * FROM plan WHERE paso = paso AND nodo != nodoActual;         
         OPEN nodos2;
         WHILE @@FETCH_STATUS = 0             
         FETCH NEXT FROM nodos2 INTO pasoActual, papi, nodoActual, costo;
         BEGIN
              INSERT INTO plan VALUES (pasoActual+1, papi, nodoActual, costo);
              FETCH NEXT FROM nodos2 INTO pasoActual, papi, nodoActual, costo;
         END;         
    END    
    BEGIN
         DECLARE mejor CURSOR FOR SELECT nodo, costo FROM plan WHERE paso = paso ORDER BY costo;
         OPEN mejor;
         FETCH NEXT FROM mejor INTO nodoActual,costo;

         INSERT INTO camino (nombre,costo) VALUES (nodoActual,costo);
     END
  END;  

  #CLOSE nodos;

  #DEALLOCATE nodos;
  
  END;
END;
