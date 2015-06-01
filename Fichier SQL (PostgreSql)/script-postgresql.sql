CREATE TABLE CATEGORIE
(
idCategorie integer PRIMARY KEY,
nomCategorie char(32)
);

CREATE TABLE OUTILS
(
idOutil integer PRIMARY KEY,
nomOutil char(64),
marque char(32),
tarif numeric CHECK (tarif > 0),
categorie integer NOT NULL REFERENCES CATEGORIE (idCategorie),
image integer
);

CREATE TABLE EMPRUNT
(
idEmprunt integer PRIMARY KEY REFERENCES OUTILS (idOutil),
dateRetour integer NOT NULL
);

CREATE TABLE RESERVATION
(
idReservation integer NOT NULL REFERENCES OUTILS (idOutil),
datedebut integer NOT NULL,
datefin integer NOT NULL,
nomPers char(32),
prenomPers char(32),
numTel char(20) NOT NULL,
adrMail char(64) 
);

CREATE TABLE LOG
(
logmessage char(64),
idReservation integer,
nomPers char(32),
logdate date
);

CREATE OR REPLACE FUNCTION reservation_after_insert()
RETURNS TRIGGER AS
$BODY$
declare
begin
	IF NEW.datedebut>NEW.datefin THEN
	RAISE EXCEPTION 'Erreur date inversé';
	return null;
	END IF;
	INSERT INTO log VALUES('Ajout dans la table réservation',NEW.idreservation,NEW.nompers,NOW());
	return NEW;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  CREATE TRIGGER reservation_after_insert_trigger
AFTER INSERT ON reservation
FOR EACH ROW
EXECUTE PROCEDURE reservation_after_insert();

CREATE OR REPLACE FUNCTION reservation_after_delete()
RETURNS TRIGGER AS
$BODY$
declare
begin
	INSERT INTO log VALUES('Suppression dans la table réservation',OLD.idreservation,OLD.nompers,NOW());
	return OLD;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  CREATE TRIGGER reservation_after_delete_trigger
AFTER DELETE ON reservation
FOR EACH ROW
EXECUTE PROCEDURE reservation_after_delete();

CREATE OR REPLACE FUNCTION outils_after_delete()
	RETURNS TRIGGER AS
$BODY$
declare
begin
	IF (OLD.idoutil IN (SELECT idreservation FROM reservation)) THEN
	RAISE EXCEPTION 'Id présent dans la table reservation';
	return null;
	END IF;
	IF (OLD.idoutil IN (SELECT idemprunt FROM emprunt)) THEN
	RAISE EXCEPTION 'Id présent dans la table emprunt';
	return null;
	END IF;
	return OLD;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  CREATE TRIGGER outils_after_delete_trigger
AFTER INSERT ON outils
FOR EACH ROW
EXECUTE PROCEDURE outils_after_delete();

INSERT INTO CATEGORIE
VALUES(1,'Perceuse');

INSERT INTO CATEGORIE
VALUES(2,'Aspirateur/Nettoyeur');

INSERT INTO CATEGORIE
VALUES(3,'Scie/meuleuse');

INSERT INTO CATEGORIE
VALUES(4,'Etabli');

INSERT INTO CATEGORIE
VALUES(5,'Ponceuse');

INSERT INTO CATEGORIE
VALUES(6,'Mesure/traçage');

INSERT INTO CATEGORIE
VALUES(7,'Echelle/escabeau/échafaudage');

INSERT INTO CATEGORIE
VALUES(8,'Outil à main');

INSERT INTO CATEGORIE
VALUES(9,'Défonceuse');

INSERT INTO CATEGORIE
VALUES(10,'Compresseur');

INSERT INTO CATEGORIE
VALUES(11,'Soudure');

INSERT INTO CATEGORIE
VALUES(12,'Groupe électrogène');

INSERT INTO CATEGORIE
VALUES(13,'Matériel de bâtiment');

INSERT INTO CATEGORIE
VALUES(14,'Pistolet à peinture');

INSERT INTO CATEGORIE
VALUES(15,'Vêtement');

INSERT INTO CATEGORIE
VALUES(16,'Perforateur');

