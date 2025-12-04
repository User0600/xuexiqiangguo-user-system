package org.example.new2.service; // ✅ 修正包路径

import org.example.new2.pojo.LoginDTO;
import org.example.new2.pojo.RegisterDTO;
import org.example.new2.pojo.ResponseMessage;
import org.example.new2.pojo.User;
import org.example.new2.repository.UserRepository;
import org.example.new2.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Optional;

@Service
public class UserService implements IUserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Transactional
    @Override
    public ResponseMessage<User> createUser(User user) {
        try {
            // 1. 数据校验
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                return ResponseMessage.error("用户名不能为空");
            }
            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                return ResponseMessage.error("密码不能为空");
            }

            // 2. 检查用户名是否已存在
            if (userRepository.findByUsername(user.getUsername()) != null) {
                return ResponseMessage.error("用户名已存在");
            }

            // 3. 密码加密（重要！）
            user.setPassword(passwordEncoder.encode(user.getPassword()));

            // 4. 设置默认值（如果前端没传）
            if (user.getAvatar() == null || user.getAvatar().trim().isEmpty()) {
                user.setAvatar("https://api.dicebear.com/7.x/avataaars/svg?seed=" + user.getUsername());
            }
            if (user.getAdminKey() == null) {
                user.setAdminKey("N"); // 默认普通用户
            }

            // 5. 保存到数据库
            User savedUser = userRepository.save(user);

            // 6. 返回成功响应（不返回密码）
            savedUser.setPassword(null); // 安全考虑，不返回密码
            return ResponseMessage.success(savedUser);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseMessage.error("创建用户失败: " + e.getMessage());
        }
    }
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }
    public ResponseMessage<User> register(RegisterDTO dto) {
        if (userRepository.findByUsername(dto.getUsername()) != null) {
            return ResponseMessage.error("用户名已存在");
        }
        if (userRepository.findByPhone(dto.getPhone()) != null) {
            return ResponseMessage.error("手机号已存在");
        }

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setAdminKey(""); // 注册默认为普通用户
        user.setAvatar(dto.getAvatar());

        User savedUser = userRepository.save(user);
        return ResponseMessage.success(savedUser);
    }

    @Override
    public ResponseMessage<String> login(LoginDTO dto) {
        User user = userRepository.findByUsername(dto.getUsername());
        if (user == null || !passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            return ResponseMessage.error("用户名或密码错误");
        }

        // ✅ 生成 Token 时传入 "USER"
        String token = jwtUtil.generateToken(user.getUsername(), "USER");
        return ResponseMessage.success(token);
    }

    @Override
    public ResponseMessage<Page<User>> getUsers(String keyword, Integer page, Integer size) {
        Pageable pageable = PageRequest.of(page - 1, size);
        Page<User> userPage = StringUtils.hasText(keyword)
                ? userRepository.findByUsernameContainingOrPhoneContaining(keyword, keyword, pageable)
                : userRepository.findAll(pageable);

        return ResponseMessage.success(userPage);
    }

    @Override
    public ResponseMessage<User> getUserById(Long id) {
        Optional<User> user = userRepository.findById(id);
        return user.map(ResponseMessage::success)
                .orElseGet(() -> ResponseMessage.error("用户不存在"));
    }

    @Override
    @Transactional
    public ResponseMessage<User> editUser(User user) {
        if (!userRepository.existsById(user.getId())) {
            return ResponseMessage.error("用户不存在");
        }
        // 密码不应在这里明文更新，应单独处理
        User updatedUser = userRepository.save(user);
        return ResponseMessage.success(updatedUser);
    }

    @Override
    @Transactional
    public ResponseMessage<Void> deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            return ResponseMessage.error("用户不存在");
        }
        userRepository.deleteById(id);
        return ResponseMessage.success(null);
    }

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}