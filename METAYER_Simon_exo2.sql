-- création de la base de données -param charset global
CREATE DATABASE IF NOT EXISTS livre CHARSET utf8mb4;
-- utiliser la base "livre"
USE livre;

-- création des tables - optional parem charset par table prio
CREATE TABLE IF NOT EXISTS genre(
	id_genre INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_genre VARCHAR(50) NOT NULL UNIQUE
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `role`(
	id_role INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_role VARCHAR(50) NOT NULL UNIQUE
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS livre(
	id_livre INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    titre VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    nbr_page INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS utilisateur(
	id_utilisateur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_utilisateur VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    mdp VARCHAR(100) NOT NULL,
    id_role INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS reservation(
	id_reservation INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    date_debut date NOT NULL,
    date_fin date NOT NULL,
    id_utilisateur INT NOT NULL,
    id_livre INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

-- création de la table d'association
CREATE TABLE IF NOT EXISTS livre_genre(
	id_livre INT NOT NULL,
    id_genre INT NOT NULL,
    PRIMARY KEY(id_livre, id_genre)
)ENGINE=innoDB CHARSET=utf8mb4;

-- ajouter les contraintes
ALTER TABLE reservation
ADD CONSTRAINT fk_reserver_id_utilisateur
FOREIGN KEY(id_utilisateur)
REFERENCES utilisateur(id_utilisateur)
ON DELETE CASCADE;

ALTER TABLE reservation
ADD CONSTRAINT fk_inclure_id_livre
FOREIGN KEY(id_livre)
REFERENCES livre(id_livre)
ON DELETE CASCADE;

ALTER TABLE utilisateur
ADD CONSTRAINT fk_posseder_id_role
FOREIGN KEY(id_role)
REFERENCES `role`(id_role)
ON DELETE CASCADE;