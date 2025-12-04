package org.example.new2.repository;

import org.example.new2.pojo.Admin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdminRepository extends JpaRepository<Admin, Long> {
    /**
     * 根据用户名查找管理员
     */
    Admin findByUsername(String username);

    /**
     * 根据手机号查找管理员
     */
    Admin findByPhone(String phone);
}
