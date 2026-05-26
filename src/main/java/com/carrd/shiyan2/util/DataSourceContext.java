package com.carrd.shiyan2.util;

import javax.sql.DataSource;

public final class DataSourceContext {
    private static volatile DataSource dataSource;

    private DataSourceContext() {
    }

    public static void setDataSource(DataSource ds) {
        dataSource = ds;
    }

    public static DataSource getDataSource() {
        if (dataSource == null) {
            throw new IllegalStateException("DataSource has not been initialized.");
        }
        return dataSource;
    }
}
