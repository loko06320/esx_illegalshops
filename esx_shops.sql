USE `essentialmode`;

CREATE TABLE `illegalshops` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`store` varchar(100) NOT NULL,
	`item` varchar(100) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `illegalshops` (store, item, price) VALUES
	('ballas','handcuff',3000)
;
