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

/*Table structure for table `submit_comprehensive` */

DROP TABLE IF EXISTS `submit_comprehensive`;

CREATE TABLE `submit_comprehensive` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(200) DEFAULT NULL COMMENT '期刊名称',
  `periods` varchar(100) DEFAULT NULL COMMENT '期数',
  `compilation_date` date DEFAULT NULL COMMENT '编制时间',
  `status` varchar(50) DEFAULT NULL COMMENT '刊物状态',
  `range` varchar(500) DEFAULT NULL COMMENT '发送范围',
  `statistics` varchar(500) DEFAULT NULL COMMENT '综合统计信息',
  `user_account` varchar(50) DEFAULT NULL COMMENT '创建人',
  `dept_id` varchar(50) DEFAULT NULL COMMENT '部门id',
  `create_time` bigint(20) DEFAULT NULL COMMENT '创建时间',
  `update_time` bigint(20) DEFAULT NULL COMMENT '更新时间',
  `document` varchar(500) DEFAULT NULL COMMENT '文档',
  `proc_inst_id` varchar(32) DEFAULT NULL COMMENT '流程实例id',
  `proc_start_time` bigint(20) DEFAULT NULL COMMENT '流程开始时间',
  `proc_end_time` bigint(20) DEFAULT NULL COMMENT '流程结束时间',
  `proc_startor` varchar(64) DEFAULT NULL COMMENT '流程发起人',
  `proc_state` varchar(30) DEFAULT NULL COMMENT '流程状态',
  `proc_task_handler` varchar(50) DEFAULT NULL COMMENT '当前流程处理人',
  `isfinalized` varchar(20) DEFAULT NULL COMMENT '是否定稿',
  `corp_id` varchar(50) DEFAULT NULL COMMENT '单位id',
  `subordinate_unit_ids` varchar(1000) DEFAULT NULL COMMENT '要发送给下属单位的人员账号',
  `tenant_info_id` varchar(20) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

/*Data for the table `submit_comprehensive` */

