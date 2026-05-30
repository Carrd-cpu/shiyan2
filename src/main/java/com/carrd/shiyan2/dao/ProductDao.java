package com.carrd.shiyan2.dao;

import com.carrd.shiyan2.entity.Product;
import com.carrd.shiyan2.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {
    public long countAll() {
        String sql = "SELECT COUNT(*) FROM product";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Count products failed", e);
        }
        return 0;
    }

    public List<Product> page(int offset, int pageSize) {
        String sql = "SELECT id, name, img, price, stock FROM product ORDER BY id LIMIT ?, ?";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getLong("id"));
                    p.setName(rs.getString("name"));
                    p.setImg(rs.getString("img"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setStock(rs.getInt("stock"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Page products failed", e);
        }
        return list;
    }

    public Product findById(Long id) {
        String sql = "SELECT id, name, img, price, stock FROM product WHERE id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getLong("id"));
                    p.setName(rs.getString("name"));
                    p.setImg(rs.getString("img"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setStock(rs.getInt("stock"));
                    return p;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Query product failed", e);
        }
        return null;
    }
}
