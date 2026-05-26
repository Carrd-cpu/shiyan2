package com.carrd.shiyan2.util;

import java.sql.Connection;
import java.sql.SQLException;

public final class DbUtil {
    private DbUtil() {
    }

    public static Connection getConnection() throws SQLException {
        return DataSourceContext.getDataSource().getConnection();
    }
}
