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

/*Table structure for table `submit_category` */

DROP TABLE IF EXISTS `submit_category`;

CREATE TABLE `submit_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '信息类别名称',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  `user_account` varchar(50) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*Data for the table `submit_category` */

insert  into `submit_category`(`id`,`name`,`create_time`,`update_time`,`user_account`) values (1,'领导活动',NULL,NULL,''),(2,'党的建设',NULL,NULL,NULL),(3,'安全生产',NULL,NULL,NULL),(4,'电网发展',NULL,NULL,NULL),(5,'深化改革',NULL,NULL,NULL),(6,'产业转型',NULL,NULL,NULL),(7,'精益管理',NULL,NULL,NULL),(8,'科技兴网',NULL,NULL,NULL),(9,'优质服务',NULL,NULL,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
