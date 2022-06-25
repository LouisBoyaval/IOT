
DROP DATABASE IF EXISTS datadistributeur;

create database datadistributeur;

use datadistributeur;

DROP TABLE IF EXISTS Statistique;
DROP TABLE IF EXISTS Repas;
DROP TABLE IF EXISTS Croquettes;
DROP TABLE IF EXISTS Animaux;

create table Animaux
(
    idAnimal  int auto_increment,
    nom VARCHAR(15) not null,
    tag VARCHAR(60) not null,
    constraint Animaux_pk
        primary key (idAnimal)
);

create table Croquettes
(
    idCroquette int auto_increment,
    nom VARCHAR(15) not null,
    PRIMARY KEY(idCroquette)
);

create table Repas
(
    idRepas  int auto_increment,
    quantite float    not null,
    idAnimal int not null,
    idCroquette int not null,

    PRIMARY KEY (idRepas),

    index(idAnimal),
    index(idCroquette),
    FOREIGN KEY (idAnimal) REFERENCES Annimaux(idAnimal) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idCroquette) REFERENCES Croquettes(idCroquette) ON UPDATE CASCADE ON DELETE RESTRICT
);

create table Statistique
(
    idStatistique  int auto_increment,
    quantite float not null,
    idRepas int not null,
    PRIMARY KEY (idStatistique),
    index(idRepas),
    FOREIGN KEY (idRepas) REFERENCES Repas(idRepas) ON UPDATE CASCADE ON DELETE RESTRICT
);
