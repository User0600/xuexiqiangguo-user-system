package org.example.new2.service; // ✅ 修正包路径

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.new2.dto.LoginDTO;
import org.example.new2.dto.RegisterDTO;
import org.example.new2.mapper.UserMapper; // 引入 Mapper
import org.example.new2.entity.*;
import org.example.new2.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

@Service
public class UserService implements IUserService {
    @Autowired
    private UserMapper userMapper; // 替换 Repository

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Transactional
    @Override
    public ResponseMessage<User> createUser(User user) {
        try {
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                return ResponseMessage.error("用户名不能为空");
            }
            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                return ResponseMessage.error("密码不能为空");
            }

            // 检查用户名是否存在
            LambdaQueryWrapper<User> query = new LambdaQueryWrapper<>();
            query.eq(User::getUsername, user.getUsername());
            if (userMapper.selectCount(query) > 0) {
                return ResponseMessage.error("用户名已存在");
            }

            user.setPassword(passwordEncoder.encode(user.getPassword()));

            if (user.getAvatar() == null || user.getAvatar().trim().isEmpty()) {
                user.setAvatar("https://api.dicebear.com/7.x/avataaars/svg?seed=" + user.getUsername());
            }
            if (user.getAdminKey() == null) {
                user.setAdminKey("N");
            }

            // MP 插入
            userMapper.insert(user);

            user.setPassword(null);
            return ResponseMessage.success(user);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseMessage.error("创建用户失败: " + e.getMessage());
        }
    }

    @Override
    public User findById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public ResponseMessage<User> register(RegisterDTO dto) {
        // 检查用户名
        if (userMapper.selectCount(new LambdaQueryWrapper<User>().eq(User::getUsername, dto.getUsername())) > 0) {
            return ResponseMessage.error("用户名已存在");
        }
        // 检查手机号
        if (userMapper.selectCount(new LambdaQueryWrapper<User>().eq(User::getPhone, dto.getPhone())) > 0) {
            return ResponseMessage.error("手机号已存在");
        }

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setAdminKey("");
        user.setAvatar(dto.getAvatar());

        userMapper.insert(user);
        return ResponseMessage.success(user);
    }

    @Override
    public ResponseMessage<String> login(LoginDTO dto) {
        // 查询用户
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, dto.getUsername()));

        if (user == null || !passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            return ResponseMessage.error("用户名或密码错误");
        }

        String token = jwtUtil.generateToken(user.getUsername(), "USER");
        return ResponseMessage.success(token);
    }

    @Override
    public ResponseMessage<IPage<User>> getUsers(String keyword, Integer page, Integer size) {
        // 构建分页对象
        Page<User> pageParam = new Page<>(page, size);

        // 构建查询条件
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            // WHERE (username LIKE %keyword% OR phone LIKE %keyword%)
            wrapper.and(w -> w.like(User::getUsername, keyword)
                    .or()
                    .like(User::getPhone, keyword));
        }

        // 执行查询
        IPage<User> userPage = userMapper.selectPage(pageParam, wrapper);
        return ResponseMessage.success(userPage);
    }

    @Override
    public ResponseMessage<User> getUserById(Long id) {
        User user = userMapper.selectById(id);
        if (user != null) {
            return ResponseMessage.success(user);
        }
        return ResponseMessage.error("用户不存在");
    }

    @Override
    @Transactional
    public ResponseMessage<User> editUser(User user) {
        if (userMapper.selectById(user.getId()) == null) {
            return ResponseMessage.error("用户不存在");
        }
        // MP 的 updateById 会根据 ID 更新非空字段
        userMapper.updateById(user);

        // 重新查询出来返回，或者直接返回入参
        return ResponseMessage.success(userMapper.selectById(user.getId()));
    }

    @Override
    @Transactional
    public ResponseMessage<Void> deleteUser(Long id) {
        if (userMapper.selectById(id) == null) {
            return ResponseMessage.error("用户不存在");
        }
        userMapper.deleteById(id);
        return ResponseMessage.success(null);
    }

    @Override
    public User findByUsername(String username) {
        return userMapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
    }
}