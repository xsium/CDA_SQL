-- Exo Async 04/12/24
-- utiliser la base "caisse"
USE caisse;

-- produits jamais vendus
SELECT p.nom_produit FROM produit AS p
LEFT JOIN produit_ticket pt ON p.id_produit = pt.id_produit
WHERE pt.id_produit IS NULL;

-- vendeur sans produits vendus 
-- un seul join pourrait être suffisant mais si un vendeur ouvre un ticket et au final ne vend rien, il est bon de vérifier dans produit_ticket
-- PS: pauvre Bob, souvenons nous que Sophie a volé tous ses tickets :'( #neverforget #KeepBob
SELECT v.prenom_vendeur, v.nom_vendeur FROM vendeur AS v
LEFT JOIN ticket t ON v.id_vendeur = t.id_vendeur
LEFT JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
WHERE t.id_ticket IS NULL;

-- 3 produits les plus vendus
SELECT p.nom_produit FROM produit AS p
JOIN produit_ticket pt ON p.id_produit = pt.id_produit
GROUP BY p.nom_produit
ORDER BY SUM(pt.quantite) DESC LIMIT 3;

-- BONUS AGGREGATION
-- Afficher le chiffre d'affaire global (tous les tickets) avec le montant TTC
SELECT SUM(pt.quantite * p.prix_produit) AS total_CA FROM produit_ticket AS pt
JOIN produit p ON pt.id_produit = p.id_produit;

-- Afficher tous les tickets avec : date_creation, le montant TTC du ticket
SELECT t.date_ticket, SUM(pt.quantite * p.prix_produit) AS montant FROM ticket AS t
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY t.id_ticket;

-- Afficher le ticket 1 avec le nom_produit, quantite, sous-total (quantitetarif*)
SELECT p.nom_produit, pt.quantite, (pt.quantite * p.prix_produit) AS sous_total FROM produit_ticket AS pt
JOIN produit p ON pt.id_produit = p.id_produit
WHERE pt.id_ticket = 1;

-- Afficher le chiffre d'affaire par année en affichant : année, montant du chiffre affaire
SELECT YEAR(t.date_ticket) AS ans, SUM(pt.quantite * p.prix_produit) AS total_CA_by_year FROM ticket AS t
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY YEAR(t.date_ticket);

-- Afficher le vendeur qui à réalisé le chiffre d'affaire le plus important avec : nom_vendeur, prenom_vendeur, chiffre affaire
SELECT v.nom_vendeur, v.prenom_vendeur, SUM(pt.quantite * p.prix_produit) AS CA FROM vendeur AS v
JOIN ticket t ON v.id_vendeur = t.id_vendeur
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY v.id_vendeur
ORDER BY chiffre_affaire DESC LIMIT 1;

-- Afficher les 3 produits qui sont le plus vendus avec nom_produit, nom_categorie, le chiffre d'affaire du produit
SELECT p.nom_produit, c.nom_categorie, SUM(pt.quantite * p.prix_produit) AS CA_produit FROM produit AS p
JOIN produit_ticket pt ON p.id_produit = pt.id_produit
JOIN categorie c ON p.id_categorie = c.id_categorie
GROUP BY p.nom_produit
ORDER BY SUM(pt.quantite) DESC LIMIT 3;

-- Afficher par catégorie le chiffre d'affaire avec : nom_categorie, le montant TTC du chiffre d'affaire de la catégorie
SELECT c.nom_categorie, SUM(pt.quantite * p.prix_produit) AS CA FROM categorie AS c
JOIN produit p ON c.id_categorie = p.id_categorie
JOIN produit_ticket pt ON p.id_produit = pt.id_produit
GROUP BY c.nom_categorie;
