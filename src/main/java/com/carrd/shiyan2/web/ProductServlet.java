package com.carrd.shiyan2.web;

import com.carrd.shiyan2.dto.Result;
import com.carrd.shiyan2.service.ProductService;
import com.carrd.shiyan2.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/product")
public class ProductServlet extends BaseServlet {
    private final ProductService productService = new ProductService();

    protected void index(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        page(req, resp);
    }

    protected void page(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int page = getInt(req, "page", 1);
        int pageSize = getInt(req, "pageSize", 10);
        JsonUtil.writeJson(resp, Result.success(productService.page(page, pageSize)));
    }
}
