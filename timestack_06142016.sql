-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: timestack_development
-- ------------------------------------------------------
-- Server version	5.5.47-0ubuntu0.14.04.1

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Standard Performance Evaluation Corporation','7001 Heritage Village Plaza, Suite 225','Gainesville','VA','20155','2016-05-09 18:05:06','2016-05-09 18:05:06'),(2,'National Abortion Federation','1660 L St. NW, Suite #450','Washington','DC','20036','2016-05-09 18:06:10','2016-05-09 18:06:10'),(3,'American Institute of Research','','Washington','DC','','2016-05-09 18:06:50','2016-05-09 18:06:50'),(4,'Resource Stack, Inc.','626 Grant St. #D','Herndon','VA','20170','2016-05-09 19:26:50','2016-05-09 19:26:50');
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
  KEY `index_projects_on_customer_id` (`customer_id`),
  CONSTRAINT `fk_rails_47c768ed16` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Pacman',1,'2016-05-09 18:44:57','2016-05-09 19:25:38'),(2,'Early Warning System',3,'2016-05-09 18:45:16','2016-05-09 19:25:50'),(3,'Good Behavior Game',3,'2016-05-09 18:45:38','2016-05-09 19:26:01'),(4,'Hotline Database',2,'2016-05-09 18:45:56','2016-05-09 19:26:13'),(5,'test project',4,'2016-05-09 18:48:45','2016-05-09 19:27:11'),(6,'Internal',4,'2016-05-09 19:27:26','2016-05-09 19:27:26');
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
INSERT INTO `statuses` VALUES (1,'NEW','2016-05-15 15:44:58','2016-05-15 15:44:58'),(2,'SUBMITTED','2016-05-15 15:44:58','2016-05-15 15:44:58'),(3,'APPROVED','2016-05-15 15:44:58','2016-05-15 15:44:58'),(4,'REJECTED','2016-05-15 15:44:58','2016-05-15 15:44:58');
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
  KEY `index_tasks_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_02e851e3b7` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'P1','Phase 1 development to improve Search',1,'2016-05-09 19:47:16','2016-05-09 19:47:16'),(2,'P2','Phase 2 For Search Performance',1,'2016-05-09 19:47:37','2016-05-09 19:47:37'),(3,'P3','Deploy to production Pacman improved Search',1,'2016-05-09 19:47:59','2016-05-09 19:47:59'),(4,'H1','Mailmerge',4,'2016-05-09 19:48:17','2016-05-09 19:48:17'),(5,'B1','Bug Fixing',3,'2016-05-09 19:48:38','2016-05-09 19:48:38'),(6,'G1','General Support',4,'2016-05-09 19:49:07','2016-05-09 19:49:07'),(7,'G2','General Support',2,'2016-05-09 19:49:29','2016-05-09 19:49:29'),(8,'B2','Bug Fixing',2,'2016-05-09 19:50:01','2016-05-09 19:50:01');
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
  KEY `index_time_entries_on_task_id` (`task_id`),
  KEY `index_time_entries_on_week_id` (`week_id`),
  KEY `index_time_entries_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_09c8bd6d2c` FOREIGN KEY (`week_id`) REFERENCES `weeks` (`id`),
  CONSTRAINT `fk_rails_55dd5dcf98` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`),
  CONSTRAINT `fk_rails_b471d1824b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_entries`
--

LOCK TABLES `time_entries` WRITE;
/*!40000 ALTER TABLE `time_entries` DISABLE KEYS */;
INSERT INTO `time_entries` VALUES (2,'2016-05-01 00:00:00',8,'dfdfdf',2,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(3,'2016-05-02 00:00:00',0,'',1,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(4,'2016-05-03 00:00:00',0,'',1,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(5,'2016-05-04 00:00:00',0,'',1,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(6,'2016-05-05 00:00:00',0,'',1,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(7,'2016-05-06 00:00:00',0,'',1,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(8,'2016-05-07 00:00:00',0,'',1,1,2,'2016-05-02 19:08:38','2016-06-01 21:34:39',1),(9,'2016-05-08 00:00:00',0,'weekend',1,2,1,'2016-05-15 02:29:45','2016-05-15 06:08:32',1),(10,'2016-05-09 00:00:00',8,'monday is funday',1,2,1,'2016-05-15 02:29:45','2016-05-15 06:08:32',1),(11,'2016-05-10 00:00:00',8,'Tuesdays  are generally  EWS',1,2,1,'2016-05-15 02:29:45','2016-05-22 03:49:10',2),(12,'2016-05-11 00:00:00',8,'Wednesday ko hotline',1,2,1,'2016-05-15 02:29:45','2016-05-22 03:49:10',4),(13,'2016-05-12 00:00:00',8,'pacman',1,2,1,'2016-05-15 02:29:45','2016-05-15 06:08:33',1),(14,'2016-05-13 00:00:00',8,'pacman phase 2',2,2,1,'2016-05-15 02:29:45','2016-05-15 06:08:33',1),(15,'2016-05-14 00:00:00',NULL,'',1,2,1,'2016-05-15 02:29:45','2016-05-15 06:08:33',1),(16,'2016-05-15 00:00:00',0,'cannot work on  a  weekend',1,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',1),(17,'2016-05-16 00:00:00',8,'finish mail merge for  clinic exception',4,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',4),(18,'2016-05-17 00:00:00',8,'Mail  merge for  clinic  exception  ',4,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',4),(19,'2016-05-18 00:00:00',8,'add user test case',2,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',1),(20,'2016-05-19 00:00:00',8,'add user test  case',2,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',1),(21,'2016-05-20 00:00:00',8,'testing  should  be complete',8,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',3),(22,'2016-05-21 00:00:00',8,'test   cases should be complete',8,3,1,'2016-05-15 16:07:02','2016-05-15 23:33:19',3),(23,'2016-05-08 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(24,'2016-05-09 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(25,'2016-05-10 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(26,'2016-05-11 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(27,'2016-05-12 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(28,'2016-05-13 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(29,'2016-05-14 00:00:00',NULL,'',1,1,2,'2016-05-20 16:54:45','2016-06-01 21:34:39',1),(30,'2016-05-22 00:00:00',0,'Weekend',2,4,1,'2016-05-20 17:33:40','2016-05-24 12:26:27',1),(31,'2016-05-23 00:00:00',4,'Develop automated tester  enhancement  to communicate  true/false  to alert dialogs',2,4,1,'2016-05-20 17:33:40','2016-05-24 12:26:28',1),(32,'2016-05-24 00:00:00',2,'Finished automated tester  enhancement  to communicate  true/false  to alert dialogs',2,4,1,'2016-05-20 17:33:40','2016-05-24 12:26:28',1),(33,'2016-05-25 00:00:00',2,'Added new  test cases for  CRUD functionality of Users, members, and  spec groups',2,4,1,'2016-05-20 17:33:40','2016-05-24 12:26:28',1),(34,'2016-05-26 00:00:00',1,'Now adding 1 hour to thursday',2,4,1,'2016-05-20 17:33:40','2016-06-01 01:34:59',1),(35,'2016-05-27 00:00:00',8,'Identified  and  fixed  cases for  member  flag being null to  be  prepopulated  as  false.',2,4,1,'2016-05-20 17:33:40','2016-05-24 12:26:28',1),(36,'2016-05-28 00:00:00',NULL,'',1,4,1,'2016-05-20 17:33:40','2016-05-24 12:26:28',1),(37,'2016-05-15 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:08',1),(38,'2016-05-16 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:08',1),(39,'2016-05-17 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:08',1),(40,'2016-05-18 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:08',1),(41,'2016-05-19 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:09',1),(42,'2016-05-20 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:09',1),(43,'2016-05-21 00:00:00',NULL,'',1,1,2,'2016-05-21 03:35:49','2016-06-01 21:35:09',1),(44,'2016-05-08 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(45,'2016-05-09 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(46,'2016-05-10 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(47,'2016-05-11 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(48,'2016-05-12 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(49,'2016-05-13 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(50,'2016-05-14 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:03','2016-05-22 02:09:03',NULL),(51,'2016-05-08 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(52,'2016-05-09 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(53,'2016-05-10 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(54,'2016-05-11 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(55,'2016-05-12 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(56,'2016-05-13 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(57,'2016-05-14 00:00:00',NULL,NULL,NULL,NULL,1,'2016-05-22 02:09:19','2016-05-22 02:09:19',NULL),(58,'2016-05-22 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:09',1),(59,'2016-05-23 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:09',1),(60,'2016-05-24 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:09',1),(61,'2016-05-25 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:09',1),(62,'2016-05-26 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:09',1),(63,'2016-05-27 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:09',1),(64,'2016-05-28 00:00:00',NULL,'',1,1,2,'2016-06-01 21:34:39','2016-06-01 21:35:10',1);
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
  KEY `index_user_week_statuses_on_week_id` (`week_id`),
  KEY `index_user_week_statuses_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_week_statuses`
--

LOCK TABLES `user_week_statuses` WRITE;
/*!40000 ALTER TABLE `user_week_statuses` DISABLE KEYS */;
INSERT INTO `user_week_statuses` VALUES (1,2,3,1,'2016-05-15 17:38:33','2016-05-15 23:33:18'),(2,2,2,1,'2016-05-16 00:15:23','2016-05-22 03:49:10'),(3,1,1,1,'2016-05-16 00:22:11','2016-06-14 17:46:21'),(4,2,4,1,'2016-05-20 17:33:40','2016-06-14 17:46:47'),(5,1,1,NULL,'2016-06-01 21:34:38','2016-06-01 21:35:08'),(6,NULL,1,NULL,'2016-06-14 17:46:21','2016-06-14 17:46:21');
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
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'sameer.sharma@resourcestack.com','$2a$11$lI7KQMEArFlJ2LpDpScnDu0SC.To.6thyjQQR37C1MWwbvXJF4gNa',NULL,NULL,NULL,22,'2016-06-14 17:43:49','2016-06-01 14:20:20','172.16.233.1','127.0.0.1','2016-04-30 23:50:55','2016-06-14 17:43:49'),(2,'marshall.schulte@resourcestack.com','$2a$11$B4hlbIbqNkUVfi8CtKJBneLzJF9nBRyZ9WbIDfX.2F4FDaAAj3OpG',NULL,NULL,NULL,4,'2016-06-01 21:34:33','2016-05-20 16:54:30','127.0.0.1','127.0.0.1','2016-05-20 02:57:20','2016-06-01 21:34:33');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weeks`
--

LOCK TABLES `weeks` WRITE;
/*!40000 ALTER TABLE `weeks` DISABLE KEYS */;
INSERT INTO `weeks` VALUES (1,'2016-05-01 00:00:00','2016-05-07 00:00:00','2016-05-01 02:15:23','2016-05-02 01:22:34'),(2,'2016-05-08 00:00:00','2016-05-14 00:00:00','2016-05-01 02:15:54','2016-05-02 01:22:50'),(3,'2016-05-15 00:00:00','2016-05-21 00:00:00','2016-05-01 02:16:20','2016-05-02 01:23:06'),(4,'2016-05-22 00:00:00','2016-05-28 00:00:00','2016-05-01 02:16:52','2016-05-02 01:23:26'),(5,'2016-05-29 00:00:00','2016-06-04 00:00:00','2016-05-01 02:17:19','2016-05-02 01:23:52');
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

-- Dump completed on 2016-06-14 14:34:42
