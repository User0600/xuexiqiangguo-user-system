/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 8.0.40 : Database - xuexiqiangguo
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`xuexiqiangguo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `xuexiqiangguo`;

/*Table structure for table `admin` */

DROP TABLE IF EXISTS `admin`;

CREATE TABLE `admin` (
  `id` double DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `admin_key` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `admin` */

insert  into `admin`(`id`,`username`,`password`,`phone`,`email`,`admin_key`,`avatar`) values 
(1,'管理员1','加密后的密码（如bcrypt或md5加密值）','13900139001','admin1@example.com','ADMIN_KEY_123456','https://example.com/avatars/admin1.jpg'),
(2,'admin_test','$2a$10$iXv2tD4z2W2FzqKv.3eKyeW7yU8RvF6Lx8Zt8Q5v0O0G8H7j6v6lO','13900001111','admin_test@example.com','ADMIN_KEY_20251112','https://joeschmoe.io/api/v1/random'),
(5,'李禹希','$2a$10$44pARVm.OQTAAKwZQ25/j.kYWV6ibU.kEZnm37bKUN8bj6vGDplC.','19160361209','3557587092@qq.com','8有8有用86868',NULL),
(NULL,'adk','$2a$10$65YSneBIZux9B1nx.We5TelgEjaz5IAHh9lhjQ/BPqqF5UQAJjfc.','13988889999','aop@test.com','Y',NULL),
(NULL,'ak','$2a$10$mn9CjjoRqL3M7euBcBnq0.eB.eE01TDg9WAhfymCZFwjvh9BnAloq','13978789999','adwwin@tst.com','Y',NULL);

/*Table structure for table `month_evaluation` */

DROP TABLE IF EXISTS `month_evaluation`;

CREATE TABLE `month_evaluation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `month_str` varchar(20) NOT NULL COMMENT '月份，如 2023-12',
  `total_score` int DEFAULT '0' COMMENT '本月总分',
  `rank_level` varchar(10) DEFAULT NULL COMMENT '评级: A/B/C',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_month` (`user_id`,`month_str`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='月度考核统计表';

/*Data for the table `month_evaluation` */

/*Table structure for table `question_bank` */

DROP TABLE IF EXISTS `question_bank`;

CREATE TABLE `question_bank` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `content` text NOT NULL COMMENT '题目题干内容',
  `type` int NOT NULL DEFAULT '1' COMMENT '题目类型: 1-单选, 2-多选',
  `category` int NOT NULL DEFAULT '1' COMMENT '分类: 1-时事, 2-专业, 3-政治',
  `options` json DEFAULT NULL COMMENT '选项内容(JSON格式)',
  `correct_answer` varchar(255) NOT NULL COMMENT '正确答案，如 "A" 或 "AB"',
  `analysis` varchar(1000) DEFAULT NULL COMMENT '题目解析(答案详解)',
  `creator_id` bigint DEFAULT NULL COMMENT '提交人ID(关联用户表)',
  `creator_name` varchar(50) DEFAULT NULL COMMENT '提交人姓名(冗余字段避免连表)',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态: 0-待审核, 1-已入库, 2-驳回',
  `is_deleted` int DEFAULT '0' COMMENT '逻辑删除: 0-未删, 1-已删',
  KEY `id` (`id`),
  KEY `idx_category_status` (`category`,`status`) COMMENT '加速选题查询'
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `question_bank` */

insert  into `question_bank`(`id`,`content`,`type`,`category`,`options`,`correct_answer`,`analysis`,`creator_id`,`creator_name`,`status`,`is_deleted`) values 
(1,'2025年12月3日，我国信息通信领域首个国家重大科技基础设施正式投运，其名称是什么？',1,1,'[{\"text\": \"“中国天眼”\", \"label\": \"A\"}, {\"text\": \"未来网络试验设施\", \"label\": \"B\"}, {\"text\": \"东数西算工程\", \"label\": \"C\"}, {\"text\": \"国家超算中心\", \"label\": \"D\"}]','B','我国信息通信领域首个国家重大科技基础设施“未来网络试验设施”于2025年12月3日通过国家验收，正式投入运行[citation:2]。',1,'Admin',1,0),
(2,'未来网络试验设施在演示试验中，将72TB的天文数据从贵州传至湖北，耗时大约多久？',1,1,'[{\"text\": \"699天\", \"label\": \"A\"}, {\"text\": \"1.6小时\", \"label\": \"B\"}, {\"text\": \"16小时\", \"label\": \"C\"}, {\"text\": \"50天\", \"label\": \"D\"}]','B','该设施进行了一次数据迁移试验，将72TB数据从贵州师范大学分中心传至华中科技大学，仅用了约1.6小时。若用传统互联网传输，则需要699天[citation:2]。',1,'Admin',1,0),
(3,'2025年12月4日，在“2025中国国际海事会展”上亮相的全国首台造船迷你机械臂，其主要功能是什么？',1,1,'[{\"text\": \"深海探测\", \"label\": \"A\"}, {\"text\": \"灵巧焊接\", \"label\": \"B\"}, {\"text\": \"船体喷漆\", \"label\": \"C\"}, {\"text\": \"货物搬运\", \"label\": \"D\"}]','B','全国首台造船迷你机械臂亮相，其看似在“跳舞”，实则是为了向观众展示它灵巧的焊接技术[citation:4]。',1,'Admin',1,0),
(4,'我国西湖大学智能无人系统实验室在全球首次攻克了哪项无人机技术难题？',1,1,'[{\"text\": \"超长续航\", \"label\": \"A\"}, {\"text\": \"无人机组网\", \"label\": \"B\"}, {\"text\": \"两架无人机近距离叠飞\", \"label\": \"C\"}, {\"text\": \"水下起降\", \"label\": \"D\"}]','C','西湖大学智能无人系统实验室的一项科研成果在全球首次攻克了两架无人机近距离叠飞的难题[citation:4]。',1,'Admin',1,0),
(5,'我国单机容量最大的燃气电厂——国家能源集团浙江安吉电厂1号机组于何时正式投产？',1,1,'[{\"text\": \"2025年11月25日\", \"label\": \"A\"}, {\"text\": \"2025年11月30日\", \"label\": \"B\"}, {\"text\": \"2025年12月1日\", \"label\": \"C\"}, {\"text\": \"2025年12月5日\", \"label\": \"D\"}]','B','我国单机容量最大的燃气电厂——国家能源集团浙江安吉电厂1号机组于11月30日20点完成168小时满负荷试运行，正式投产[citation:4]。',1,'Admin',1,0),
(6,'我国首个得到船级社注册认证、正式交付的海上火箭回收平台被命名为什么？',1,1,'[{\"text\": \"开拓者\", \"label\": \"A\"}, {\"text\": \"领航者\", \"label\": \"B\"}, {\"text\": \"探索者\", \"label\": \"C\"}, {\"text\": \"复兴号\", \"label\": \"D\"}]','B','我国首个火箭网系回收海上平台“领航者”于11月30日成功交付[citation:4]。',1,'Admin',1,0),
(7,'2025年12月2日，中共中央政治局委员、中央外办主任王毅在莫斯科同俄罗斯联邦安全会议秘书绍伊古共同主持了什么磋商？',1,1,'[{\"text\": \"中俄经贸合作磋商\", \"label\": \"A\"}, {\"text\": \"中俄第二十轮战略安全磋商\", \"label\": \"B\"}, {\"text\": \"中俄能源对话\", \"label\": \"C\"}, {\"text\": \"中俄人文交流磋商\", \"label\": \"D\"}]','B','当地时间2025年12月2日，王毅在莫斯科同绍伊古共同主持中俄第二十轮战略安全磋商[citation:1]。',1,'Admin',1,0),
(8,'根据商务部2025年12月4日发布的数据，2025年1至10月，中法贸易额约为多少？',1,1,'[{\"text\": \"约500亿美元\", \"label\": \"A\"}, {\"text\": \"约587.5亿美元\", \"label\": \"B\"}, {\"text\": \"约687.5亿美元\", \"label\": \"C\"}, {\"text\": \"约787.5亿美元\", \"label\": \"D\"}]','C','商务部12月4日发布数据显示，2025年1至10月，中法贸易额达687.5亿美元，同比增长4.1%[citation:10]。',1,'Admin',1,0),
(9,'刷新全球最长单程航线纪录、于2025年12月4日正式通航的航班，其起点和终点分别是？',1,1,'[{\"text\": \"北京—悉尼\", \"label\": \"A\"}, {\"text\": \"上海—奥克兰—布宜诺斯艾利斯\", \"label\": \"B\"}, {\"text\": \"广州—洛杉矶\", \"label\": \"C\"}, {\"text\": \"深圳—伦敦\", \"label\": \"D\"}]','B','12月4日，中国东航MU745航班从上海浦东国际机场起飞，经奥克兰最终到达阿根廷布宜诺斯艾利斯，刷新全球最长单程航线纪录[citation:10]。',1,'Admin',1,0),
(10,'2025年12月6日，将在苏州奥体中心举行的商业性赛事是什么？',1,1,'[{\"text\": \"中国乒乓球俱乐部超级联赛总决赛\", \"label\": \"A\"}, {\"text\": \"足协杯决赛\", \"label\": \"B\"}, {\"text\": \"全国国防体育运动锦标赛\", \"label\": \"C\"}, {\"text\": \"武博汇总决赛\", \"label\": \"D\"}]','B','根据江苏省体育局发布的清单，2025足协杯决赛将于12月6日在苏州奥体中心举行[citation:3]。',1,'Admin',1,0),
(11,'2025年12月，在青海多巴国家高原体育训练基地将先后举办哪两项国家级冰壶赛事？',2,1,'[{\"text\": \"2025—2026赛季中国冰壶联赛第三站\", \"label\": \"A\"}, {\"text\": \"2025年世界冰壶锦标赛\", \"label\": \"B\"}, {\"text\": \"2025—2026赛季中国冰壶联赛总决赛\", \"label\": \"C\"}, {\"text\": \"2025年全国青少年冰壶锦标赛\", \"label\": \"D\"}]','AC','2025—2026赛季中国冰壶联赛第三站（12月3日至11日）和总决赛（12月14日至24日）都将在青海多巴国家高原体育训练基地举办[citation:7]。',1,'Admin',1,0),
(12,'2025年12月6日至7日，以“圣地西藏 户外天堂”为主题，在林芝市朗县举办的民族特色赛事是什么？',1,1,'[{\"text\": \"藏族赛马节\", \"label\": \"A\"}, {\"text\": \"西藏自治区第十届林芝响箭比赛\", \"label\": \"B\"}, {\"text\": \"藏族摔跤大赛\", \"label\": \"C\"}, {\"text\": \"青藏高原徒步大会\", \"label\": \"D\"}]','B','2025箭舞中华·全民健身主题活动暨西藏自治区第十届林芝响箭比赛将于2025年12月6—7日在林芝市朗县举办[citation:9]。',1,'Admin',1,0),
(13,'2025年12月4日至5日，在海南博鳌召开的以“AI赋能·智领新质”为主题的大会名称是什么？',1,1,'[{\"text\": \"世界人工智能大会\", \"label\": \"A\"}, {\"text\": \"2025数智科技创新发展大会\", \"label\": \"B\"}, {\"text\": \"中国人工智能产业年会\", \"label\": \"C\"}, {\"text\": \"博鳌亚洲论坛全球科技论坛\", \"label\": \"D\"}]','B','以“AI赋能·智领新质”为主题的2025数智科技创新发展大会于12月4日在海南博鳌召开[citation:6]。',1,'Admin',1,0),
(14,'未来网络试验设施将为我国哪项重大工程的建设探路，并发挥重要作用？',1,1,'[{\"text\": \"南水北调\", \"label\": \"A\"}, {\"text\": \"西电东送\", \"label\": \"B\"}, {\"text\": \"东数西算\", \"label\": \"C\"}, {\"text\": \"高速铁路网\", \"label\": \"D\"}]','C','中国工程院院士刘韵洁表示，未来网络试验设施最重要的应用方向之一就是“东数西算”工程[citation:2]。',1,'Admin',1,0),
(15,'广西壮族自治区体育局发布的2025年四季度赛事清单中，下列哪项是于12月4日至8日在北海市举办的国际级赛事？',1,1,'[{\"text\": \"“一带一路”国际帆船赛\", \"label\": \"A\"}, {\"text\": \"中国—东盟（崇左）垂钓大赛\", \"label\": \"B\"}, {\"text\": \"南宁马拉松比赛\", \"label\": \"C\"}, {\"text\": \"广西龙狮公开赛\", \"label\": \"D\"}]','A','根据广西发布的清单，2025“一带一路”国际帆船赛为国际级赛事，于12月4日至8日在北海市银海区举办[citation:5]。',1,'Admin',1,0),
(16,'根据日本庆应义塾大学名誉教授大西广的观点，日本首相高市早苗上月发表的涉台言论是对历史的什么？',1,1,'[{\"text\": \"尊重\", \"label\": \"A\"}, {\"text\": \"歪曲\", \"label\": \"B\"}, {\"text\": \"客观陈述\", \"label\": \"C\"}, {\"text\": \"发展\", \"label\": \"D\"}]','B','日本庆应义塾大学名誉教授大西广表示，日本首相高市早苗妄图煽炒所谓“台湾地位未定论”是对历史的歪曲[citation:1]。',1,'Admin',1,0),
(17,'未来网络试验设施在赋能AI大模型训练方面，能发挥什么关键作用？',2,1,'[{\"text\": \"提供更强大的独立算力芯片\", \"label\": \"A\"}, {\"text\": \"提供大带宽、高通量的网络环境\", \"label\": \"B\"}, {\"text\": \"聚合全网算力，破解“少、杂、散”难题\", \"label\": \"C\"}, {\"text\": \"显著缩短跨域训练所需时间\", \"label\": \"D\"}]','BCD','未来网络试验设施能够为AI大模型训练提供必需的大带宽、高通量网络环境[citation:2]；可聚合全网算力，破解高端算力“少、杂、散”难题[citation:2]；使用其确定性网络能力可大幅缩短大模型训练时间[citation:2]。',1,'Admin',1,0),
(18,'2025年12月2日，西藏那曲市比如县发生了何种等级的地震？',1,1,'[{\"text\": \"3.5级\", \"label\": \"A\"}, {\"text\": \"4.9级\", \"label\": \"B\"}, {\"text\": \"5.5级\", \"label\": \"C\"}, {\"text\": \"6.0级\", \"label\": \"D\"}]','B','12月2日18时56分，在西藏那曲市比如县发生4.9级地震，震源深度10公里[citation:1]。',1,'Admin',1,0),
(19,'我国研制的全国首台造船迷你机械臂，其重量不到多少公斤？',1,1,'[{\"text\": \"5公斤\", \"label\": \"A\"}, {\"text\": \"10公斤\", \"label\": \"B\"}, {\"text\": \"15公斤\", \"label\": \"C\"}, {\"text\": \"20公斤\", \"label\": \"D\"}]','C','全国首台造船迷你机械臂重量不到15公斤，可以与工人配合，在人无法到达的地方进行焊接作业[citation:4]。',1,'Admin',1,0),
(20,'2025年12月，西宁市体育局推出的多元体育活动包含以下哪些内容？',2,1,'[{\"text\": \"2025—2026赛季中国冰壶联赛\", \"label\": \"A\"}, {\"text\": \"2025年全国青年女子手球锦标赛\", \"label\": \"B\"}, {\"text\": \"西宁市青少年燃冬冰雪健身季\", \"label\": \"C\"}, {\"text\": \"兰西城市群乒乓球邀请赛\", \"label\": \"D\"}]','ABCD','根据西宁市体育局信息，12月西宁将举办中国冰壶联赛[citation:7]、全国青年女子手球锦标赛[citation:7]，开展青少年燃冬冰雪健身季[citation:7]，并举办兰西城市群乒乓球邀请赛[citation:7]。',1,'Admin',1,0),
(21,'Java语言的创始人是？',1,2,'[{\"text\": \"比尔·盖茨\", \"label\": \"A\"}, {\"text\": \"詹姆斯·高斯林\", \"label\": \"B\"}, {\"text\": \"史蒂夫·乔布斯\", \"label\": \"C\"}, {\"text\": \"林纳斯·托瓦兹\", \"label\": \"D\"}]','B','James Gosling 被称为 Java 之父。',1,'Admin',1,0),
(22,'在Java中，用于打印输出到控制台的语句是？',1,2,'[{\"text\": \"print()\", \"label\": \"A\"}, {\"text\": \"System.out.println()\", \"label\": \"B\"}, {\"text\": \"console.log()\", \"label\": \"C\"}, {\"text\": \"echo\", \"label\": \"D\"}]','B','System.out.println() 是标准输出。',1,'Admin',1,0),
(23,'下列哪些是面向对象编程的三大特征？',2,2,'[{\"text\": \"封装\", \"label\": \"A\"}, {\"text\": \"继承\", \"label\": \"B\"}, {\"text\": \"多态\", \"label\": \"C\"}, {\"text\": \"编译\", \"label\": \"D\"}]','ABC','面向对象三大特征：封装、继承、多态。',1,'Admin',1,0),
(24,'SQL语言中，用于查询数据的命令是？',1,2,'[{\"text\": \"UPDATE\", \"label\": \"A\"}, {\"text\": \"DELETE\", \"label\": \"B\"}, {\"text\": \"SELECT\", \"label\": \"C\"}, {\"text\": \"INSERT\", \"label\": \"D\"}]','C','SELECT用于查询。',1,'Admin',1,0),
(25,'HTTP协议默认使用的端口号是？',1,2,'[{\"text\": \"21\", \"label\": \"A\"}, {\"text\": \"80\", \"label\": \"B\"}, {\"text\": \"443\", \"label\": \"C\"}, {\"text\": \"8080\", \"label\": \"D\"}]','B','HTTP默认80，HTTPS默认443。',1,'Admin',1,0),
(26,'在Excel中，求和的函数是？',1,2,'[{\"text\": \"AVG\", \"label\": \"A\"}, {\"text\": \"SUM\", \"label\": \"B\"}, {\"text\": \"COUNT\", \"label\": \"C\"}, {\"text\": \"MAX\", \"label\": \"D\"}]','B','SUM是求和函数。',1,'Admin',1,0),
(27,'下列属于计算机操作系统的是？',2,2,'[{\"text\": \"Windows\", \"label\": \"A\"}, {\"text\": \"Linux\", \"label\": \"B\"}, {\"text\": \"macOS\", \"label\": \"C\"}, {\"text\": \"Office\", \"label\": \"D\"}]','ABC','Office是应用软件，不是操作系统。',1,'Admin',1,0),
(28,'Spring Boot的核心注解是？',1,2,'[{\"text\": \"@Controller\", \"label\": \"A\"}, {\"text\": \"@SpringBootApplication\", \"label\": \"B\"}, {\"text\": \"@Service\", \"label\": \"C\"}, {\"text\": \"@Autowired\", \"label\": \"D\"}]','B','@SpringBootApplication是启动类核心注解。',1,'Admin',1,0),
(29,'Vue.js 是一个用于构建用户界面的什么框架？',1,2,'[{\"text\": \"后端框架\", \"label\": \"A\"}, {\"text\": \"JavaScript框架\", \"label\": \"B\"}, {\"text\": \"数据库框架\", \"label\": \"C\"}, {\"text\": \"测试框架\", \"label\": \"D\"}]','B','Vue.js 是渐进式 JavaScript 框架。',1,'Admin',1,0),
(30,'数据库事务的ACID特性包括？',2,2,'[{\"text\": \"原子性\", \"label\": \"A\"}, {\"text\": \"一致性\", \"label\": \"B\"}, {\"text\": \"隔离性\", \"label\": \"C\"}, {\"text\": \"持久性\", \"label\": \"D\"}]','ABCD','ACID包含原子性、一致性、隔离性、持久性。',1,'Admin',1,0),
(31,'在Java中，int类型占用的字节数是？',1,2,'[{\"text\": \"2\", \"label\": \"A\"}, {\"text\": \"4\", \"label\": \"B\"}, {\"text\": \"8\", \"label\": \"C\"}, {\"text\": \"16\", \"label\": \"D\"}]','B','int占4个字节，32位。',1,'Admin',1,0),
(32,'Git是一个什么工具？',1,2,'[{\"text\": \"编辑器\", \"label\": \"A\"}, {\"text\": \"版本控制系统\", \"label\": \"B\"}, {\"text\": \"编译器\", \"label\": \"C\"}, {\"text\": \"杀毒软件\", \"label\": \"D\"}]','B','Git是分布式版本控制系统。',1,'Admin',1,0),
(33,'MyBatis-Plus中，用于逻辑删除的默认字段值是？',1,2,'[{\"text\": \"0\", \"label\": \"A\"}, {\"text\": \"1\", \"label\": \"B\"}, {\"text\": \"-1\", \"label\": \"C\"}, {\"text\": \"null\", \"label\": \"D\"}]','B','通常配置中，1表示已删除，0表示未删除。',1,'Admin',1,0),
(34,'下列哪些属于办公软件Office系列？',2,2,'[{\"text\": \"Word\", \"label\": \"A\"}, {\"text\": \"Excel\", \"label\": \"B\"}, {\"text\": \"PowerPoint\", \"label\": \"C\"}, {\"text\": \"Photoshop\", \"label\": \"D\"}]','ABC','Photoshop是Adobe公司的产品。',1,'Admin',1,0),
(35,'在HTML中，用于创建超链接的标签是？',1,2,'[{\"text\": \"<img>\", \"label\": \"A\"}, {\"text\": \"<a>\", \"label\": \"B\"}, {\"text\": \"<div>\", \"label\": \"C\"}, {\"text\": \"<link>\", \"label\": \"D\"}]','B','<a>标签用于定义超链接。',1,'Admin',1,0),
(36,'JSON的全称是？',1,2,'[{\"text\": \"Java Standard Object\", \"label\": \"A\"}, {\"text\": \"JavaScript Object Notation\", \"label\": \"B\"}, {\"text\": \"Java Source Open\", \"label\": \"C\"}, {\"text\": \"JavaScript Option Node\", \"label\": \"D\"}]','B','JavaScript Object Notation。',1,'Admin',1,0),
(37,'Redis 是一种什么类型的数据库？',1,2,'[{\"text\": \"关系型数据库\", \"label\": \"A\"}, {\"text\": \"键值对NoSQL数据库\", \"label\": \"B\"}, {\"text\": \"图形数据库\", \"label\": \"C\"}, {\"text\": \"文档数据库\", \"label\": \"D\"}]','B','Redis是基于键值对的NoSQL数据库。',1,'Admin',1,0),
(38,'软件开发生命周期(SDLC)包含哪些阶段？',2,2,'[{\"text\": \"需求分析\", \"label\": \"A\"}, {\"text\": \"设计\", \"label\": \"B\"}, {\"text\": \"编码\", \"label\": \"C\"}, {\"text\": \"测试\", \"label\": \"D\"}]','ABCD','包含需求、设计、开发、测试、部署、维护等。',1,'Admin',1,0),
(39,'IP地址 127.0.0.1 通常代表？',1,2,'[{\"text\": \"局域网网关\", \"label\": \"A\"}, {\"text\": \"本地回环地址(localhost)\", \"label\": \"B\"}, {\"text\": \"广域网地址\", \"label\": \"C\"}, {\"text\": \"广播地址\", \"label\": \"D\"}]','B','localhost / 本地回环。',1,'Admin',1,0),
(40,'在CSS中，用于设置字体颜色的属性是？',1,2,'[{\"text\": \"font-size\", \"label\": \"A\"}, {\"text\": \"background\", \"label\": \"B\"}, {\"text\": \"color\", \"label\": \"C\"}, {\"text\": \"text-align\", \"label\": \"D\"}]','C','color属性用于设置文本颜色。',1,'Admin',1,0),
(41,'中国共产党成立的时间是？',1,3,'[{\"text\": \"1919年\", \"label\": \"A\"}, {\"text\": \"1921年\", \"label\": \"B\"}, {\"text\": \"1927年\", \"label\": \"C\"}, {\"text\": \"1949年\", \"label\": \"D\"}]','B','1921年7月中国共产党成立。',1,'Admin',1,0),
(42,'中国共产党的根本宗旨是？',1,3,'[{\"text\": \"全心全意为人民服务\", \"label\": \"A\"}, {\"text\": \"实现共产主义\", \"label\": \"B\"}, {\"text\": \"发展生产力\", \"label\": \"C\"}, {\"text\": \"依法治国\", \"label\": \"D\"}]','A','全心全意为人民服务是党的根本宗旨。',1,'Admin',1,0),
(43,'社会主义核心价值观中，国家层面的价值目标是？',2,3,'[{\"text\": \"富强\", \"label\": \"A\"}, {\"text\": \"民主\", \"label\": \"B\"}, {\"text\": \"文明\", \"label\": \"C\"}, {\"text\": \"和谐\", \"label\": \"D\"}]','ABCD','富强、民主、文明、和谐是国家层面的价值目标。',1,'Admin',2,0),
(44,'习近平新时代中国特色社会主义思想的核心要义是？',1,3,'[{\"text\": \"坚持和发展中国特色社会主义\", \"label\": \"A\"}, {\"text\": \"实现现代化\", \"label\": \"B\"}, {\"text\": \"全面从严治党\", \"label\": \"C\"}, {\"text\": \"经济高速增长\", \"label\": \"D\"}]','A','坚持和发展中国特色社会主义是核心要义。',1,'Admin',1,0),
(45,'中国共产党的最高理想和最终目标是？',1,3,'[{\"text\": \"实现小康社会\", \"label\": \"A\"}, {\"text\": \"实现共产主义\", \"label\": \"B\"}, {\"text\": \"实现社会主义现代化\", \"label\": \"C\"}, {\"text\": \"实现民族复兴\", \"label\": \"D\"}]','B','最高理想是实现共产主义。',1,'Admin',1,0),
(46,'党的二十大报告指出，中国式现代化的本质要求包括？',2,3,'[{\"text\": \"坚持中国共产党领导\", \"label\": \"A\"}, {\"text\": \"坚持中国特色社会主义\", \"label\": \"B\"}, {\"text\": \"实现高质量发展\", \"label\": \"C\"}, {\"text\": \"发展全过程人民民主\", \"label\": \"D\"}]','ABCD','这些都是中国式现代化的本质要求。',1,'Admin',1,0),
(47,'我国的根本政治制度是？',1,3,'[{\"text\": \"政治协商制度\", \"label\": \"A\"}, {\"text\": \"人民代表大会制度\", \"label\": \"B\"}, {\"text\": \"民族区域自治制度\", \"label\": \"C\"}, {\"text\": \"基层群众自治制度\", \"label\": \"D\"}]','B','人民代表大会制度是根本政治制度。',1,'Admin',1,0),
(48,'“四个自信”是指：道路自信、理论自信、制度自信和？',1,3,'[{\"text\": \"政治自信\", \"label\": \"A\"}, {\"text\": \"经济自信\", \"label\": \"B\"}, {\"text\": \"文化自信\", \"label\": \"C\"}, {\"text\": \"军事自信\", \"label\": \"D\"}]','C','第四个是文化自信。',1,'Admin',1,0),
(49,'中国共产党人的初心和使命是？',2,3,'[{\"text\": \"为中国人民谋幸福\", \"label\": \"A\"}, {\"text\": \"为中华民族谋复兴\", \"label\": \"B\"}, {\"text\": \"为世界谋大同\", \"label\": \"C\"}, {\"text\": \"为国家谋霸权\", \"label\": \"D\"}]','AB','初心和使命是为中国人民谋幸福，为中华民族谋复兴。',1,'Admin',1,0),
(50,'党章规定，党员必须履行的义务有几条？',1,3,'[{\"text\": \"六条\", \"label\": \"A\"}, {\"text\": \"七条\", \"label\": \"B\"}, {\"text\": \"八条\", \"label\": \"C\"}, {\"text\": \"九条\", \"label\": \"D\"}]','C','党章规定党员义务共八条。',1,'Admin',1,0),
(51,'全面建设社会主义现代化国家的首要任务是？',1,3,'[{\"text\": \"高质量发展\", \"label\": \"A\"}, {\"text\": \"高速度增长\", \"label\": \"B\"}, {\"text\": \"共同富裕\", \"label\": \"C\"}, {\"text\": \"生态文明建设\", \"label\": \"D\"}]','A','高质量发展是首要任务。',1,'Admin',1,0),
(52,'下列属于“四个全面”战略布局的是？',2,3,'[{\"text\": \"全面建设社会主义现代化国家\", \"label\": \"A\"}, {\"text\": \"全面深化改革\", \"label\": \"B\"}, {\"text\": \"全面依法治国\", \"label\": \"C\"}, {\"text\": \"全面从严治党\", \"label\": \"D\"}]','ABCD','四个全面战略布局。',1,'Admin',1,0),
(53,'党的最高领导机关是？',1,3,'[{\"text\": \"中央政治局\", \"label\": \"A\"}, {\"text\": \"党的全国代表大会和它所产生的中央委员会\", \"label\": \"B\"}, {\"text\": \"中央书记处\", \"label\": \"C\"}, {\"text\": \"总书记\", \"label\": \"D\"}]','B','党的全国代表大会和它所产生的中央委员会。',1,'Admin',1,0),
(54,'中国共产党党徽为____和____组成的图案。',1,3,'[{\"text\": \"镰刀；斧头\", \"label\": \"A\"}, {\"text\": \"镰刀；锤头\", \"label\": \"B\"}, {\"text\": \"麦穗；齿轮\", \"label\": \"C\"}, {\"text\": \"五星；火炬\", \"label\": \"D\"}]','B','党徽是镰刀和锤头。',1,'Admin',1,0),
(55,'发展党员，必须把____放在首位。',1,3,'[{\"text\": \"业务能力\", \"label\": \"A\"}, {\"text\": \"政治标准\", \"label\": \"B\"}, {\"text\": \"工作业绩\", \"label\": \"C\"}, {\"text\": \"群众关系\", \"label\": \"D\"}]','B','必须把政治标准放在首位。',1,'Admin',1,0),
(56,'两步走战略安排中，到2035年要基本实现？',1,3,'[{\"text\": \"全面小康\", \"label\": \"A\"}, {\"text\": \"社会主义现代化\", \"label\": \"B\"}, {\"text\": \"共产主义\", \"label\": \"C\"}, {\"text\": \"共同富裕\", \"label\": \"D\"}]','B','到2035年基本实现社会主义现代化。',1,'Admin',1,0),
(57,'党风廉政建设的核心问题是？',1,3,'[{\"text\": \"密切党同人民群众的血肉联系\", \"label\": \"A\"}, {\"text\": \"提高党员素质\", \"label\": \"B\"}, {\"text\": \"加强组织建设\", \"label\": \"C\"}, {\"text\": \"完善制度\", \"label\": \"D\"}]','A','党风问题、党同人民群众联系问题是关系党生死存亡的问题。',1,'Admin',1,0),
(58,'下列哪次会议确立了毛泽东在党中央和红军的领导地位？',1,3,'[{\"text\": \"八七会议\", \"label\": \"A\"}, {\"text\": \"古田会议\", \"label\": \"B\"}, {\"text\": \"遵义会议\", \"label\": \"C\"}, {\"text\": \"瓦窑堡会议\", \"label\": \"D\"}]','C','遵义会议是党的历史上生死攸关的转折点。',1,'Admin',1,0),
(59,'党的纪律处分有几种？',1,3,'[{\"text\": \"3种\", \"label\": \"A\"}, {\"text\": \"4种\", \"label\": \"B\"}, {\"text\": \"5种\", \"label\": \"C\"}, {\"text\": \"6种\", \"label\": \"D\"}]','C','警告、严重警告、撤销党内职务、留党察看、开除党籍。',1,'Admin',1,0),
(60,'入党誓词中，“随时准备为党和人民牺牲一切”的下一句是？',1,3,'[{\"text\": \"永不叛党\", \"label\": \"A\"}, {\"text\": \"对党忠诚\", \"label\": \"B\"}, {\"text\": \"积极工作\", \"label\": \"C\"}, {\"text\": \"严守秘密\", \"label\": \"D\"}]','A','随时准备为党和人民牺牲一切，永不叛党。',1,'Admin',1,0);

/*Table structure for table `study_task` */

DROP TABLE IF EXISTS `study_task`;

CREATE TABLE `study_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '任务标题',
  `week_num` int NOT NULL COMMENT '周数，如 202348',
  `status` int DEFAULT '0' COMMENT '0-草稿, 1-已发布, 2-已结束',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='学习任务主表';

