CREATE DATABASE  IF NOT EXISTS `CRM-db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `CRM-db`;
-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: localhost    Database: CRM-db
-- ------------------------------------------------------
-- Server version	8.0.26-0ubuntu0.20.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Appuntamento`
--

DROP TABLE IF EXISTS `Appuntamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Appuntamento` (
  `idAppuntamento` varchar(20) GENERATED ALWAYS AS (concat(`PropostaReale_idPropostaReale`,`Sala_NomeSala`)) STORED NOT NULL,
  `Giorno` datetime NOT NULL,
  `Sala_NomeSala` varchar(20) NOT NULL,
  `Sala_Sede_NomeSede` varchar(20) NOT NULL,
  `PropostaReale_idPropostaReale` int NOT NULL,
  `Nota` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`idAppuntamento`),
  KEY `Appuntamento_sala_idx` (`Sala_NomeSala`,`Sala_Sede_NomeSede`),
  KEY `Appuntamento_propostaReale_idx` (`PropostaReale_idPropostaReale`),
  CONSTRAINT `fk_Appuntamento_PropostaReale1` FOREIGN KEY (`PropostaReale_idPropostaReale`) REFERENCES `PropostaReale` (`idPropostaReale`),
  CONSTRAINT `fk_Appuntamento_Sala1` FOREIGN KEY (`Sala_NomeSala`, `Sala_Sede_NomeSede`) REFERENCES `Sala` (`NomeSala`, `Sede_NomeSede`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;



/*!40000 ALTER TABLE `Appuntamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `Appuntamento` ENABLE KEYS */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Appuntamento_PropostaPositiva` BEFORE INSERT ON `Appuntamento` FOR EACH ROW BEGIN
Declare risultato varchar(15);

select Distinct(Esito) INTO risultato
from `CRM-db`.`PropostaReale` join `CRM-db`.`Appuntamento` on new.PropostaReale_idPropostaReale = `PropostaReale`.`idPropostaReale`;

IF risultato <> 'Positivo' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un appuntamento è fissabile sono per proposte con esito Positivo!';
END IF;			
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `Appuntamento_SalaPrenotata` BEFORE INSERT ON `Appuntamento` FOR EACH ROW BEGIN
DECLARE num INT;

SET NUM = (SELECT count(*)                                    
		   FROM `CRM-db`.`Appuntamento`
		   WHERE  Giorno = NEW.Giorno and 
                  Sala_NomeSala = NEW.Sala_NomeSala and 
                  Sala_Sede_NomeSede = NEW.Sala_Sede_NomeSede);
		
IF Num = 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sala è già stata prenotata per un altro appuntamento!';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Cliente`
--

DROP TABLE IF EXISTS `Cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cliente` (
  `CodiceCliente` int unsigned NOT NULL AUTO_INCREMENT,
  `Nome` varchar(30) NOT NULL,
  `Cognome` varchar(30) NOT NULL,
  `CodiceFiscale` varchar(17) NOT NULL,
  `PartitaIva` varchar(11) DEFAULT NULL,
  `DataRegistrazione` date NOT NULL,
  `DataNascita` date NOT NULL,
  `Telefono` varchar(11) NOT NULL,
  `Mail` varchar(50) NOT NULL,
  `Fax` varchar(11) DEFAULT NULL,
  `Citta` varchar(30) NOT NULL,
  `Indirizzo` varchar(50) NOT NULL,
  PRIMARY KEY (`CodiceCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cliente`
--


/*!40000 ALTER TABLE `Cliente` DISABLE KEYS */;
INSERT INTO `Cliente` VALUES (1,'Marco','Guadagno','KDDNSN79M42Z509G','01579764012','2021-08-07','1960-03-12','3406711900','marcog@mail.it','029837044','Roma','Via Aci 2'),(2,'Pietro','Berni','RBHQXY58T25Z611A','19305789017','2021-08-07','1950-04-11','3406290400','bernipietro@mail.it','038927045','Milano','Via Geoli 101'),(3,'Vincenzo','Lungi','FZDBLZ80A64M059T','04928589017','2021-08-07','1980-01-10','3406290100','vincenzolungi@mail.it','038910847','Torino','Via Scarpa 3'),(4,'Valerio','Pizzi','ZLOTYV58E63I233T','19305789017','2021-08-07','1960-04-11','3501874910','valepiz@mail.it','070453892','Rimini','Via Mare 45'),(5,'Luciano','Paradiso','PQPKGM29B20L426J','','2021-08-07','1950-04-11','3406290400','luciopara@gmail.com','','Roma','Via Sud 35'),(6,'Giancarlo','Penna',' FVIWWP76C26L458T','','2021-08-07','1951-04-11','3209761098','pennag@libero.it',NULL,'Latina','Via Ippolite 22'),(7,'Stefania','Quattro','NPFZGV67P08L244A','','2021-08-08','1970-08-08','32019872133','stef4@poste.it','','Frosinone','Via Socrate 16'),(8,'Alessia','Di Marco','ZNZSMH39P55A713I','','2021-08-08','1990-10-10','3409873122','alessiettadm@blu.com','','Napoli','Via Toledo 32'),(9,'Claudia','Tommasi','MTQBGR94H60E147U','11023109711','2021-08-08','1995-02-20','33902346744','claudietta@gmail.it','062087177','Cagliari','Via Eju 64'),(10,'Giovanni','Crescenzi','LFZYDR64H29A061Q','','2021-08-08','1965-02-14','3390983233','giova_rm@live.it','','Catania','Via Ros 20'),(12,'Amedeo','Preziosi','BSPTPZ98S27D997W','','2021-08-08','1956-07-07','3209874733','precius@alice.it','','Bari','Via Reja 88'),(13,'Amedeo','Preziosi','BSPTPZ98S27D997W','11045109023','2021-08-08','1956-07-07','3209874733','precius@alice.it',NULL,'Bari','Via Reja 88'),(20,'Alessio','Romagnoli','QRLPPL73S67G028J','','2021-08-11','1990-10-10','3398882211','a@gmail.com','','Milano','Via Milano 2'),(21,'Leonardo','Spinazzola','FLGFBC52M30D156C','102011112','2021-08-11','1993-05-17','3391111111','b@gmail.com','','Roma','Via Roma'),(22,'Michela','Durante','SNZNRV38C68D380Y','','2021-08-11','1978-10-13','3331233333','c@mail.it','','Torino','via Torino'),(23,'Michele','Giotto','STTLVG56D20B749O','','2021-08-11','1980-09-23','3390987777','d@gmail.com','','Napoli','via Napoli');
/*!40000 ALTER TABLE `Cliente` ENABLE KEYS */;

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ValidazioneEmail` BEFORE INSERT ON `Cliente` FOR EACH ROW BEGIN

IF NEW.Mail NOT LIKE '%_@__%.__%' THEN
      signal sqlstate '45001' set message_text='Formato mail non valido';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ValidazioneCF` BEFORE INSERT ON `Cliente` FOR EACH ROW BEGIN

if new.CodiceFiscale not regexp'^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$' then
signal sqlstate '45001' set message_text="Formato codice Fiscale errato";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Funzionario`
--

DROP TABLE IF EXISTS `Funzionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Funzionario` (
  `idFunzionario` int unsigned NOT NULL AUTO_INCREMENT,
  `Nome` varchar(30) NOT NULL,
  `Cognome` varchar(30) NOT NULL,
  PRIMARY KEY (`idFunzionario`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Funzionario`
--


/*!40000 ALTER TABLE `Funzionario` DISABLE KEYS */;
INSERT INTO `Funzionario` VALUES (1,'Michele','Volpi'),(2,'Leonardo','Pigna'),(3,'Michele','Crescenzi'),(4,'Simone','Barbara'),(5,'Alessandro','Zaccaria'),(6,'gino','sorbillo'),(7,'Ugo','Fantozzi'),(8,'Pietro','Porzio');
/*!40000 ALTER TABLE `Funzionario` ENABLE KEYS */;


--
-- Table structure for table `Nota`
--

DROP TABLE IF EXISTS `Nota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Nota` (
  `Tipo` enum('Costo','Assistenza','Servizio','Altro') NOT NULL,
  `PropostaReale_idPropostaReale` int NOT NULL,
  `Descrizione` varchar(150) NOT NULL,
  PRIMARY KEY (`Tipo`,`PropostaReale_idPropostaReale`),
  KEY `Nota_PropostaReale_idx` (`PropostaReale_idPropostaReale`),
  CONSTRAINT `fk_Nota_PropostaReale1` FOREIGN KEY (`PropostaReale_idPropostaReale`) REFERENCES `PropostaReale` (`idPropostaReale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nota`
--


/*!40000 ALTER TABLE `Nota` DISABLE KEYS */;
INSERT INTO `Nota` VALUES ('Costo',1,'equo'),('Costo',4,'costo adeguato al servizio'),('Costo',46,'ottimo'),('Assistenza',46,'Rapida'),('Servizio',3,'super'),('Servizio',4,'ottimo'),('Altro',3,'problemi nella chiamata'),('Altro',46,'apprezza la gentilezza');
/*!40000 ALTER TABLE `Nota` ENABLE KEYS */;


--
-- Table structure for table `Proposta`
--

DROP TABLE IF EXISTS `Proposta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Proposta` (
  `Codice` varchar(15) NOT NULL,
  `Scadenza` date NOT NULL,
  `Descrizione` varchar(150) NOT NULL,
  PRIMARY KEY (`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Proposta`
--

/*!40000 ALTER TABLE `Proposta` DISABLE KEYS */;
INSERT INTO `Proposta` VALUES ('ANDROMEDA','2021-08-08','Sconto passaparola'),('LITE','2022-05-16','consulenza feriale'),('MAGNUS','2023-03-17','consulenza 24 su 24, 7 su 7'),('PEGASO','2022-01-01','Promo base');
/*!40000 ALTER TABLE `Proposta` ENABLE KEYS */;


--
-- Table structure for table `PropostaReale`
--

DROP TABLE IF EXISTS `PropostaReale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PropostaReale` (
  `idPropostaReale` int NOT NULL AUTO_INCREMENT,
  `Giorno` date NOT NULL,
  `Esito` enum('Positivo','Negativo','Accettato','Altro') DEFAULT NULL,
  `Cliente_CodiceCliente` int unsigned NOT NULL,
  `Proposta_Codice` varchar(15) NOT NULL,
  `Funzionario_idFunzionario` int unsigned NOT NULL,
  PRIMARY KEY (`idPropostaReale`),
  KEY `PropostaReale_Cliente_idx` (`Cliente_CodiceCliente`),
  KEY `fk_PropostaReale_Proposta1_idx` (`Proposta_Codice`),
  KEY `fk_PropostaReale_Funzionario1_idx` (`Funzionario_idFunzionario`),
  CONSTRAINT `fk_PropostaReale_Cliente1` FOREIGN KEY (`Cliente_CodiceCliente`) REFERENCES `Cliente` (`CodiceCliente`),
  CONSTRAINT `fk_PropostaReale_Funzionario1` FOREIGN KEY (`Funzionario_idFunzionario`) REFERENCES `Funzionario` (`idFunzionario`),
  CONSTRAINT `fk_PropostaReale_Proposta1` FOREIGN KEY (`Proposta_Codice`) REFERENCES `Proposta` (`Codice`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PropostaReale`
--


/*!40000 ALTER TABLE `PropostaReale` DISABLE KEYS */;
INSERT INTO `PropostaReale` VALUES (1,'2021-08-07','Accettato',5,'LITE',4),(2,'2021-08-07','Negativo',6,'LITE',4),(4,'2021-08-07','Positivo',4,'LITE',1),(5,'2021-08-07','Positivo',1,'LITE',1),(6,'2021-08-08','Accettato',7,'PEGASO',3),(7,'2021-08-08','Positivo',8,'LITE',3);
/*!40000 ALTER TABLE `PropostaReale` ENABLE KEYS */;

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PropostaReale_PropostaUnica` BEFORE INSERT ON `PropostaReale` FOR EACH ROW BEGIN

           
IF NEW.Giorno  IN (SELECT Giorno
				   FROM `CRM-db`.`PropostaReale`
				   WHERE Cliente_CodiceCliente = NEW.Cliente_CodiceCliente)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' Un cliente non può ricevere una determinata proposta più volte al giorno.';
END IF;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PropostaReale_Funzionario` BEFORE INSERT ON `PropostaReale` FOR EACH ROW BEGIN
DECLARE num INT;

SET num = (SELECT count(Funzionario_idFunzionario)
		   FROM `CRM-db`.`PropostaReale`
           WHERE Cliente_CodiceCliente = NEW.Cliente_CodiceCliente);
           
IF num = 1 AND NEW.Funzionario_idFunzionario NOT IN (SELECT Funzionario_idFunzionario
															 FROM `CRM-db`.`PropostaReale`
															 WHERE Cliente_CodiceCliente = NEW.Cliente_CodiceCliente)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un cliente è associato ad un solo funzionario';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PropostaReale_PropostaDoppia` BEFORE INSERT ON `PropostaReale` FOR EACH ROW BEGIN

           
IF NEW.Proposta_Codice  IN (SELECT Proposta_Codice
				            FROM `CRM-db`.`PropostaReale`
							WHERE Cliente_CodiceCliente = NEW.Cliente_CodiceCliente)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' Un cliente non può ricevere una proposta uguale';
END IF;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PropostaReale_Scaduta` BEFORE INSERT ON `PropostaReale` FOR EACH ROW BEGIN

           
IF NEW.Proposta_Codice  IN (SELECT Codice
				            FROM `CRM-db`.`Proposta`
							WHERE Codice = NEW.Proposta_Codice AND Scadenza < curdate())
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La proposta è scaduta';
END IF;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Sala`
--

DROP TABLE IF EXISTS `Sala`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sala` (
  `NomeSala` varchar(20) NOT NULL,
  `Sede_NomeSede` varchar(20) NOT NULL,
  PRIMARY KEY (`NomeSala`,`Sede_NomeSede`),
  KEY `Sala_sede_idx` (`Sede_NomeSede`),
  CONSTRAINT `fk_Sala_Sede1` FOREIGN KEY (`Sede_NomeSede`) REFERENCES `Sede` (`NomeSede`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sala`
--


/*!40000 ALTER TABLE `Sala` DISABLE KEYS */;
INSERT INTO `Sala` VALUES ('C3','Gismondi'),('A4','SuccursaleA'),('B2','Torre'),('C3','Torre');
/*!40000 ALTER TABLE `Sala` ENABLE KEYS */;


--
-- Table structure for table `Sede`
--

DROP TABLE IF EXISTS `Sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sede` (
  `NomeSede` varchar(20) NOT NULL,
  `Indirizzo` varchar(45) NOT NULL,
  `Citta` varchar(45) NOT NULL,
  PRIMARY KEY (`NomeSede`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sede`
--


/*!40000 ALTER TABLE `Sede` DISABLE KEYS */;
INSERT INTO `Sede` VALUES ('Gismondi','via Roma 121','Roma'),('SuccursaleA','via Francia 21','Milano'),('Torre','via Marconi 10','Torino');
/*!40000 ALTER TABLE `Sede` ENABLE KEYS */;


--
-- Table structure for table `Utenti`
--

DROP TABLE IF EXISTS `Utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utenti` (
  `Username` varchar(30) NOT NULL,
  `Password` varchar(32) NOT NULL,
  `Ruolo` enum('Manager','Funzionario','Addetto') NOT NULL,
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utenti`
--


/*!40000 ALTER TABLE `Utenti` DISABLE KEYS */;
INSERT INTO `Utenti` VALUES ('addetto','d439d0062cb8091c4631cba953738705','Addetto'),('funzionario','dd482baf8abd9c2cbd25d9aa363a20c1','Funzionario'),('manager','1d0258c2440a8d19e716292b231e3190','Manager');
/*!40000 ALTER TABLE `Utenti` ENABLE KEYS */;


--
-- Dumping events for database 'CRM-db'
--

--
-- Dumping routines for database 'CRM-db'
--
/*!50003 DROP PROCEDURE IF EXISTS `accountRegistrazione` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountRegistrazione`(in var_Username VARCHAR(30),in var_Password VARCHAR(30),in var_Ruolo ENUM('Manager', 'Funzionario', 'Addetto'))
BEGIN
INSERT INTO `CRM-db`.`Utenti` (`Username`, `Password`, `Ruolo`)
VALUES (var_Username, md5(var_Password), var_Ruolo);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `calendario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `calendario`()
BEGIN
set transaction read only;
set transaction isolation level read committed;
start transaction;

select date_format(`Appuntamento`.`Giorno`,'%d-%m-%Y %k:%i') as Giorno,Sala_NomeSala as Sala, Sala_Sede_NomeSede as Sede
from `CRM-db`.`Appuntamento`;

COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `comunicaProposta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `comunicaProposta`( in var_Esito ENUM('Positivo','Negativo','Accettato','Altro'),in var_PropostaCodice VARCHAR(15), in var_Cliente_CodiceCliente INT, in var_Funzionario_idFunzionario INT, out idProposta INT)
BEGIN
DECLARE exit handler for sqlexception

begin
	rollback;
    resignal;
end;

set transaction read write;
set transaction isolation level serializable;
start transaction;

If var_PropostaCodice IN ( SELECT Nome
						   FROM `Proposta`)
THEN INSERT INTO `PropostaReale`(`Giorno`, `Esito`,`Proposta_Codice`, `Cliente_CodiceCliente`, `Funzionario_idFunzionario`) VALUES (curdate(), var_Esito, var_PropostaCodice, var_Cliente_CodiceCliente, var_Funzionario_idFunzionario);
SET idProposta = last_insert_id();
ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'codice Proposta inesistente';
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `esitoAppuntamento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `esitoAppuntamento`(in var_idAppuntamento VARCHAR(20), in var_Esito ENUM('Positivo','Accettato','Rifiutato','Altro'))
BEGIN
DECLARE id INT;
DECLARE codice INT;
DECLARE exit handler for sqlexception
begin
	rollback;
    resignal;
end;

set transaction read write;
set transaction isolation level read committed;
start transaction;

SELECT count(idAppuntamento) INTO codice
FROM `CRM-db`.`Appuntamento`
WHERE  idAppuntamento = var_idAppuntamento;

IF codice = 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Non esiste un appuntamento con tale codice.';
ELSE



IF var_Esito ='Accettato' or 'Negativo' THEN
SELECT idPropostaReale into id
FROM `CRM-db`.`PropostaReale` join `CRM-db`.`Appuntamento` on `PropostaReale`.`idPropostaReale` = `Appuntamento`.`PropostaReale_idPropostaReale`
WHERE `idAppuntamento` = var_idAppuntamento;

UPDATE `CRM-db`.`PropostaReale` SET `Esito` = var_Esito
WHERE `PropostaReale`.`idPropostaReale` = id;
ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esito appuntamento può essere solo "Accettato" o "Negativo"';

END IF;
END IF;

COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `gestioneNota` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `gestioneNota`(in var_PropostaReale INT, in var_Tipo ENUM('Costo', 'Assistenza', 'Servizio', 'Altro'), in var_Descrizione VARCHAR(150))
BEGIN
declare controllo VARCHAR(15);

begin
	rollback;
end;
set transaction read write;
set transaction isolation level serializable;
start transaction;

select `Tipo` INTO controllo
from `Nota`
where var_PropostaReale = `PropostaReale_idPropostaReale`AND var_Tipo = `Tipo`;

if controllo is NULL

THEN 
INSERT INTO `Nota`(`Tipo`, `Descrizione`, `PropostaReale_idPropostaReale`) VALUES (var_Tipo, var_Descrizione,var_PropostaReale);

ELSE 

UPDATE `Nota` SET `Tipo`= var_Tipo, `Descrizione`= var_Descrizione
WHERE `Nota`.`PropostaReale_idPropostaReale` = var_PropostaReale AND `Nota`.`Tipo` = var_Tipo;


END IF;
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisciAppuntamento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisciAppuntamento`(in var_Data DATETIME, in var_Sala_NomeSala VARCHAR(20), in var_Sala_Sede_NomeSede VARCHAR(20), in var_PropostaReale_idPropostaReale INT, in var_Nota VARCHAR(150))
BEGIN

DECLARE exit handler for sqlexception
begin
	rollback;
    resignal;
end;

set transaction read write;
set transaction isolation level serializable;
start transaction;

If var_Data >= curdate() THEN 
INSERT INTO `Appuntamento`(`Giorno`,`Sala_NomeSala`, `Sala_Sede_NomeSede`, `PropostaReale_idPropostaReale`,`Nota`) VALUES (var_Data, var_Sala_NomeSala, var_Sala_Sede_NomeSede, var_PropostaReale_idPropostaReale,var_Nota);
ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La data appuntamento deve essere postuma alla data odierna.';
END IF;
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisciCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisciCliente`(in var_Nome VARCHAR(30), in var_Cognome VARCHAR(30),in var_CodiceFiscale VARCHAR(17), in var_PartitaIva VARCHAR(11), in var_DataNascita DATE, in var_Telefono VARCHAR(11), in var_Mail VARCHAR(50), in var_Fax VARCHAR(11), in var_Citta VARCHAR(30), in var_Indirizzo VARCHAR(50))
BEGIN
DECLARE Difference INT;
DECLARE normaluser INT;
DECLARE ivauser    INT;
DECLARE exit handler for sqlexception
begin
	rollback;
    resignal;
end;

set transaction read write;
set transaction isolation level serializable;
start transaction;

SELECT count(`CodiceFiscale`) INTO normaluser
FROM `CRM-db`.`Cliente`
WHERE `CodiceFiscale` = var_CodiceFiscale AND `PartitaIva` = '';

IF normaluser = 1 and var_PartitaIva = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il cliente senza partita IVA è già presente.';
END IF;



SELECT count(`CodiceFiscale`) INTO ivauser
FROM `CRM-db`.`Cliente`
WHERE `CodiceFiscale` = var_CodiceFiscale AND  `PartitaIva`<> '';

IF ivauser = 1 and  var_PartitaIva <> '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il cliente con partita IVA è già presente.';
END IF;




SELECT timestampdiff(YEAR,var_DataNascita, curdate()) INTO Difference;
If Difference < '18' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il cliente deve essere maggiorenne';
ELSE INSERT INTO `Cliente`(`Nome`, `Cognome`,`CodiceFiscale`,`PartitaIva`, `DataRegistrazione`,`DataNascita`, `Telefono`,`Mail`, `Fax`,`Citta`,`Indirizzo`) VALUES (var_Nome, var_Cognome, var_CodiceFiscale, var_PartitaIva, curdate(), var_DataNascita, var_Telefono, var_Mail, var_Fax, var_Citta,var_Indirizzo);

END IF;

COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisciFunzionario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisciFunzionario`(IN var_nome varchar(30), IN var_cognome VARCHAR(30))
BEGIN
 insert into Funzionario(`Nome`,`Cognome`) VALUES (var_nome, var_cognome);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `inserisciProposta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserisciProposta`(in var_Codice VARCHAR(15), in var_Scadenza DATE, in var_Descrizione VARCHAR(150))
BEGIN

DECLARE exit handler for sqlexception
begin
	rollback;
    resignal;
end;

set transaction read write;
set transaction isolation level serializable;
start transaction;

If var_Scadenza >= curdate() THEN
INSERT INTO `Proposta`(`Codice`,`Scadenza`, `Descrizione`) VALUES (var_Codice,var_Scadenza, var_Descrizione);
ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La data di scadenza della proposta è precedente alla data odierna.';
END IF;



COMMIT;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listaClienti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaClienti`()
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;

SELECT DISTINCT(codiceCliente), Nome, Cognome, CodiceFiscale, PartitaIVA, IFNULL(Funzionario_idFunzionario,'') as Funzionario
FROM `CRM-db`.Cliente left join `CRM-db`.PropostaReale on CodiceCliente = Cliente_CodiceCliente;
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listaCodiciAppuntamenti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaCodiciAppuntamenti`()
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;

SELECT idAppuntamento, idPropostaReale, `Cliente`.`Nome`, `Cliente`.`Cognome`
FROM `CRM-db`.PropostaReale join `CRM-db`.Appuntamento on idPropostaReale = PropostaReale_idPropostaReale
join `CRM-db`.Cliente on CodiceCliente = Cliente_CodiceCliente;

COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listaComunicazioni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaComunicazioni`()
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;

SELECT idPropostaReale, Proposta_Codice, Nome, Cognome
FROM `CRM-db`.PropostaReale join `CRM-db`.Cliente
on  `Cliente`.CodiceCliente = `PropostaReale`.Cliente_CodiceCliente;
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listaNoteCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaNoteCliente`(in var_nome varchar(30), in var_cognome varchar(30))
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;
	
select `Proposta_Codice` as Proposta,`Cliente_CodiceCliente` as CodiceCliente,`Tipo`,`Descrizione`
from `Cliente` join `PropostaReale` on `PropostaReale`.`Cliente_CodiceCliente` = `Cliente`.`CodiceCliente`
join `Nota` on `Nota`.`PropostaReale_idPropostaReale` = `PropostaReale`.`idPropostaReale`
where `Cliente`.`Nome` = var_Nome and `Cliente`.`Cognome` = var_Cognome;

commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listaSedi` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaSedi`()
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;

SELECT nomeSala as Sala,NomeSede as Sede, Indirizzo, Citta
FROM `CRM-db`.Sala join `CRM-db`.Sede on NomeSede = Sede_NomeSede;
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `login`(in var_Username VARCHAR(30),in var_Password VARCHAR(30),out var_Ruolo INT)
BEGIN
 declare var_user_role ENUM('Funzionario', 'Addetto', 'Manager');
    
 select `Ruolo` from `Utenti`
  where `Username` = var_Username
        and `Password` = md5(var_Password)
        into var_user_role;
        
  if var_user_role = 'Funzionario' then
   set var_Ruolo = 1;
  elseif var_user_role = 'Manager' then
   set var_Ruolo = 2;
  elseif var_user_role = 'Addetto' then
   set var_Ruolo = 3;
  else
   set var_Ruolo = 0;
  end if;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ProposteAccettateSingolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProposteAccettateSingolo`(in var_nome varchar(30), in var_cognome varchar(30))
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;
	
select `CodiceCliente`as IDUtente ,`Proposta_Codice` as Proposta,`CodiceFiscale` as CF,`partitaIVA` as IVA, `Telefono`, `Mail`
from `Cliente` join `PropostaReale` on `PropostaReale`.`Cliente_CodiceCliente` = `Cliente`.`CodiceCliente`
where `Cliente`.`Nome` = var_Nome and `Cliente`.`Cognome` = var_Cognome  and `Esito` = 'Accettato';

commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizzaAppuntamento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizzaAppuntamento`(in var_Giorno DATETIME)
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;
	

    select `Sala_NomeSala`as Sala,`Sala_Sede_NomeSede`as Sede,date_format(`Appuntamento`.`Giorno`,'%d-%m-%Y %k:%i') as Giorno,`Nome`,`Cognome`, `Proposta_Codice`, `Appuntamento`. `Nota`
    from `Appuntamento` join `PropostaReale` on PropostaReale_idPropostaReale = idPropostaReale
    join `Cliente` on Cliente_CodiceCliente = CodiceCliente
    where DATE(`Appuntamento`.`Giorno`) = DATE(var_Giorno);
commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizzaClientePropostePendenti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizzaClientePropostePendenti`()
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;
	
    select `CodiceCliente`,`Cliente`.`Nome`,`Cliente`.`Cognome`,`idPropostaReale`,`Funzionario`.`Nome`,`Funzionario`.`Cognome`,`Funzionario`.`idFunzionario`
    from 
    `Cliente` join `PropostaReale` on `PropostaReale`.`Cliente_CodiceCLiente` = `Cliente`.`CodiceCliente`
    join  `Funzionario` on  `Funzionario`.`idFunzionario` = `Funzionario_idFunzionario`
    where  `Esito` = 'Positivo';
commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizzaClienteSingolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizzaClienteSingolo`(in var_nome varchar(30), in var_cognome varchar(30))
BEGIN

set transaction read only;
set transaction isolation level read committed;
start transaction;
	
select `CodiceCliente`,`Nome`,`Cognome`,`PartitaIVA`,`Telefono`
from `CRM-db`.`Cliente`
where `Nome` = var_Nome and `Cognome` = var_Cognome;
commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizzaClientiFunzionario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizzaClientiFunzionario`(in var_Funzionario INT)
BEGIN
set transaction read only;
set transaction isolation level read committed;
start transaction;
	
    select `Nome`, `Cognome`, `CodiceCliente`,`CodiceFiscale`,`Proposta_Codice`
    from `Cliente` join `PropostaReale` on `PropostaReale`.`Cliente_CodiceCLiente` = `Cliente`.`CodiceCliente`
    where `PropostaReale`.`Funzionario_idFunzionario` = var_Funzionario;
commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `visualizzaNota` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `visualizzaNota`(in var_Codice varchar(15))
BEGIN
set transaction read only;
set transaction isolation level read committed;
start transaction;

 select `CodiceCliente`, `Nome`, `Cognome`,`CodiceFiscale`,`Tipo`,`Descrizione`
    from `Cliente` join `PropostaReale` on `PropostaReale`.`Cliente_CodiceCLiente` = `Cliente`.`CodiceCliente`
    join `Nota` on  `Nota`.`PropostaReale_idPropostaReale` = `PropostaReale`.`idPropostaReale`
    where `Proposta_Codice` =  var_Codice;
commit;
END ;;
DELIMITER ;

DROP USER IF EXISTS login;
CREATE USER 'login' IDENTIFIED BY 'login';
GRANT EXECUTE ON procedure `CRM-db`.`login` TO 'login';

DROP USER IF EXISTS funzionario;
CREATE USER 'funzionario' IDENTIFIED BY 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`calendario` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`comunicaProposta` TO 'funzionario'; 
GRANT EXECUTE ON procedure `CRM-db`.`esitoAppuntamento` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`gestioneNota` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`inserisciAppuntamento` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`listaClienti` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`listaCodiciAppuntamenti` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`listaComunicazioni` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`listaNoteCliente` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`listaSedi` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`ProposteAccettateSingolo` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`visualizzaAppuntamento` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`visualizzaClienteSingolo` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`visualizzaClientePropostePendenti` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`visualizzaClientiFunzionario` TO 'funzionario';
GRANT EXECUTE ON procedure `CRM-db`.`visualizzaNota` TO 'funzionario';




DROP USER IF EXISTS manager;
CREATE USER 'manager' IDENTIFIED BY 'manager';
GRANT EXECUTE ON procedure `CRM-db`.`inserisciProposta` TO 'manager';
GRANT EXECUTE ON procedure `CRM-db`.`inserisciFunzionario` TO 'manager';

DROP USER IF EXISTS addetto;
CREATE USER 'addetto' IDENTIFIED BY 'addetto';
GRANT EXECUTE ON procedure `CRM-db`.`inserisciCliente` TO 'addetto';   


/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-12 23:28:33
