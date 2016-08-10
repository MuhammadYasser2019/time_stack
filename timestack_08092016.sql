-- MySQL dump 10.13  Distrib 5.6.28, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: timestack_development
-- ------------------------------------------------------
-- Server version	5.6.28-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Standards Performance Evaluation Corporation','7001 Heritage Village Plaza, Suite 225','Gainesville','VA','20155','2016-06-27 22:43:46','2016-06-27 22:43:46'),(2,'National Abortion Federation','1660 L St. NW, Suite #450','Washington','DC','20036','2016-06-27 22:44:09','2016-06-27 22:44:09'),(3,'Worldgate LLC','1760 Reston Parkway, Suite 312','Reston','VA','20190','2016-06-27 22:47:16','2016-06-27 22:47:16');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_projects_on_customer_id` (`customer_id`) USING BTREE,
  CONSTRAINT `fk_rails_47c768ed16` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Pacman Development',1,'2016-06-27 22:45:04','2016-07-15 15:22:24'),(2,'Hotline Database',2,'2016-06-27 22:45:39','2016-06-27 22:45:39'),(3,'Early Warning System',3,'2016-06-27 22:47:52','2016-06-27 22:47:52'),(4,'Good Behavior Game',3,'2016-06-27 22:48:19','2016-06-27 22:48:19');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20160430233752'),('20160501002555'),('20160501002653'),('20160501003056'),('20160501003210'),('20160501003327'),('20160501005441'),('20160509172415'),('20160515053342'),('20160515063652'),('20160515154128');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (1,'NEW','2016-06-27 19:47:59','2016-06-27 19:47:59'),(2,'SUBMITTED','2016-06-27 19:47:59','2016-06-27 19:47:59'),(3,'APPROVED','2016-06-27 19:47:59','2016-06-27 19:47:59'),(4,'REJECTED','2016-06-27 19:47:59','2016-06-27 19:47:59');
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tasks_on_project_id` (`project_id`) USING BTREE,
  CONSTRAINT `fk_rails_02e851e3b7` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'P4','Phase 4 development of Pacman',1,'2016-06-27 22:46:14','2016-06-27 22:46:14'),(2,'Mailmerge Deployment','Mailmerge Deployment',2,'2016-06-27 22:46:57','2016-06-27 22:46:57'),(3,'General Support','Supporting Hotline database',2,'2016-06-29 13:48:47','2016-06-29 13:48:47'),(4,'BUGFIXING','Fixing Identified bugs',4,'2016-06-29 13:49:28','2016-06-29 13:49:28'),(5,'PACMANSUPP','Pacman Support',1,'2016-07-15 15:22:53','2016-07-15 15:22:53');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_entries`
--

