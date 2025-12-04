package org.example.new2.repository;

import org.example.new2.pojo.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    /**
     * 根据用户名查找用户
     */
    User findByUsername(String username);

    /**
     * 根据手机号查找用户
     */
    User findByPhone(String phone);

    /**
     * 模糊搜索用户名或手机号（分页）
     */
    Page<User> findByUsernameContainingOrPhoneContaining(String username, String phone, Pageable pageable);
}