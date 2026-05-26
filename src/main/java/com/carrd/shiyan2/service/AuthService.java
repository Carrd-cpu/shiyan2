package com.carrd.shiyan2.service;

import com.carrd.shiyan2.dao.UserDao;
import com.carrd.shiyan2.entity.User;
import com.carrd.shiyan2.util.MD5Util;

public class AuthService {
    private final UserDao userDao = new UserDao();

    public User login(String username, String plainPassword) {
        if (username == null || username.isBlank() || plainPassword == null || plainPassword.isBlank()) {
            return null;
        }
        String md5 = MD5Util.md5Hex(plainPassword);
        return userDao.findByUsernameAndPassword(username.trim(), md5);
    }
}
