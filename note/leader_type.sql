/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.6.41 : Database - oa-nx
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`oa-nx` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `oa-nx`;

/*Table structure for table `submit_leader_approval_type` */

DROP TABLE IF EXISTS `submit_leader_approval_type`;

CREATE TABLE `submit_leader_approval_type` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `approval_type` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `submit_leader_approval_type` */

insert  into `submit_leader_approval_type`(`id`,`create_time`,`update_time`,`approval_type`) values (1,NULL,NULL,'党中央、国务院领导同志批示'),(2,NULL,NULL,'中央国家等有关部委领导同志批示'),(3,NULL,NULL,'公司领导、南方五省及广州、深圳市党委、政府领导同志批示');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
