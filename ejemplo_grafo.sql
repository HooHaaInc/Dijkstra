DROP PROCEDURE IF EXISTS crear_grafo;

DELIMITER //
CREATE PROCEDURE crear_grafo (startNode CHAR,endNode CHAR)
BEGIN

    INSERT INTO Nodo VALUES ('a');
    INSERT INTO Nodo VALUES ('b');
    INSERT INTO Nodo VALUES ('c');
    INSERT INTO Nodo VALUES ('d');
    INSERT INTO Nodo VALUES ('e');
    INSERT INTO Nodo VALUES ('f');


    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES ('a', 'b', 3); # a--(3)--> b
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES ('a', 'c', 1); # a--(1)--> c
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES ('b', 'd', 1); # b--(1)--> d
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES ('c', 'e', 2); # c--(2)--> e
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES ('d', 'f', 1); # d--(1)--> f
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES ('e', 'f', 5); # e--(5)--> f

END//

DELIMITER ;
