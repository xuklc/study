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

/*Table structure for table `submit_notification` */

DROP TABLE IF EXISTS `submit_notification`;

CREATE TABLE `submit_notification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `start_time` date DEFAULT NULL COMMENT '开始时间',
  `end_time` date DEFAULT NULL COMMENT '结束时间',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `compilation_date` date DEFAULT NULL COMMENT '编制时间',
  `info_status` varchar(100) DEFAULT NULL COMMENT '状态',
  `scope` varchar(500) DEFAULT NULL COMMENT '发送范围',
  `document` varchar(500) DEFAULT NULL COMMENT '正文',
  `user_account` varchar(50) DEFAULT NULL COMMENT '创建人账号',
  `dept_id` varchar(50) DEFAULT NULL COMMENT '部门',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  `proc_inst_id` varchar(32) DEFAULT NULL COMMENT '流程实例id',
  `proc_start_time` bigint(20) DEFAULT NULL COMMENT '流程开始时间',
  `proc_end_time` bigint(20) DEFAULT NULL COMMENT '流程结束时间',
  `proc_startor` varchar(64) DEFAULT NULL COMMENT '流程发起人',
  `proc_state` varchar(30) DEFAULT NULL COMMENT '流程状态',
  `proc_task_handler` varchar(64) DEFAULT NULL COMMENT '流程当前处理人',
  `release_time` datetime DEFAULT NULL COMMENT '发布时间',
  `range` varchar(1000) DEFAULT NULL COMMENT '发送范围',
  `isfinalized` varchar(20) DEFAULT NULL COMMENT '是否已定稿',
  `corp_id` varchar(50) DEFAULT NULL COMMENT '单位id',
  `corp_name` varchar(50) DEFAULT NULL COMMENT '单位名称',
  `tenant_info_id` varchar(10) DEFAULT NULL COMMENT '租户ID',
  `dept_name` varchar(50) DEFAULT NULL COMMENT '部门名称',
  `subordinate_unit_ids` varchar(1000) DEFAULT NULL COMMENT '要发送给下属单位的人员账号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8;

/*Data for the table `submit_notification` */

insert  into `submit_notification`(`id`,`start_time`,`end_time`,`name`,`compilation_date`,`info_status`,`scope`,`document`,`user_account`,`dept_id`,`create_time`,`update_time`,`proc_inst_id`,`proc_start_time`,`proc_end_time`,`proc_startor`,`proc_state`,`proc_task_handler`,`release_time`,`range`,`isfinalized`,`corp_id`,`corp_name`,`tenant_info_id`,`dept_name`,`subordinate_unit_ids`) values (195,'2018-12-27','2018-12-27','2018年12-12月南方电网公司信息工作情况通报','2018-12-28','Draft',NULL,'f4baf99302b74d2d88172adb2ff2c564','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1545966487808,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'总工程师,总经理助理',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11',NULL,''),(196,'2019-01-10','2019-01-10','2019年1-1月南方电网公司信息工作情况通报','2019-01-10','notify',NULL,'ee46834b49954a0b881b7469ee0ebe23','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1547117434797,1547117603460,'16837629b22f287fe32c83c406d91aa8',1547117400000,1547117602459,'chengwei_01@csg.cn','流程结束','','2019-01-10 18:53:22','公司领导','0','c29cd3da9458461191b5b2d5e8417346',NULL,'11',NULL,''),(209,'2019-01-15','2019-01-21','2019年1-1月南方电网公司信息工作情况通报','2019-01-21','notify',NULL,'c7dcda8a869641868c54ed92e30ad08d','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1548058715651,1548058942918,'1686f7d6966b06bca7c1a7546839da4b',1548058719853,1548058941922,'chengwei_01@csg.cn',NULL,'','2019-01-21 16:22:22','总法律顾问,公司领导','0','c29cd3da9458461191b5b2d5e8417346',NULL,'11',NULL,'');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
