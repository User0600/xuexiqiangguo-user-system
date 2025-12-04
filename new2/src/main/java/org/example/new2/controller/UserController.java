package org.example.new2.controller;

import org.example.new2.entity.User;
import org.example.new2.dto.RegisterDTO;
import org.example.new2.dto.LoginDTO;
import org.example.new2.entity.ResponseMessage;
import org.example.new2.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;

import com.baomidou.mybatisplus.core.metadata.IPage;// ✅ 引入 MyBatis-Plus 的分页接口
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private IUserService userService;

    @PostMapping
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseMessage<User> createUser(@Validated @RequestBody User user) {
        return userService.createUser(user); // 您需要在service中实现此方法
    }


    /**
     * ✅ 用户列表 - 仅限管理员
     */
    @GetMapping("/list")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseMessage<IPage<User>> listUsers(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return userService.getUsers(keyword, page, size);
    }

    /**
     * ✅ 用户注册 - 公开接口
     */
    @PostMapping("/register")
    public ResponseMessage<User> userRegister(@Validated @RequestBody RegisterDTO dto) {
        return userService.register(dto);
    }

    /**
     * ✅ 用户登录 - 公开接口
     */
    @PostMapping("/login")
    public ResponseMessage<String> userLogin(@Validated @RequestBody LoginDTO dto) {
        return userService.login(dto);
    }

    /**
     * ✅ 查询用户 - 管理员或本人可查看
     * 示例：用户只能查自己的信息，管理员可查所有人
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('ADMIN') or authentication.name == @userService.findById(#id).username")
    public ResponseMessage<User> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    /**
     * ✅ 编辑用户 - 仅限管理员
     */
    @PutMapping("/edit")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseMessage<User> editUser(@Validated @RequestBody User user) {
        return userService.editUser(user);
    }

    /**
     * ✅ 删除用户 - 仅限管理员
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseMessage<Void> deleteUser(@PathVariable Long id) {
        return userService.deleteUser(id);
    }
}