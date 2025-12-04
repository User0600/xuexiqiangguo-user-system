package org.example.new2.controller;

import org.example.new2.pojo.Admin;
import org.example.new2.pojo.RegisterDTO;
import org.example.new2.pojo.LoginDTO;
import org.example.new2.pojo.ResponseMessage;
import org.example.new2.service.IAdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin") // ✅ 统一使用 /api/admin 前缀
public class AdminController {
    @Autowired
    private IAdminService adminService;

    @PostMapping("/register")
    public ResponseMessage<Admin> register(@Validated @RequestBody RegisterDTO dto) {
        return adminService.register(dto);
    }

    @PostMapping("/login")
    public ResponseMessage<String> login(@Validated @RequestBody LoginDTO dto) {
        return adminService.login(dto);
    }
}