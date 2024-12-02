-- création de la base de données -param charset global
CREATE DATABASE IF NOT EXISTS blog CHARSET utf8mb4;
-- utiliser la base "blog"
USE blog;

-- création des tables - optional parem charset par table prio
CREATE TABLE IF NOT EXISTS roles(
	id_roles INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    roles_name VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS media(
	id_media INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    media_url VARCHAR(255) NOT NULL,
    media_slug VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS category(
	id_category INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(50) NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `account`(
	id_account INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    account_firstname VARCHAR(50) NOT NULL,
    account_lastname VARCHAR(50) NOT NULL UNIQUE,
    account_email VARCHAR(50) NOT NULL,
    account_password VARCHAR(100) NOT NULL,
    account_nickname VARCHAR(50) NOT NULL UNIQUE,
    account_avatar VARCHAR(255),
    account_activation tinyint(1) NOT NULL,
    account_deactivation_date DATE,
    roles_id_fk INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS article(
	id_article INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    article_title VARCHAR(50) NOT NULL,
    article_content TEXT NOT NULL,
    article_creation_date DATE NOT NULL,
    article_update_date DATE,
    article_slug VARCHAR(50) NOT NULL,
    article_validation TINYINT(1) NOT NULL,
    article_author_fk INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS commentary(
	id_commentary INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    commentary_content VARCHAR(255) NOT NULL,
    commentary_creation_date DATE NOT NULL,
    commentary_validation TINYINT(1) NOT NULL,
    commentary_author_fk INT NOT NULL,
    article_id_fk INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS note(
	id_note INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    note_value INT,
    note_reaction TINYINT(1),
    article_id_fk INT NOT NULL,
    account_id_fk INT NOT NULL
)ENGINE=innoDB CHARSET=utf8mb4;


-- création de la table d'association
CREATE TABLE IF NOT EXISTS article_media(
	article_id INT NOT NULL,
    media_id INT NOT NULL,
    PRIMARY KEY(article_id, media_id)
)ENGINE=innoDB CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS article_category(
	article_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY(article_id, category_id)
)ENGINE=innoDB CHARSET=utf8mb4;

-- ajouter les contraintes
ALTER TABLE `account`
ADD CONSTRAINT fk_have_role
FOREIGN KEY(roles_id_fk)
REFERENCES roles(id_roles)
ON DELETE CASCADE;

ALTER TABLE article
ADD CONSTRAINT fk_write_author
FOREIGN KEY(article_author_fk)
REFERENCES `account`(id_account)
ON DELETE CASCADE;

ALTER TABLE note
ADD CONSTRAINT fk_rate_article_id
FOREIGN KEY(article_id_fk)
REFERENCES article(id_article)
ON DELETE CASCADE;

ALTER TABLE note
ADD CONSTRAINT fk_score_account_id
FOREIGN KEY(account_id_fk)
REFERENCES `account`(id_account)
ON DELETE CASCADE;

ALTER TABLE commentary
ADD CONSTRAINT fk_comment_account_id
FOREIGN KEY(commentary_author_fk)
REFERENCES `account`(id_account)
ON DELETE CASCADE;

ALTER TABLE commentary
ADD CONSTRAINT fk_add_article_id
FOREIGN KEY(article_id_fk)
REFERENCES article(id_article)
ON DELETE CASCADE;

ALTER TABLE article_media
ADD CONSTRAINT fk_article_media_article
FOREIGN KEY(article_id)
REFERENCES article(id_article)
ON DELETE CASCADE;

ALTER TABLE article_media
ADD CONSTRAINT fk_article_media_media
FOREIGN KEY(media_id)
REFERENCES media(id_media)
ON DELETE CASCADE;

ALTER TABLE article_category
ADD CONSTRAINT fk_article_category_article
FOREIGN KEY(article_id)
REFERENCES article(id_article)
ON DELETE CASCADE;

ALTER TABLE article_category
ADD CONSTRAINT fk_article_category_category
FOREIGN KEY(category_id)
REFERENCES category(id_category)
ON DELETE CASCADE;