package org.example.new2.service;

import org.example.new2.pojo.Admin;
import org.example.new2.pojo.LoginDTO;
import org.example.new2.pojo.RegisterDTO;
import org.example.new2.pojo.ResponseMessage;

public interface IAdminService {
    ResponseMessage<Admin> register(RegisterDTO dto);
    ResponseMessage<String> login(LoginDTO dto);
    Admin findByUsername(String username); // 供 JwtFilter 调用
}