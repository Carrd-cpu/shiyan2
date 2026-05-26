package com.carrd.shiyan2.web;

import com.carrd.shiyan2.dto.Result;
import com.carrd.shiyan2.entity.User;
import com.carrd.shiyan2.service.AuthService;
import com.carrd.shiyan2.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/auth")
public class AuthServlet extends BaseServlet {
    private final AuthService authService = new AuthService();

    protected void index(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JsonUtil.writeError(resp, 400, "请指定action");
    }

    protected void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User user = authService.login(username, password);
        if (user == null) {
            JsonUtil.writeJson(resp, Result.error(400, "用户名或密码错误"));
            return;
        }
        req.getSession(true).setAttribute("userId", user.getId());
        req.getSession().setAttribute("username", user.getUsername());

        Map<String, Object> data = new HashMap<>();
        data.put("userId", user.getId());
        data.put("username", user.getUsername());
        JsonUtil.writeJson(resp, Result.success(data));
    }

    protected void me(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        if (userId == null) {
            JsonUtil.writeJson(resp, Result.error(401, "未登录"));
            return;
        }
        Map<String, Object> data = new HashMap<>();
        data.put("userId", userId);
        data.put("username", String.valueOf(req.getSession().getAttribute("username")));
        JsonUtil.writeJson(resp, Result.success(data));
    }

    protected void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        JsonUtil.writeJson(resp, Result.success("ok"));
    }
}
