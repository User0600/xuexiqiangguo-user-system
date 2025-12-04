package org.example.new2.service;

import org.example.new2.pojo.LoginDTO;
import org.example.new2.pojo.RegisterDTO;
import org.example.new2.pojo.ResponseMessage;
import org.example.new2.pojo.User;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;

public interface IUserService {
    @Transactional
    User findById(Long id);

    ResponseMessage<User> register(RegisterDTO dto);
    ResponseMessage<String> login(LoginDTO dto);
    ResponseMessage<Page<User>> getUsers(String keyword, Integer page, Integer size);
    ResponseMessage<User> getUserById(Long id);
    ResponseMessage<User> editUser(User user);
    ResponseMessage<Void> deleteUser(Long id);
    User findByUsername(String username); // 供 JwtFilter 调用

    ResponseMessage<User> createUser(User user);
}