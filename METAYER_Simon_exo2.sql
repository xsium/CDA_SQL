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

-- Exercice 1 du 03/12/24
ALTER TABLE livre
ADD COLUMN date_sortie DATE;

INSERT INTO livre (titre, `description`, nbr_page, date_sortie) VALUES
('Le Mystère de la Forêt', 'Un groupe d\'amis découvre un secret ancien caché dans une forêt enchantée.', 200, '2023-01-01'),
('Les Secrets de l\'Océan', 'Une jeune biologiste marine explore les profondeurs de l\'océan et découvre une civilisation perdue.', 200, '2023-02-01'),
('L\'Énigme du Pharaon', 'Un archéologue tente de résoudre les mystères d\'une ancienne pyramide égyptienne.', 200, '2023-03-01'),
('La Quête du Chevalier', 'Un chevalier part en quête pour sauver son royaume d\'une menace imminente.', 200, '2023-04-01'),
('Le Voyage Interstellaire', 'Un équipage spatial part à la découverte de nouvelles planètes et formes de vie.', 200, '2023-05-01'),
('Les Chroniques du Temps', 'Un scientifique invente une machine à voyager dans le temps et explore différentes époques.', 200, '2023-06-01'),
('La Cité Perdue', 'Une équipe d\'explorateurs découvre une cité ancienne cachée dans la jungle.', 200, '2023-07-01'),
('Le Trésor des Pirates', 'Un jeune garçon trouve une carte au trésor et part à l\'aventure pour le trouver.', 200, '2023-08-01'),
('L\'Île Mystérieuse', 'Un groupe de naufragés découvre une île pleine de mystères et de dangers.', 200, '2023-09-01'),
('Les Gardiens de la Galaxie', 'Une équipe de super-héros protège la galaxie contre des menaces interstellaires.', 200, '2023-10-01');

INSERT INTO genre (nom_genre) VALUES
('fantastique'),
('science-fiction'),
('polar'),
('drame'),
('roman');

-- Associations de livres à des genres (2)
INSERT INTO livre_genre (id_livre, id_genre) VALUES
(1, 1),(1, 2),
(2, 3),(2, 4),
(3, 5),(3, 1),
(4, 2),(4, 3),
(5, 4),(5, 5),
(6, 1),(6, 2),
(7, 3),(7, 4),
(8, 5),(8, 1),
(9, 2),(9, 3),
(10, 4),(10, 5);

-- Bonus 
ALTER TABLE livre
ADD CONSTRAINT uc_titre UNIQUE (titre);

CREATE TABLE IF NOT EXISTS auteur (
    id_auteur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_auteur VARCHAR(50) NOT NULL,
    prenom_auteur VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

ALTER TABLE livre
ADD COLUMN id_auteur INT,
ADD CONSTRAINT fk_ecrire_auteur
FOREIGN KEY (id_auteur) REFERENCES auteur(id_auteur);

INSERT INTO auteur (nom_auteur, prenom_auteur) VALUES
('H.P', 'Lovecraft'),
('J. R. R.', 'Tolkien'),
('Raymond E.', 'Feist'),
('Alain', 'Damasio'),
('Bernard', 'Werber');

INSERT INTO livre (titre, `description`, nbr_page, date_sortie, id_auteur) VALUES
('LIVRE A', 'description', 200, '2024-01-01', 1),
('LIVRE B', 'description', 200, '2024-01-01', 2),
('LIVRE C', 'description', 200, '2024-01-01', 3),
('LIVRE D', 'description', 200, '2024-01-01', 4),
('LIVRE E', 'description', 200, '2024-01-01', 5);
