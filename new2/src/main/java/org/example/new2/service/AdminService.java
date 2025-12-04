package org.example.new2.service; // ✅ 修正包路径

import org.example.new2.pojo.Admin;
import org.example.new2.pojo.LoginDTO;
import org.example.new2.pojo.RegisterDTO;
import org.example.new2.pojo.ResponseMessage;
import org.example.new2.repository.AdminRepository;
import org.example.new2.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminService implements IAdminService {
    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    @Transactional
    public ResponseMessage<Admin> register(RegisterDTO dto) {
        if (adminRepository.findByUsername(dto.getUsername()) != null) {
            return ResponseMessage.error("管理员账号已存在");
        }

        Admin admin = new Admin();
        admin.setUsername(dto.getUsername());
        admin.setPassword(passwordEncoder.encode(dto.getPassword()));
        admin.setPhone(dto.getPhone());
        admin.setEmail(dto.getEmail());
        admin.setAdminKey("Y"); // 明确设置为管理员

        Admin savedAdmin = adminRepository.save(admin);
        return ResponseMessage.success(savedAdmin);
    }

    @Override
    public ResponseMessage<String> login(LoginDTO dto) {
        Admin admin = adminRepository.findByUsername(dto.getUsername());
        if (admin == null || !passwordEncoder.matches(dto.getPassword(), admin.getPassword())) {
            return ResponseMessage.error("用户名或密码错误");
        }

        // ✅ 关键：生成 Token 时传入 "ADMIN"
        String token = jwtUtil.generateToken(admin.getUsername(), "ADMIN");
        return ResponseMessage.success(token);
    }

    @Override
    public Admin findByUsername(String username) {
        return adminRepository.findByUsername(username);
    }
}