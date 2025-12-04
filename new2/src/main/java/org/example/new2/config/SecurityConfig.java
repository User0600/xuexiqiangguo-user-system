package org.example.new2.config;

import org.example.new2.filter.JwtFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true) // ✅ 启用方法级权限注解
public class SecurityConfig {
    @Autowired
    private JwtFilter jwtFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();


        config.setAllowedOriginPatterns(List.of(
                // ⚠️⚠️⚠️ 修改这里：为了测试，暂时允许所有来源
                // 测试完成后，记得改回 List.of("http://localhost:5173", ...) 以保证安全
                "*"
//                "http://localhost:5173",
//                "http://127.0.0.1:5173",
//                "http://localhost:3000",
//                "http://127.0.0.1:3000"
        ));

        // ✅ 修复 2：简化配置
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of("*")); // 允许所有请求头
        config.setExposedHeaders(List.of("Authorization","token"));//我添加了“token” 暴露 header
        config.setAllowCredentials(true);
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", config); // 建议改成 /** 匹配范围更大
        return source;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // ✅ 公开接口（无需登录）
                        // 1. 处理 OPTIONS 预检请求 (浏览器跨域必须)
                        .requestMatchers(HttpMethod.OPTIONS, "/api/**").permitAll()
                        // 2. 登录注册接口 (公开)
                        .requestMatchers("/api/admin/login", "/api/admin/register").permitAll()
                        .requestMatchers("/api/user/login", "/api/user/register").permitAll()
                        // 🔥🔥🔥 3. 新增：放行题库所有接口 (用于测试) 🔥🔥🔥
                        // 这样即使不传 Token，或者 Token 格式不对，也可以访问提交和查询
                        .requestMatchers("/api/question/**").permitAll()


                        // ✅ 核心修复：使用 antMatchers 风格（更稳定）
                        // 4. 管理员权限控制
                        .requestMatchers("/api/user/list").hasAuthority("ADMIN")
                        .requestMatchers("/api/user/edit").hasAuthority("ADMIN")
                        .requestMatchers("/api/user/*").hasAuthority("ADMIN") // 删除用户

                        // ✅ 其他接口需要认证（普通用户可访问自己的信息）
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}