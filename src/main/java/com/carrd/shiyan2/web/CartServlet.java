package com.carrd.shiyan2.web;

import com.carrd.shiyan2.dto.Result;
import com.carrd.shiyan2.service.CartService;
import com.carrd.shiyan2.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends BaseServlet {
    private final CartService cartService = new CartService();

    protected void index(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        page(req, resp);
    }

    protected void add(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        long productId = getLong(req, "productId", 0);
        int quantity = getInt(req, "quantity", 1);
        cartService.add(userId, productId, quantity);
        JsonUtil.writeJson(resp, Result.success("ok"));
    }

    protected void page(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        int page = getInt(req, "page", 1);
        int pageSize = getInt(req, "pageSize", 10);
        JsonUtil.writeJson(resp, Result.success(cartService.page(userId, page, pageSize)));
    }

    protected void updateQty(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        long cartItemId = getLong(req, "cartItemId", 0);
        int quantity = getInt(req, "quantity", 1);
        cartService.updateQuantity(userId, cartItemId, quantity);
        JsonUtil.writeJson(resp, Result.success("ok"));
    }

    protected void check(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        long cartItemId = getLong(req, "cartItemId", 0);
        int checked = getInt(req, "checked", 1);
        cartService.updateChecked(userId, cartItemId, checked);
        JsonUtil.writeJson(resp, Result.success("ok"));
    }

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long userId = currentUserId(req);
        long cartItemId = getLong(req, "cartItemId", 0);
        cartService.delete(userId, cartItemId);
        JsonUtil.writeJson(resp, Result.success("ok"));
    }
}
