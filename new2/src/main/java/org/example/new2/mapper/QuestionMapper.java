package org.example.new2.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.example.new2.entity.QuestionBank;

@Mapper
public interface QuestionMapper extends BaseMapper<QuestionBank> {
    // 继承 BaseMapper 后，自动拥有 CRUD 能力，无需手写 XML
}