DROP TABLE IF EXISTS `time_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_of_activity` datetime DEFAULT NULL,
  `hours` int(11) DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `week_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_time_entries_on_task_id` (`task_id`) USING BTREE,
  KEY `index_time_entries_on_user_id` (`user_id`) USING BTREE,
  KEY `index_time_entries_on_week_id` (`week_id`) USING BTREE,
  CONSTRAINT `fk_rails_09c8bd6d2c` FOREIGN KEY (`week_id`) REFERENCES `weeks` (`id`),
  CONSTRAINT `fk_rails_55dd5dcf98` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`),
  CONSTRAINT `fk_rails_b471d1824b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_entries`
--

LOCK TABLES `time_entries` WRITE;
/*!40000 ALTER TABLE `time_entries` DISABLE KEYS */;
INSERT INTO `time_entries` VALUES (1,'2016-07-10 00:00:00',NULL,'',1,3,1,'2016-06-27 22:48:41','2016-07-16 16:45:28',1),(2,'2016-07-11 00:00:00',1,'Regenerate assets so tabs-spec.png is correctly loaded from within tabs-spec.css in production',1,3,1,'2016-06-27 22:48:41','2016-07-16 16:45:28',1),(3,'2016-07-12 00:00:00',NULL,'',NULL,3,1,'2016-06-27 22:48:41','2016-06-27 22:50:05',NULL),(4,'2016-07-13 00:00:00',4,'Trying to modify the members list for groups so the members are categorized by their status',1,3,1,'2016-06-27 22:48:41','2016-07-16 16:45:28',1),(5,'2016-07-14 00:00:00',3,'Resort the invitees list and test and deploy to development',1,3,1,'2016-06-27 22:48:41','2016-07-16 16:45:28',1),(6,'2016-07-15 00:00:00',6,'Review Member status change code. Our objective is as to how does the mailing list get updated (if it does get updated)even though the code performing the status change on member does not seem to  set any dirty flags',1,3,1,'2016-06-27 22:48:41','2016-07-16 16:45:28',1),(7,'2016-07-16 00:00:00',NULL,'',NULL,3,1,'2016-06-27 22:48:41','2016-06-27 22:50:06',NULL),(8,'2016-07-11 00:00:00',2,'Planning on deployment to production',2,3,1,'2016-06-27 22:50:05','2016-06-27 22:50:05',2),(9,'2016-06-26 00:00:00',NULL,'',NULL,1,1,'2016-06-29 13:47:31','2016-06-29 13:48:05',NULL),(10,'2016-06-27 00:00:00',NULL,'',NULL,1,1,'2016-06-29 13:47:31','2016-06-29 13:48:05',NULL),(11,'2016-06-28 00:00:00',1,'Regenerated assets in production',1,1,1,'2016-06-29 13:47:31','2016-06-29 13:48:05',1),(12,'2016-06-29 00:00:00',8,'Change the query in access database so it can be updated in remote database',2,1,1,'2016-06-29 13:47:31','2016-07-28 19:09:55',2),(13,'2016-06-30 00:00:00',1,'Meeting with Christine',2,1,1,'2016-06-29 13:47:31','2016-07-28 19:09:55',2),(14,'2016-07-01 00:00:00',NULL,'',NULL,1,1,'2016-06-29 13:47:31','2016-06-29 13:48:05',NULL),(15,'2016-07-02 00:00:00',NULL,'',NULL,1,1,'2016-06-29 13:47:31','2016-06-29 13:48:05',NULL),(16,'2016-06-30 00:00:00',0,'Meeting with Brian and team to review Sprint 3',4,1,1,'2016-06-29 13:51:12','2016-06-29 13:51:12',4),(17,'2016-07-02 00:00:00',NULL,'',NULL,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',NULL),(18,'2016-07-03 00:00:00',NULL,'',NULL,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',NULL),(19,'2016-07-04 00:00:00',NULL,'',NULL,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',NULL),(20,'2016-07-05 00:00:00',8,'Bug Fix and testing of Delete User Bugzilla Id  27',1,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',1),(21,'2016-07-06 00:00:00',NULL,'',NULL,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',NULL),(22,'2016-07-07 00:00:00',NULL,'',NULL,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',NULL),(23,'2016-07-08 00:00:00',NULL,'',NULL,2,1,'2016-07-05 23:11:01','2016-07-05 23:12:33',NULL),(24,'2016-07-17 00:00:00',NULL,'',NULL,5,1,'2016-07-20 16:43:35','2016-07-20 16:46:53',NULL),(25,'2016-07-18 00:00:00',2,'Fix the wikiname syncronization with pacman database username',1,5,1,'2016-07-20 16:43:36','2016-07-28 19:08:55',1),(26,'2016-07-19 00:00:00',2,'Onsite meeting',1,5,1,'2016-07-20 16:43:36','2016-07-28 19:08:55',1),(27,'2016-07-20 00:00:00',5,'Fix the update of wikiname when a username is updated in pacman',1,5,1,'2016-07-20 16:43:36','2016-07-28 19:08:55',1),(28,'2016-07-21 00:00:00',NULL,'',NULL,5,1,'2016-07-20 16:43:36','2016-07-20 16:46:53',NULL),(29,'2016-07-22 00:00:00',NULL,'',NULL,5,1,'2016-07-20 16:43:36','2016-07-20 16:46:53',NULL),(30,'2016-07-23 00:00:00',NULL,'',NULL,5,1,'2016-07-20 16:43:36','2016-07-20 16:46:54',NULL),(31,'2016-07-19 00:00:00',3,'Fix url in user notification emails',1,5,1,'2016-07-20 16:46:53','2016-07-28 19:08:55',1),(32,'2016-07-24 00:00:00',NULL,'',NULL,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',NULL),(33,'2016-07-25 00:00:00',2,'Fixed Mailing list sorting, Request invitations list',5,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',1),(34,'2016-07-26 00:00:00',1,'Fixed dmz form to show Other',5,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',1),(35,'2016-07-27 00:00:00',0,'Deployment to production and verify changes.',5,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',1),(36,'2016-07-28 00:00:00',NULL,'',NULL,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',NULL),(37,'2016-07-29 00:00:00',NULL,'',NULL,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',NULL),(38,'2016-07-30 00:00:00',NULL,'',NULL,6,1,'2016-07-28 19:05:47','2016-07-28 19:08:38',NULL);
/*!40000 ALTER TABLE `time_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_week_statuses`
--

DROP TABLE IF EXISTS `user_week_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_week_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status_id` int(11) DEFAULT NULL,
  `week_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_week_statuses_on_user_id` (`user_id`) USING BTREE,
  KEY `index_user_week_statuses_on_week_id` (`week_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_week_statuses`
--

LOCK TABLES `user_week_statuses` WRITE;
/*!40000 ALTER TABLE `user_week_statuses` DISABLE KEYS */;
INSERT INTO `user_week_statuses` VALUES (1,2,1,1,'2016-06-27 22:28:07','2016-07-28 19:09:55'),(2,2,3,1,'2016-06-27 22:48:41','2016-07-28 19:09:13'),(3,2,2,1,'2016-07-05 23:11:01','2016-07-28 19:09:36'),(4,2,5,1,'2016-07-20 16:43:35','2016-07-28 19:08:55'),(5,1,6,1,'2016-07-28 19:05:47','2016-07-28 19:05:47');
/*!40000 ALTER TABLE `user_week_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`) USING BTREE,
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'sameer.sharma@resourcestack.com','$2a$11$ZdycCQoX6I67knUrIqNFYuImH66rSB0H.xF5EtuXzz/6MNq8onmwG',NULL,NULL,NULL,12,'2016-08-08 21:38:11','2016-07-28 15:39:41','205.160.171.251','192.168.1.1','2016-06-27 22:27:07','2016-08-08 21:38:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weeks`
--

DROP TABLE IF EXISTS `weeks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weeks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weeks`
--

LOCK TABLES `weeks` WRITE;
/*!40000 ALTER TABLE `weeks` DISABLE KEYS */;
INSERT INTO `weeks` VALUES (1,'2016-06-26 00:00:00','2016-07-01 00:00:00','2016-06-27 22:27:50','2016-06-27 22:27:50'),(2,'2016-07-02 00:00:00','2016-07-09 00:00:00','2016-06-27 22:42:02','2016-06-27 22:42:02'),(3,'2016-07-10 00:00:00','2016-07-16 00:00:00','2016-06-27 22:43:04','2016-06-27 22:43:04'),(5,'2016-07-17 00:00:00','2016-07-23 00:00:00','2016-07-13 19:58:54','2016-07-13 19:58:54'),(6,'2016-07-24 00:00:00','2016-07-30 00:00:00','2016-07-28 15:56:51','2016-07-28 15:56:51'),(7,'2016-07-31 00:00:00','2016-08-06 00:00:00','2016-07-28 15:57:20','2016-07-28 15:57:20');
/*!40000 ALTER TABLE `weeks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-08-09 16:07:06
