package com.carrd.shiyan2.dao;

import com.carrd.shiyan2.entity.User;
import com.carrd.shiyan2.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDao {
    public User findByUsernameAndPassword(String username, String md5Password) {
        String sql = "SELECT id, username, password FROM `user` WHERE username = ? AND password = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, md5Password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getLong("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    return user;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Query user failed", e);
        }
        return null;
    }
}
