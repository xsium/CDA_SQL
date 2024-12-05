USE caisse;
CREATE VIEW vue_tickets_prix AS
SELECT t.id_ticket, v.nom_vendeur, v.prenom_vendeur, SUM(pt.quantite * p.prix_produit) AS montant_TTC FROM ticket AS t
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
JOIN vendeur v ON t.id_vendeur = v.id_vendeur
GROUP BY t.id_ticket, v.nom_vendeur, v.prenom_vendeur;

CREATE VIEW vue_top5 AS
SELECT p.nom_produit, SUM(pt.quantite) AS total_vendu FROM produit_ticket AS pt
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY p.nom_produit
ORDER BY total_vendu DESC LIMIT 5;

CREATE VIEW vue_chiffre_affaire_vendeurs AS
SELECT v.nom_vendeur, v.prenom_vendeur, SUM(pt.quantite * p.prix_produit) AS chiffre_affaire FROM ticket AS t
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
JOIN vendeur v ON t.id_vendeur = v.id_vendeur
GROUP BY v.nom_vendeur, v.prenom_vendeur;

-- DROITS
CREATE USER 'admin'@'%' IDENTIFIED BY 'password_admin';
GRANT ALL PRIVILEGES ON caisse.* TO 'admin'@'%';

CREATE USER 'gerant'@'%' IDENTIFIED BY 'password_gerant';
GRANT SELECT, INSERT, UPDATE, DELETE ON caisse.* TO 'gerant'@'%';

CREATE USER 'vendeur'@'%' IDENTIFIED BY 'password_vendeur';
GRANT SELECT ON caisse.* TO 'vendeur'@'%';
GRANT SHOW VIEW ON caisse.* TO 'vendeur'@'%';
GRANT INSERT ON caisse.ticket TO 'vendeur'@'%';
GRANT INSERT ON caisse.produit_ticket TO 'vendeur'@'%';
GRANT UPDATE ON caisse.produit_ticket TO 'vendeur'@'%';

-- Procedures
DELIMITER $$
CREATE PROCEDURE creer_categorie(IN nomCategorie VARCHAR(50))
BEGIN
    IF (SELECT c.id_categorie FROM categorie AS c WHERE nom_categorie = nomCategorie ) IS NULL THEN
        INSERT INTO categorie (nom_categorie) 
        VALUES (nomCategorie);
    ELSE
        -- afficher un message d'erreur
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Attention la categorie existe déja';
    END IF;
END $$

DELIMITER $$
CREATE PROCEDURE creer_produit(
    IN nomProd VARCHAR(50),
    IN descProd VARCHAR(255),
    IN prix DECIMAL(6,2),
    IN idCat INT
)
BEGIN
    IF prix <= 0 THEN
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Le prix doit être supérieur à 0.';
    ELSEIF (SELECT nom_produit FROM produit WHERE nom_produit = nomProd)IS NULL THEN
        INSERT INTO produit (nom_produit, description_produit, prix_produit, id_categorie)
        VALUES (nomProd, descProd, prix, idCat);
    ELSE
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Le produit existe déjà.';
    END IF;
END $$

DELIMITER $$
CREATE PROCEDURE creer_ticket(
	IN dateTicket DATETIME,
    IN idVendeur INT
)
BEGIN
    IF dateTicket > NOW() THEN
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'La date du ticket ne peut pas être supérieur à maintenant.';
    ELSE
        INSERT INTO ticket (date_ticket, id_vendeur) VALUES (dateTicket, idVendeur);
    END IF;
END $$

DELIMITER $$
CREATE PROCEDURE creer_vendeur(IN prenomVend VARCHAR(50), IN nomVend VARCHAR(50))
BEGIN
    IF (SELECT nom_vendeur, prenom_vendeur FROM vendeur WHERE prenom_vendeur = prenomVend AND nom_vendeur = nomVend)IS NULL  THEN
        INSERT INTO vendeur (prenom_vendeur, nom_vendeur) VALUES (prenomVend, nomVend);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le vendeur existe déjà.';
    END IF;
END $$

-- création compte 
CREATE TABLE utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    mot_de_passe CHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

DELIMITER $$
CREATE PROCEDURE verif_compte(IN emailUtil VARCHAR(255))
BEGIN
    IF (SELECT id_utilisateur FROM utilisateur WHERE email = emailUtil) IS NULL THEN
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'L\'email existe déjà.';
    END IF;
END $$

DELIMITER $$
CREATE PROCEDURE creer_compte(IN emailUtil VARCHAR(255), IN mdpUtil VARCHAR(50))
BEGIN
    CALL verif_compte(emailUtil);
    INSERT INTO utilisateur (email, mot_de_passe)
    VALUES (emailUtil, MD5(mdpUtil));
END $$

DELIMITER $$
CREATE PROCEDURE verifier_identifiant(IN emailUtil VARCHAR(255), IN mdpUtil VARCHAR(50))
BEGIN
    IF (SELECT id_utilisateur FROM utilisateur WHERE email = emailUtil AND mot_de_passe = MD5(mdpUtil)) IS NULL THEN
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Email ou mot de passe incorrect.';
    END IF;
END $$

DELIMITER $$
CREATE PROCEDURE changer_mot_de_passe(
    IN emailUtil VARCHAR(100),
    IN ancienMdp VARCHAR(50),
    IN nouveauMdp VARCHAR(50)
)
BEGIN
    IF (SELECT id_utilisateur FROM utilisateur WHERE email = emailUtil AND mot_de_passe = MD5(ancienMdp)) IS NULL THEN
        UPDATE utilisateur SET mot_de_passe = MD5(nouveauMdp) WHERE email = emailUtil;
    ELSE
        SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'ancien mot de passe incorrect ou le mail est invalide.';
    END IF;
END $$


