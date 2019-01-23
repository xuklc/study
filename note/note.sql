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

/*Table structure for table `submit_leader_note` */

DROP TABLE IF EXISTS `submit_leader_note`;

CREATE TABLE `submit_leader_note` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `approval_type` bigint(20) DEFAULT NULL,
  `approval_content` varchar(500) DEFAULT NULL COMMENT '批示内容',
  `attachment` varchar(500) DEFAULT NULL COMMENT '附件信息',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  `submit_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `submit_id` (`submit_id`),
  CONSTRAINT `submit_leader_note_ibfk_1` FOREIGN KEY (`submit_id`) REFERENCES `submit_submitted` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

/*Data for the table `submit_leader_note` */

insert  into `submit_leader_note`(`id`,`approval_type`,`approval_content`,`attachment`,`create_time`,`update_time`,`submit_id`) values (37,2,'测试12',NULL,NULL,NULL,125),(38,1,'测试33',NULL,NULL,NULL,125),(39,1,'关于今后的发展',NULL,NULL,NULL,141);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