insert  into `submit_comprehensive`(`id`,`name`,`periods`,`compilation_date`,`status`,`range`,`statistics`,`user_account`,`dept_id`,`create_time`,`update_time`,`document`,`proc_inst_id`,`proc_start_time`,`proc_end_time`,`proc_startor`,`proc_state`,`proc_task_handler`,`isfinalized`,`corp_id`,`subordinate_unit_ids`,`tenant_info_id`) values (1,'098765432','1','2019-01-02','auditing','总经理助理,工会主席','贵州电网有限责任公司（1篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1546408122497,1546408153798,'a0ab5dbe75024a148984963893ecf337','1680d1ba8989e2f09c3f58a48b9978ce',1546408140000,NULL,'chengwei_01@csg.cn','信息秘书审批','zhengzhiquan_01@csg.cn',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11'),(2,'098765432','2','2019-01-02','auditing','总经理助理,工会主席','贵州电网有限责任公司（1篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1546408155311,1546408162604,'a0ab5dbe75024a148984963893ecf337','1680d1bdd7c14bf88fcd02f410aadb4e',1546408140000,NULL,'chengwei_01@csg.cn','信息秘书审批','zhengzhiquan_01@csg.cn',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11'),(3,'周四1','3','2019-01-03','notify','总工程师,总经理助理','','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1546478295557,1546478513597,'3ed606c31a674548a7e6f8796f02f837','168114a20f40c63b562f9fb4701ad26f',1546478280000,1546478512724,'chengwei_01@csg.cn','流程结束','','0','c29cd3da9458461191b5b2d5e8417346','','11'),(4,'33333333333333','4','2019-01-03','auditing','总法律顾问,总工程师,总经理助理','贵州电网有限责任公司（1篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1546480505266,1546480514502,'916fdf66993d4a349ee212fd613c0066','168116bdc100b64ed0b05764629b4d4b',1546480500000,NULL,'chengwei_01@csg.cn','信息秘书审批','zhengzhiquan_01@csg.cn',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11'),(5,'44444444444444','5','2019-01-03','auditing','总法律顾问,工会主席,总工程师,总信息师','贵州电网有限责任公司（1篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1546480543593,1546480551952,'b5576f2cbc104ea880fa5b6fd6ab1602','168116c6eedc20a16eada5e4c1694e7d',1546480500000,NULL,'chengwei_01@csg.cn','信息秘书审批','zhengzhiquan_01@csg.cn',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11'),(6,'20190110test','6','2019-01-10','notify','公司领导','','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1547109805716,1547110213576,'ad3910ccd1f2489e9b6abd4e29973cf1','16836ee327928dc68801e5e4f1b997cb',1547109780000,1547110212730,'chengwei_01@csg.cn','流程结束','','0','c29cd3da9458461191b5b2d5e8417346','','11'),(7,'期刊测试','7','2019-01-10','notify','公司领导','','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1547114707842,1547114997985,'9d5936dfe9b640ddba075892258bf9a0','1683738ff370512e6d38f284ef2a06b9',1547114700000,1547114997109,'chengwei_01@csg.cn','流程结束','','0','c29cd3da9458461191b5b2d5e8417346','','11'),(8,'test','8','2019-01-10','notify','公司领导','','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1547118821820,1547119421702,'77fd6cd3ccd94f4a971f0f9f0c572348','1683777c57cffb59e48b22a44529d803',1547118780000,1547119420988,'chengwei_01@csg.cn','流程结束','','0','c29cd3da9458461191b5b2d5e8417346','','11'),(9,'test1','9','2019-01-10','notify','总法律顾问','','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1547120225428,1547120312850,'74b5c496af364d48adefeae6fe6e3ae7','168378d30651941fa0ecf2f40668600e',1547120220000,1547120312413,'chengwei_01@csg.cn','流程结束','','0','c29cd3da9458461191b5b2d5e8417346','','11'),(10,'test1','1','2019-01-11','notify','\"总信息师\"','','xuqp@gz.csg.cn','9B3A2D8A4EC84F7CB41BFABF60C24856',1547171088063,1547171972063,'4050c644296c4aae9dcf08fe9eee31de','1683a954a9f0317cfa600554855b142d',1547171040000,1547171971889,'xuqp@gz.csg.cn','流程结束','','0','7e364e743cd04334966b829bd2dd30c2','','6'),(11,'test3','2','2019-01-11','notify','\"总工程师\"','','xuqp@gz.csg.cn','9B3A2D8A4EC84F7CB41BFABF60C24856',1547175119398,1547175947737,'cb0371ef444245eb8c127a9072d90ca4','1683ad2ce5b9cf5c4399d614c63aa847',1547175120000,1547175947589,'xuqp@gz.csg.cn','流程结束','','0','7e364e743cd04334966b829bd2dd30c2','','6'),(12,'测试234','10','2019-01-13','auditing','公司领导,工会主席','贵州电网有限责任公司（2篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1547359860659,1547359866249,'be0d119e9cc94564bb8059f4f19dd44b','16845d5bd4963085cb4ecd346d886b55',1547359860000,NULL,'chengwei_01@csg.cn','信息秘书审批','zhengzhiquan_01@csg.cn',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11'),(51,'测试corpId','11','2019-01-21','auditing','公司领导,总部各部门主任及副主任','贵州电网有限责任公司（2篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1548058297746,1548058302257,'79eefa8d5c1d447c93898225eb8ec026','1686f7707f2307138bc22304d01bb29a',1548058302257,NULL,'chengwei_01@csg.cn',NULL,'lifulai_01@csg.cn',NULL,'c29cd3da9458461191b5b2d5e8417346',NULL,'11'),(52,'opo','12','2019-01-21','notify','\"公司领导,总法律顾问\"','','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1548059011770,1548059161739,'47c893a67fcd477bb7edf0f7caf4d8d9','1686f81ef31046c7bd2d8664046a3bce',1548059016170,1548059160876,'chengwei_01@csg.cn','同意发布','','0','c29cd3da9458461191b5b2d5e8417346','','11'),(53,'测试总部和子公司','13','2019-01-21','Draft','公司领导,总部各部门,所属各单位负责人','贵州电网有限责任公司（2篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1548059148701,1548059369420,'213bb1c3207e4d68ad1ce0a3ff75b14b','1686f8405ef297a08e5e685439480deb',1548059153381,1548059289986,'chengwei_01@csg.cn','同意发布','','0','c29cd3da9458461191b5b2d5e8417346','shisj@gzyj.csg.cn,zhangqi0121@gz.csg.cn,chenwk@gzyj.csg.cn,yuanling@gz.csg.cn,zengsuiying,liangzheng0127@gzps.corp.csg,wangm3@hn.csg.cn,dengjingjing@gx.csg.cn,menge009x@nng.gx.csg.cn,liushuixin@sz.corp.csg,linxiaoshen@gsbb.gd.csg.cn,heguowei.st','11'),(54,'测试流程不断审批','14','2019-01-21','notify','公司领导,总部各部门,所属各单位负责人','贵州电网有限责任公司（2篇）','chengwei_01@csg.cn','43ccfde89ff949809d2854cda8d22053',1548059466041,1548059542822,'ee8bafaaad24441e9ed77422f25103d4','1686f88dd23767270427dc54ad38477e',1548059475310,1548059542504,'chengwei_01@csg.cn','同意发布','','0','c29cd3da9458461191b5b2d5e8417346','shisj@gzyj.csg.cn,zhangqi0121@gz.csg.cn,chenwk@gzyj.csg.cn,yuanling@gz.csg.cn,zengsuiying,liangzheng0127@gzps.corp.csg,wangm3@hn.csg.cn,dengjingjing@gx.csg.cn,menge009x@nng.gx.csg.cn,liushuixin@sz.corp.csg,linxiaoshen@gsbb.gd.csg.cn,heguowei.st','11'),(55,'热热热','1','2019-01-21','notify','总法律顾问,公司领导','','zhaiyj@gzyj.csg.cn','E026D18A298C4FABBEB7A46DAC6D5CD4',1548069252947,1548069516439,'16687c5e42e04f82b8ffd84ba6b3133f','168701e3b1a90504a2c7d254f8cbc204',1548069259804,1548069515830,'zhaiyj@gzyj.csg.cn','同意发布','','0','99E0FB6933EF4DBA8E9B0B67407193E2','','6');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
