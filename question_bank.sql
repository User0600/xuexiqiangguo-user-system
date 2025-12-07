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
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
