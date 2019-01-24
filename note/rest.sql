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

/*Table structure for table `submit_restricted` */

DROP TABLE IF EXISTS `submit_restricted`;

CREATE TABLE `submit_restricted` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `periods` varchar(100) DEFAULT NULL COMMENT '期数',
  `compilation_date` date DEFAULT NULL COMMENT '编制时间',
  `status` varchar(50) DEFAULT NULL COMMENT '状态',
  `range` varchar(500) DEFAULT NULL COMMENT '发送范围',
  `user_account` varchar(50) DEFAULT NULL COMMENT '创建人',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  `document` varchar(500) DEFAULT NULL COMMENT '文档',
  `proc_inst_id` varchar(50) DEFAULT NULL COMMENT '流程实例id',
  `proc_start_time` varchar(50) DEFAULT NULL COMMENT '流程开始时间',
  `proc_end_time` varchar(50) DEFAULT NULL COMMENT '流程结束时间',
  `proc_state` varchar(50) DEFAULT NULL COMMENT '流程状态',
  `proc_task_handler` varchar(50) DEFAULT NULL COMMENT '流程下一环节处理人',
  `isfinalized` varchar(50) DEFAULT NULL COMMENT '是否定稿',
  `proc_startor` varchar(50) DEFAULT NULL COMMENT '流程发起人',
  `corp_id` varchar(50) DEFAULT NULL COMMENT '单位id',
  `subordinate_unit_ids` varchar(1000) DEFAULT NULL COMMENT '要发送给下属单位的人员账号',
  `tenant_info_id` varchar(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

/*Data for the table `submit_restricted` */

insert  into `submit_restricted`(`id`,`name`,`periods`,`compilation_date`,`status`,`range`,`user_account`,`create_time`,`update_time`,`document`,`proc_inst_id`,`proc_start_time`,`proc_end_time`,`proc_state`,`proc_task_handler`,`isfinalized`,`proc_startor`,`corp_id`,`subordinate_unit_ids`,`tenant_info_id`) values (1,'test','1','2019-01-10','notify','\"公司领导\"','chengwei_01@csg.cn',1547116092877,1547116570671,'cd5bba7f3b764b89864381d29324b7a9','168374e2165c99af144e1c84bf99f06a','1547116080000','1547116570318','流程结束','','0','chengwei_01@csg.cn','c29cd3da9458461191b5b2d5e8417346','','11'),(2,'zhengzhiquan_01@csg.cn','2','2019-01-10','notify','总法律顾问','chengwei_01@csg.cn',1547120674154,1547120851980,'f069bb3b44834e67ba0aec9f163e15cc','168379408f08eb8122d637141da9b681','1547120640000','1547120851712','流程结束','','0','chengwei_01@csg.cn','c29cd3da9458461191b5b2d5e8417346','','11'),(3,'士大夫打发士大夫','3','2019-01-13','Draft','\"总法律顾问,公司领导\"','chengwei_01@csg.cn',1547361158100,1548051878292,'1207afe94580415e958c1dbc7a466637','16845ea3b491773720596074553ad078','1547361180000','1548051878289','同意发布','chengwei_01@csg.cn','0','chengwei_01@csg.cn','c29cd3da9458461191b5b2d5e8417346','','11'),(5,'二万人','4','2019-01-13','notify','总法律顾问,公司领导','chengwei_01@csg.cn',1547361283978,1548051865573,'5150131be6784fc2b1f87521a6009e52','16845eb7c891e3b84085119498f99731','1547361240000','1548051865303','同意发布','','0','chengwei_01@csg.cn','c29cd3da9458461191b5b2d5e8417346','','11'),(11,'学','1','2019-01-21','audit','总法律顾问','zhaiyj@gzyj.csg.cn',1548069771896,1548121052489,'98438b6c72164ab7abb4d3db28ec6704','16870262017739340b130534e9d93eb6','1548069776415',NULL,'同意发布','zhaiyj@gzyj.csg.cn',NULL,'zhaiyj@gzyj.csg.cn','99E0FB6933EF4DBA8E9B0B67407193E2',NULL,'6');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