/*Data for the table `study_task` */

insert  into `study_task`(`id`,`title`,`week_num`,`status`,`create_time`) values 
(1,'2025年12月第一周',20251201,1,NULL);

/*Table structure for table `study_task_question` */

DROP TABLE IF EXISTS `study_task_question`;

CREATE TABLE `study_task_question` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint NOT NULL,
  `question_id` bigint NOT NULL,
  `category` int NOT NULL COMMENT '冗余字段: 1-时事, 2-专业, 3-政治',
  PRIMARY KEY (`id`),
  KEY `idx_task_cat` (`task_id`,`category`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务题目关联表';

/*Data for the table `study_task_question` */

insert  into `study_task_question`(`id`,`task_id`,`question_id`,`category`) values 
(1,2,15,1),
(2,2,10,1),
(3,2,12,1),
(4,2,19,1),
(5,2,7,1),
(6,2,40,2),
(7,2,33,2),
(8,2,27,2),
(9,2,30,2),
(10,2,26,2),
(11,2,44,3),
(12,2,59,3),
(13,2,41,3),
(14,2,56,3),
(15,2,48,3);

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL COMMENT '密码(建议存储加密后',
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL COMMENT '邮箱号',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户头像(存储图片路径',
  `admin_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user` */

insert  into `user`(`id`,`username`,`password`,`phone`,`email`,`avatar`,`admin_key`) values 
(1,'lqc','123456','15545612358','qqq@163.com',NULL,NULL),
(2,'wee','b2001728a472be831e70a8443079db06','15589455623','qwed@1009.com','/default-avatar.png',NULL),
(3,'qcq','a411074a28646ffeaf74aeb2b9b987a8','19985204563','opp@165.com','/default-avatar.png',NULL),
(4,'ter','$2a$10$5TbIvofFdqdin8G7UXsLM.zg68rnbiK4p6I3uJkeHblAGus.w26/q','15889895520','usr@test.com','/images/f9e4ac10-ed91-4f56-82bd-f54e3c521ea8.jpg',''),
(1000005,'yyr','$2a$10$UU2vXyAhGz/RBZfCRNuTi.0XRFX5CcjObD3YmDFMboA3AW.kYtikK','13807894562','uper@test.com','',''),
(1000006,'kkh','$2a$10$DeXrtHJoraHpiNRhV/uZYe7vjqEsi7ntLpTgCdkmBqB8YG.EmhLsq','19978785623','ukk@90.com','','');

/*Table structure for table `user_study_record` */

DROP TABLE IF EXISTS `user_study_record`;

CREATE TABLE `user_study_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `task_id` bigint NOT NULL,
  `score_news` int DEFAULT NULL COMMENT '时事模块得分',
  `score_pro` int DEFAULT NULL COMMENT '专业模块得分',
  `score_politics` int DEFAULT NULL COMMENT '政治模块得分',
  `total_score` int DEFAULT '0' COMMENT '总分(三个之和)',
  `status` int DEFAULT '0' COMMENT '0-进行中, 1-已完成(所有模块均已考完)',
  `finish_time` datetime DEFAULT NULL COMMENT '全部完成的时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_task` (`user_id`,`task_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户学习进度表';

/*Data for the table `user_study_record` */

insert  into `user_study_record`(`id`,`user_id`,`task_id`,`score_news`,`score_pro`,`score_politics`,`total_score`,`status`,`finish_time`,`create_time`) values 
(1,1,2,80,80,80,240,1,'2025-12-05 23:29:53',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
