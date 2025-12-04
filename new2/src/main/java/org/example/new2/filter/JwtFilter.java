package org.example.new2.filter;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.new2.entity.Admin;
import org.example.new2.entity.User;
import org.example.new2.service.IAdminService;
import org.example.new2.service.IUserService;
import org.example.new2.util.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Component
public class JwtFilter extends OncePerRequestFilter {
    private static final Logger logger = LoggerFactory.getLogger(JwtFilter.class);

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    @Lazy
    private IUserService userService;

    @Autowired
    @Lazy
    private IAdminService adminService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {

        // 跳过 OPTIONS 预检请求
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        String bearerToken = request.getHeader("Authorization");
        String token = jwtUtil.resolveToken(bearerToken);

        if (token != null) {
            try {
                String username = jwtUtil.extractUsername(token);
                String userType = jwtUtil.extractUserType(token);

                if (StringUtils.hasText(username) && StringUtils.hasText(userType)) {
                    if ("ADMIN".equals(userType)) {
                        Admin admin = adminService.findByUsername(username);
                        if (admin != null && jwtUtil.validateToken(token, username)) {
                            // ✅ 关键：设置 ADMIN 权限
                            setAuthentication(admin.getUsername(), "ADMIN", request);
                            logger.info("Admin authenticated: {}", username);
                        }
                    } else if ("USER".equals(userType)) {
                        User user = userService.findByUsername(username);
                        if (user != null && jwtUtil.validateToken(token, username)) {
                            // ✅ 设置 USER 权限
                            setAuthentication(user.getUsername(), "USER", request);
                            logger.info("User authenticated: {}", username);
                        }
                    } else {
                        logger.warn("Unknown userType: {}", userType);
                    }
                }
            } catch (JwtException e) {
                logger.error("JWT validation failed: {}", e.getMessage());
            } catch (Exception e) {
                logger.error("Authentication error: {}", e.getMessage(), e);
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * 设置认证信息
     * @param username 用户名
     * @param userType 用户类型：ADMIN 或 USER
     * @param request 请求对象
     */
    private void setAuthentication(String username, String userType, HttpServletRequest request) {
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        if ("ADMIN".equals(userType)) {
            authorities.add(new SimpleGrantedAuthority("ADMIN"));
        } else {
            authorities.add(new SimpleGrantedAuthority("USER"));
        }

        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                username, null, authorities
        );
        auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(auth);
    }
}