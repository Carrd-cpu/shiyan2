package com.carrd.shiyan2.util;

import com.carrd.shiyan2.dto.Result;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public final class JsonUtil {
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private JsonUtil() {
    }

    public static void writeJson(HttpServletResponse response, Object body) throws IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        OBJECT_MAPPER.writeValue(response.getWriter(), body);
    }

    public static void writeError(HttpServletResponse response, int code, String msg) throws IOException {
        writeJson(response, Result.error(code, msg));
    }
}
