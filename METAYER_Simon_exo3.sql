-- création de la base de données -param charset global
CREATE DATABASE IF NOT EXISTS basket CHARSET utf8mb4;
-- utiliser la base "basket"
USE basket;

-- création des tables - optional parem charset par table prio
CREATE TABLE IF NOT EXISTS poste(
	id_poste INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_poste VARCHAR(50) NOT NULL UNIQUE
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phase`(
	id_phase INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_phase VARCHAR(50) NOT NULL UNIQUE
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS competition(
	id_competition INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_competition VARCHAR(50) NOT NULL UNIQUE,
    date_debut DATETIME NOT NULL,
    date_fin DATETIME NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS adresse(
	id_adresse INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_rue VARCHAR(50) NOT NULL UNIQUE,
    num_rue INT NOT NULL,
    code_postal INT NOT NULL,
    ville VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS club(
	id_club INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_club VARCHAR(50) NOT NULL UNIQUE,
    id_adresse INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS lieu(
	id_lieu INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_lieu VARCHAR(50) NOT NULL,
    id_adresse INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS equipe(
	id_equipe INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_equipe VARCHAR(50) NOT NULL UNIQUE,
    id_club INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS joueur(
	id_joueur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_joueur VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    id_poste INT,
    id_equipe INT
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS partie(
	id_partie INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    date_partie DATETIME NOT NULL,
    score_equipe_1 INT NOT NULL,
    score_equipe_2 INT NOT NULL,
    id_equipe_2 INT NOT NULL,
    id_equipe_1 INT NOT NULL,
    id_competition INT NOT NULL,
    id_phase INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

-- création de la table d'association
CREATE TABLE IF NOT EXISTS localiser(
	id_competition INT NOT NULL,
    id_lieu INT NOT NULL,
    PRIMARY KEY(id_competition, id_lieu)
)ENGINE=innoDB CHARSET=utf8mb4;

-- ajouter les contraintes
ALTER TABLE lieu
ADD CONSTRAINT fk_completer_id_adresse
FOREIGN KEY(id_adresse)
REFERENCES adresse(id_adresse)
ON DELETE CASCADE;

ALTER TABLE club
ADD CONSTRAINT fk_situer_id_adresse
FOREIGN KEY(id_adresse)
REFERENCES adresse(id_adresse)
ON DELETE CASCADE;

ALTER TABLE equipe
ADD CONSTRAINT fk_posseder_id_club
FOREIGN KEY(id_club)
REFERENCES club(id_club)
ON DELETE CASCADE;

ALTER TABLE joueur
ADD CONSTRAINT fk_jouer_id_poste
FOREIGN KEY(id_poste)
REFERENCES poste(id_poste)
ON DELETE CASCADE;

ALTER TABLE joueur
ADD CONSTRAINT fk_appartenir_id_equipe
FOREIGN KEY(id_equipe)
REFERENCES equipe(id_equipe)
ON DELETE CASCADE;

ALTER TABLE partie
ADD CONSTRAINT fk_participer_id_equipe
FOREIGN KEY(id_equipe_1)
REFERENCES equipe(id_equipe)
ON DELETE CASCADE;

ALTER TABLE partie
ADD CONSTRAINT fk_concourir_id_equipe
FOREIGN KEY(id_equipe_2)
REFERENCES equipe(id_equipe)
ON DELETE CASCADE;

ALTER TABLE partie
ADD CONSTRAINT fk_detailler_id_phase
FOREIGN KEY(id_phase)
REFERENCES phase(id_phase)
ON DELETE CASCADE;

ALTER TABLE partie
ADD CONSTRAINT fk_derouler_id_competition
FOREIGN KEY(id_competition)
REFERENCES competition(id_competition)
ON DELETE CASCADE;

-- contrainte check et regexp
ALTER TABLE partie
ADD CONSTRAINT ck_score_1
CHECK(score_equipe_1 >= 0);

ALTER TABLE partie
ADD CONSTRAINT ck_score_2
CHECK(score_equipe_2 >= 0);

ALTER TABLE partie
ADD CONSTRAINT chk_fk_id_equipe_different
CHECK (id_equipe_2 != id_equipe_1);

ALTER TABLE equipe
ADD CONSTRAINT ck_nom_equipe
CHECK (nom_equipe REGEXP '^[A-Za-z]{4,}$');

ALTER TABLE adresse
ADD CONSTRAINT ck_code_postal
CHECK (LENGTH(code_postal) = 5 AND code_postal REGEXP '^[0-9]{5}$');
