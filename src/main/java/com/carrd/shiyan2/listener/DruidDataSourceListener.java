package com.carrd.shiyan2.listener;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.pool.DruidDataSourceFactory;
import com.carrd.shiyan2.util.DataSourceContext;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

@WebListener
public class DruidDataSourceListener implements ServletContextListener {
    public static final String DS_KEY = "DATA_SOURCE";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        Properties properties = new Properties();
        try (InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("druid.properties")) {
            if (is == null) {
                throw new IllegalStateException("druid.properties not found in classpath");
            }
            properties.load(is);
            DataSource dataSource = DruidDataSourceFactory.createDataSource(properties);
            DataSourceContext.setDataSource(dataSource);
            context.setAttribute(DS_KEY, dataSource);
            context.log("Druid data source initialized.");
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize data source", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        Object ds = sce.getServletContext().getAttribute(DS_KEY);
        if (ds instanceof DruidDataSource druidDataSource) {
            druidDataSource.close();
            sce.getServletContext().log("Druid data source closed.");
        }
    }
}
