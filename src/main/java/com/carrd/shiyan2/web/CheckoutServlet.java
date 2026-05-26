package com.carrd.shiyan2.web;

import com.carrd.shiyan2.dto.Result;
import com.carrd.shiyan2.service.CheckoutService;
import com.carrd.shiyan2.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends BaseServlet {
    private final CheckoutService checkoutService = new CheckoutService();

    protected void index(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        summary(req, resp);
    }

    protected void summary(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        JsonUtil.writeJson(resp, Result.success(checkoutService.summary(userId)));
    }
}
