
DELETE FROM Nodo;
DELETE FROM Arista;

INSERT INTO Nodo (nombre) VALUES ('Hermosillo');    #1
INSERT INTO Nodo (nombre) VALUES ('Santa Ana');     #2
INSERT INTO Nodo (nombre) VALUES ('Nogales');       #3
INSERT INTO Nodo (nombre) VALUES ('Caborca');       #4
INSERT INTO Nodo (nombre) VALUES ('Puerto Peñasco');#5
INSERT INTO Nodo (nombre) VALUES ('Cananea');       #6
INSERT INTO Nodo (nombre) VALUES ('Agua Prieta');   #7
INSERT INTO Nodo (nombre) VALUES ('Bahia de Kino'); #8
INSERT INTO Nodo (nombre) VALUES ('Guaymas');       #9
INSERT INTO Nodo (nombre) VALUES ('Obregon');       #10
INSERT INTO Nodo (nombre) VALUES ('Yecora');        #11
INSERT INTO Nodo (nombre) VALUES ('Navojoa');       #12
INSERT INTO Nodo (nombre) VALUES ('Huatabampo');    #13
INSERT INTO Nodo (nombre) VALUES ('Alamos');        #14
INSERT INTO Nodo (nombre) VALUES ('Ures');          #15

DROP PROCEDURE IF EXISTS addArista;

DELIMITER //

CREATE PROCEDURE addArista(aId INT, bId INT, costo FLOAT)
BEGIN
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES(aId, bId, costo);
    INSERT INTO Arista (nodo_a, nodo_b, costo) VALUES(bId, aId, costo);
END//

DELIMITER ;

CALL addArista(1, 2, 173);
CALL addArista(1, 15, 79);
CALL addArista(1, 8, 108);
CALL addArista(1, 9, 135);
CALL addArista(1, 10, 250);
CALL addArista(1, 11, 281);
CALL addArista(2, 3, 107);
CALL addArista(2, 4, 112);
CALL addArista(2, 6, 126);
CALL addArista(3, 6, 146);
CALL addArista(4, 5, 107);
CALL addArista(6, 7, 86);
CALL addArista(6, 15, 244);
CALL addArista(7, 11, 456);
CALL addArista(7, 15, 300);
CALL addArista(9, 10, 128);
CALL addArista(10, 11, 215);
CALL addArista(10, 12, 67);
CALL addArista(10, 13, 100);
CALL addArista(12, 13, 37);
CALL addArista(12, 14, 52);