INSERT INTO OUTILS
VALUES(1,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(11,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(21,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(31,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(41,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(51,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(61,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(71,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(81,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(91,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(101,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(111,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(121,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(131,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(141,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(151,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(161,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(171,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(181,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(191,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(201,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(211,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(221,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(231,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(241,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(251,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(261,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(271,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(281,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(291,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(301,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(311,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(321,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(331,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(341,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(351,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(361,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(371,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(381,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(391,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(401,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(411,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(421,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(431,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(441,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(451,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(461,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(471,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(2,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(12,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(22,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(32,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(42,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(52,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(62,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(72,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(82,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(92,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(102,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(112,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(122,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(132,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(142,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(152,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(162,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(172,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(182,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(192,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(202,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(212,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(222,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(232,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(242,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(252,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(262,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(272,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(282,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(292,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(302,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(312,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(322,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(332,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(342,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(352,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(362,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(372,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(382,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(392,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(402,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(412,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(422,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(432,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(442,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(452,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(462,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(472,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(3,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(13,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(23,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(33,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(43,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(53,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(63,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(73,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(83,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(93,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(103,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(113,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(123,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(133,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(143,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(153,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(163,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(173,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(183,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(193,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(203,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(213,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(223,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(233,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(243,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(253,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(263,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(273,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(283,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(293,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(303,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(313,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(323,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(333,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(343,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(353,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(363,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(373,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(383,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(393,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(403,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(413,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(423,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(433,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(443,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(453,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(463,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(473,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(4,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(14,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(24,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(34,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(44,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(54,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(64,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(74,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(84,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(94,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(104,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(114,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(124,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(134,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(144,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(154,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(164,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(174,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(184,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(194,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(204,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(214,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(224,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(234,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(244,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(254,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(264,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(274,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(284,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(294,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(304,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(314,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(324,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(334,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(344,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(354,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(364,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(374,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(384,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(394,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(404,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(414,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(424,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(434,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(444,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(454,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(464,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(474,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(5,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(15,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(25,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(35,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(45,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(55,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(65,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(75,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(85,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(95,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(105,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(115,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(125,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(135,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(145,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(155,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(165,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(175,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(185,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(195,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(205,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(215,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(225,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(235,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(245,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(255,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(265,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(275,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(285,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(295,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(305,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(315,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(325,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(335,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(345,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(355,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(365,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(375,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(385,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(395,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(405,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(415,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(425,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(435,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(445,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(455,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(465,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(475,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(6,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(16,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(26,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(36,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(46,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(56,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(66,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(76,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(86,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(96,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(106,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(116,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(126,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(136,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(146,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(156,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(166,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(176,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(186,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(196,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(206,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(216,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(226,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(236,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(246,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(256,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(266,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(276,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(286,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(296,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(306,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(316,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(326,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(336,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(346,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(356,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(366,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(376,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(386,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(396,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(406,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(416,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(426,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(436,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(446,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(456,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(466,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(476,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(7,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(17,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(27,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(37,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(47,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(57,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(67,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(77,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(87,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(97,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(107,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(117,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(127,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(137,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(147,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(157,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(167,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(177,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(187,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(197,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(207,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(217,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(227,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(237,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(247,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(257,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(267,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(277,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(287,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(297,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(307,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(317,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(327,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(337,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(347,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(357,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(367,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(377,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(387,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(397,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(407,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(417,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(427,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(437,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(447,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(457,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(467,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(477,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(8,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(18,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(28,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(38,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(48,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(58,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(68,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(78,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(88,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(98,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(108,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(118,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(128,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(138,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(148,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(158,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(168,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(178,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(188,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(198,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(208,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(218,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(228,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(238,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(248,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(258,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(268,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(278,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(288,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(298,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(308,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(318,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(328,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(338,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(348,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(358,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(368,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(378,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(388,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(398,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(408,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(418,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(428,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(438,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(448,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(458,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(468,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(478,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(9,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(19,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(29,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(39,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(49,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(59,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(69,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(79,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(89,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(99,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(109,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(119,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(129,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(139,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(149,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(159,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(169,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(179,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(189,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(199,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(209,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(219,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(229,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(239,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(249,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(259,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(269,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(279,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(289,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(299,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(309,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(319,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(329,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(339,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(349,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(359,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(369,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(379,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(389,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(399,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(409,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(419,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(429,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(439,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(449,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(459,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(469,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(479,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(0,'Perceuse-visseuse sans fil PSR1400LI 14.4V - 1.3Ah','BOSCH',16,1,'0');

INSERT INTO OUTILS
VALUES(10,'Perceuse-visseuse à percussion sans fil BSB14CLI20 14.4V - 2.0Ah','AEG',29,1,'1');

INSERT INTO OUTILS
VALUES(20,'Perceuse à percussion SBE850 850W','METABO',19,1,'2');

INSERT INTO OUTILS
VALUES(30,'Nettoyeur Haute Pression K5 Premium','KARCHER',44,2,'3');

INSERT INTO OUTILS
VALUES(40,'Aspirateur eau et poussières BUDDYII 18','NILFISK',11,2,'4');

INSERT INTO OUTILS
VALUES(50,'Nettoyeur vapeur SC1020','KARCHER',11,2,'5');

INSERT INTO OUTILS
VALUES(60,'Scie circulaire KS66C-2 1600 W','AEG',24,3,'6');

INSERT INTO OUTILS
VALUES(70,'Meuleuse 850 W FATMAX','STANLEY',10,3,'7');

INSERT INTO OUTILS
VALUES(80,'Scie sauteuse pendulaire 680W RJS1050K','RYOBI',13,3,'8');

INSERT INTO OUTILS
VALUES(90,'Etabli pro multifonction Master Cut 2000','Wolfcraft',43,4,'9');

INSERT INTO OUTILS
VALUES(100,'Etabli pliant','MAC ALLISTER',10,4,'10');

INSERT INTO OUTILS
VALUES(110,'Etabli repliable PWB600','BOSCH',19,4,'11');

INSERT INTO OUTILS
VALUES(120,'Ponceuse paume triangulaire PSM80A','BOSCH',7,5,'12');

INSERT INTO OUTILS
VALUES(130,'Ponceuse triangulaire delta 180 W MDS180','MAC ALLISTER',8,5,'13');

INSERT INTO OUTILS
VALUES(140,'Ponceuse vibrante 260W MESS260','MAC ALLISTER',9,5,'14');

INSERT INTO OUTILS
VALUES(150,'Niveau laser croix SSCL180','STANLEY',5,6,'15');

INSERT INTO OUTILS
VALUES(160,'Télémètre Laser PLR 50','BOSCH',16,6,'16');

INSERT INTO OUTILS
VALUES(170,'Détecteur thermique PTD1','BOSCH',16,6,'17');

INSERT INTO OUTILS
VALUES(180,'Echafaudage B4','Centaure',15,7,'18');

INSERT INTO OUTILS
VALUES(190,'Echelle transformable 3 plans 2,85/6,50 m','Centaure',32,7,'19');

INSERT INTO OUTILS
VALUES(200,'Escabeau en aluminium Pro-Up 7 marches','Centaure',15,7,'20');

INSERT INTO OUTILS
VALUES(210,'Agrafeuse sans fil PTK 3.6 Li','BOSCH',9,8,'21');

INSERT INTO OUTILS
VALUES(220,'Pistolet à colle CG270','Rapid',5,8,'22');

INSERT INTO OUTILS
VALUES(230,'Pince riveter','FACOM',4,8,'23');

INSERT INTO OUTILS
VALUES(240,'Défonceuse POF1400ACE 1400 W','BOSCH',19,9,'24');

INSERT INTO OUTILS
VALUES(250,'Rainureuse MSWC1500 1500W','MAC ALLISTER',13,9,'25');

INSERT INTO OUTILS
VALUES(260,'Machine à bois combinée COMBI 6','KITY',58,9,'26');

INSERT INTO OUTILS
VALUES(270,'Compresseur vertical 50L 2 HP','MECAFER',15,10,'27');

INSERT INTO OUTILS
VALUES(280,'Compresseur lubrifié 50 Litres 3,5 HP','MECAFER',37,10,'28');

INSERT INTO OUTILS
VALUES(290,'Compresseur 2 en 1 sans fil ASI 500','BLACK&DECKER',15,10,'29');

INSERT INTO OUTILS
VALUES(300,'Poste à souder Inverter MW160','MAC ALLISTER',32,11,'30');

INSERT INTO OUTILS
VALUES(310,'Fer à souder FL 8040','Campingaz',4,11,'31');

INSERT INTO OUTILS
VALUES(320,'Poste à souder oxyacétylénique Oxyflam 1000','WELD TEAM',70,11,'32');

INSERT INTO OUTILS
VALUES(330,'Groupe électrogène Inverter 2000i SDMO','VARIO',45,12,'33');

INSERT INTO OUTILS
VALUES(340,'Groupe électrogène HG2200-A','HYUNDAI',25,12,'34');

INSERT INTO OUTILS
VALUES(350,'Générateur 3500W max MF3800','MECAFER',38,12,'35');

INSERT INTO OUTILS
VALUES(360,'Bétonnière électrique B165','ALSTRAD',30,13,'36');

INSERT INTO OUTILS
VALUES(370,'Brouette peinte noire 95L','Diall',8,13,'37');

INSERT INTO OUTILS
VALUES(380,'Brouette Aktiv Excellium Twin 100L','Haemmerlin',14,13,'38');

INSERT INTO OUTILS
VALUES(390,'Pistolet à peinture basse pression W665','WAGNER',20,14,'39');

INSERT INTO OUTILS
VALUES(400,'Pistolet peinture basse pression W610','WAGNER',13,14,'40');

INSERT INTO OUTILS
VALUES(410,'Pistolet à peinture FLEXiO W995','WAGNER',32,14,'41');

INSERT INTO OUTILS
VALUES(420,'Kit anti-chute expert 10 m','Harnais',17,15,'42');

INSERT INTO OUTILS
VALUES(430,'Casque complet forestier','Rostaing',8,15,'43');

INSERT INTO OUTILS
VALUES(440,'Harnais anti-chute 2 points','Harnais',6,15,'44');

INSERT INTO OUTILS
VALUES(450,'Perforateur MSRH1200 SDS+ 4.2 Joules','MAC ALLISTER',10,16,'45');

INSERT INTO OUTILS
VALUES(460,'Perforateur sans fil BBH12LI 4Ah-0.9J','AEG',29,16,'46');

INSERT INTO OUTILS
VALUES(470,'Perforateur 725W UHE2450 MULTI','METABO',26,16,'47');

INSERT INTO OUTILS
VALUES(480,'Groupe électrogène insonorisé 5000W triphasé MF5500','MECAFER',105,12,'48');

INSERT INTO RESERVATION
VALUES (10,1433455200,1433887200,'Garceau','Ambra','0697216587','AmbraGarceau@jourrapide.com');

INSERT INTO RESERVATION
VALUES (12,1432418400,1432504800,'Dodier','Ganelon','0586442670','GanelonDodier@jourrapide.com');

INSERT INTO RESERVATION
VALUES (14,1434405600,1434405600,'Goulet','Grégoire','0488659721','GregoireGoulet@dayrep.com');

INSERT INTO RESERVATION
VALUES (19,1433541600,1434232800,'Sorel','Dominique','0979435685','DominiqueSorel@armyspy.com');

INSERT INTO RESERVATION
VALUES (15,1434232800,1434837600,'Girard','Gilbert','0495986420','GilbertGirard@dayrep.com');

INSERT INTO RESERVATION
VALUES (11,1433368800,1433800800,'Rodrigue','Arthur','0378986512','ArthurRodrigue@dayrep.com');

INSERT INTO RESERVATION
VALUES (10,1434232800,1434751200,'Labrie','Agramant','0345896321','AgramantLabrie@jourrapide.com');

INSERT INTO RESERVATION
VALUES (456,1434232800,1435528800,'Robitaille','Donatien','0154852544','DonatienRobitaille@rhyta.com');

INSERT INTO RESERVATION
VALUES (323,1435269600,1435528800,'Henrichon','Zara','0758916478','ZaraHenrichon@armyspy.com');

INSERT INTO RESERVATION
VALUES (6,1433023200,1433368800,'Poirier','Dexter','0234985647','DexterPoirier@dayrep.com');

INSERT INTO RESERVATION
VALUES (42,1434319200,1434578400,'Bolduc','Eleanor','0518675234','EleanorBolduc@armyspy.com');

INSERT INTO RESERVATION
VALUES (69,1433714400,1434060000,'Tisserand','Frontino','0103310900','FrontinoTisserand@rhyta.com');

INSERT INTO EMPRUNT
VALUES (10,1434751200);

INSERT INTO EMPRUNT
VALUES (13,1434578400);

INSERT INTO EMPRUNT
VALUES (112,1435096800);

INSERT INTO EMPRUNT
VALUES (480,1435528800);

INSERT INTO EMPRUNT
VALUES (82,1434319200);