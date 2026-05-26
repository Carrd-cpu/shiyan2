package com.carrd.shiyan2.web;

import com.carrd.shiyan2.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.lang.reflect.Method;

public abstract class BaseServlet extends HttpServlet {
    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "index";
        }

        try {
            Method method = this.getClass().getDeclaredMethod(action, HttpServletRequest.class, HttpServletResponse.class);
            method.setAccessible(true);
            method.invoke(this, req, resp);
        } catch (NoSuchMethodException e) {
            JsonUtil.writeError(resp, 404, "action不存在: " + action);
        } catch (Exception e) {
            Throwable cause = e.getCause() == null ? e : e.getCause();
            JsonUtil.writeError(resp, 500, cause.getMessage());
        }
    }

    protected int getInt(HttpServletRequest req, String name, int defaultValue) {
        String value = req.getParameter(name);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    protected long getLong(HttpServletRequest req, String name, long defaultValue) {
        String value = req.getParameter(name);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    protected Long currentUserId(HttpServletRequest req) {
        Object userIdObj = req.getSession().getAttribute("userId");
        if (userIdObj instanceof Long value) {
            return value;
        }
        if (userIdObj instanceof Integer value) {
            return value.longValue();
        }
        return null;
    }
}
