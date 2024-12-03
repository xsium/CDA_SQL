-- création de la base de données -param charset global
CREATE DATABASE IF NOT EXISTS caisse CHARSET utf8mb4;
-- utiliser la base "caisse"
USE caisse;

-- création des tables - optional parem charset par table prio
CREATE TABLE IF NOT EXISTS categorie(
	id_categorie INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_categorie VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS vendeur(
	id_vendeur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    prenom_vendeur VARCHAR(50) NOT NULL,
    nom_vendeur VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS produit(
	id_produit INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nom_produit VARCHAR(50) NOT NULL,
    description_produit VARCHAR(255) NOT NULL,
    prix_produit DECIMAL(6,2) NOT NULL,
    id_categorie INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS ticket(
	id_ticket INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    date_ticket DATETIME NOT NULL,
    id_vendeur INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

-- création de la table d'association
CREATE TABLE IF NOT EXISTS produit_ticket(
	id_ticket INT NOT NULL,
    id_produit INT NOT NULL,
    quantite INT NOT NULL,
    PRIMARY KEY(id_ticket, id_produit)
)ENGINE=innoDB CHARSET=utf8mb4;

-- ajouter les contraintes
ALTER TABLE produit
ADD CONSTRAINT fk_add_categorie
FOREIGN KEY(id_categorie)
REFERENCES categorie(id_categorie)
ON DELETE CASCADE;

ALTER TABLE ticket
ADD CONSTRAINT fk_sell_vendeur
FOREIGN KEY(id_vendeur)
REFERENCES vendeur(id_vendeur)
ON DELETE CASCADE;

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_produit_ticket_produit
FOREIGN KEY(id_produit)
REFERENCES produit(id_produit)
ON DELETE CASCADE;

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_produit_ticket_ticket
FOREIGN KEY(id_ticket)
REFERENCES ticket(id_ticket)
ON DELETE CASCADE;

-- Excercice 03/12/24
-- Exercice 2 INSERT
INSERT INTO categorie (nom_categorie) VALUES
('Électronique'),
('Alimentation'),
('Vêtements'),
('Meubles'),
('Jouets');

INSERT INTO produit (nom_produit, description_produit, prix_produit, id_categorie) VALUES
('Télévision', 'Télévision HD 32 pouces', 599.99, 1),
('Ordinateur Portable', 'Ordinateur portable avec 16 Go RAM', 1499.99, 1),
('Smartphone', 'Smartphone avec écran 6 pouces', 999.99, 1),
('Céréales', 'Paquet de céréales au chocolat', 4.50, 2),
('Bouteille d\'eau', 'Bouteille d\'eau minérale 1L', 1.00, 2),
('T-shirt', 'T-shirt en coton taille L', 19.99, 3),
('Pantalon', 'Pantalon slim fit taille 42', 39.99, 3),
('Canapé', 'Canapé 3 places en tissu', 499.99, 4),
('Table', 'Table de salle à manger en bois', 299.99, 4),
('Peluche', 'Peluche en forme d\'ours', 24.99, 5);

INSERT INTO vendeur (prenom_vendeur, nom_vendeur) VALUES
('Lewis', 'Carroll'),
('Bob', 'Lenon'),
('Charlie', 'Hebdo'),
('Diana', 'Lady'),
('Sophie', 'la girafe');

INSERT INTO ticket (date_ticket, id_vendeur) VALUES
('2024-12-03 10:00:00', 1),
('2024-12-03 11:00:00', 2),
('2024-12-03 12:00:00', 3),
('2024-12-03 13:00:00', 4),
('2024-12-03 14:00:00', 5),
('2024-12-03 15:00:00', 1),
('2024-12-03 16:00:00', 2),
('2024-12-03 17:00:00', 3),
('2024-12-03 18:00:00', 4),
('2024-12-03 19:00:00', 5);

INSERT INTO produit_ticket (id_ticket, id_produit, quantite) VALUES
(1, 1, 2), (1, 4, 1), (1, 7, 3),
(2, 2, 1), (2, 5, 4), (2, 8, 2),
(3, 3, 1), (3, 6, 2), (3, 9, 1),
(4, 1, 3), (4, 7, 1), (4, 10, 2),
(5, 2, 1), (5, 5, 2), (5, 9, 1),
(6, 3, 4), (6, 4, 1), (6, 8, 2),
(7, 1, 1), (7, 6, 2), (7, 10, 3),
(8, 2, 3), (8, 7, 1), (8, 9, 2),
(9, 3, 1), (9, 5, 4), (9, 8, 1),
(10, 4, 2), (10, 6, 1), (10, 10, 3);


-- Exercice 3 UPDATE
UPDATE vendeur
SET nom_vendeur='Albert' WHERE id_vendeur=2;

UPDATE produit
SET prix_produit = prix_produit + 1 WHERE prix_produit < 2;

UPDATE ticket
SET id_vendeur = 5 WHERE id_vendeur = 2;

UPDATE categorie
SET nom_categorie = 'nouveau' WHERE nom_categorie < 'c';

-- Exo 3 Bonus
UPDATE produit p
JOIN categorie c ON p.id_categorie = c.id_categorie
SET p.prix_produit = p.prix_produit * 0.9
WHERE c.nom_categorie = 'Meubles';

UPDATE ticket
SET date_ticket = DATE_ADD(date_ticket, INTERVAL 2 DAY)
WHERE date_ticket > '2024-01-01 00:00:00';

UPDATE produit_ticket pt
JOIN ticket t ON pt.id_ticket = t.id_ticket
JOIN vendeur v ON t.id_vendeur = v.id_vendeur
SET pt.quantite = pt.quantite + 3
WHERE v.prenom_vendeur = 'Sophie' AND v.nom_vendeur = 'la girafe';

-- Exo4 DELETE
DELETE FROM categorie
WHERE nom_categorie = 'Électronique';

DELETE FROM categorie
WHERE nom_categorie = 'Jouets';

-- RIP Lewis Carroll, ton service fut apprécié
DELETE FROM vendeur
WHERE id_vendeur = 1;

DELETE FROM ticket
WHERE date_ticket < '2024-01-01 00:00:00';

DELETE FROM produit_ticket
WHERE quantite > 9;

