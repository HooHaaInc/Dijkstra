-- MySQL dump 10.13  Distrib 5.6.26, for Linux (x86_64)
--
-- Host: localhost    Database: e5ingsoft2
-- ------------------------------------------------------

DROP TABLE IF EXISTS 'Nodo';
CREATE TABLE 'Nodo' (
  'id_nodo' int(11) NOT NULL AUTO_INCREMENT,
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
