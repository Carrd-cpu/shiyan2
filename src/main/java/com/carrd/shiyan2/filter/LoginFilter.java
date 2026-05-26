package com.carrd.shiyan2.filter;

import com.carrd.shiyan2.util.JsonUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        boolean protectedPath = path.startsWith("/cart") || path.startsWith("/checkout") || "/cart.jsp".equals(path) || "/checkout.jsp".equals(path);

        if (!protectedPath) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Object userId = session == null ? null : session.getAttribute("userId");
        if (userId != null) {
            chain.doFilter(request, response);
            return;
        }

        if (path.endsWith(".jsp")) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            JsonUtil.writeError(resp, 401, "请先登录");
        }
    }
}
