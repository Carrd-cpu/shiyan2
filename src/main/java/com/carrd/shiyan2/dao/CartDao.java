package com.carrd.shiyan2.dao;

import com.carrd.shiyan2.entity.CartItem;
import com.carrd.shiyan2.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDao {
    public CartItem findByUserAndProduct(Long userId, Long productId) {
        String sql = "SELECT id, user_id, product_id, quantity, checked FROM cart_item WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getLong("id"));
                    item.setUserId(rs.getLong("user_id"));
                    item.setProductId(rs.getLong("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setChecked(rs.getInt("checked"));
                    return item;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Query cart item failed", e);
        }
        return null;
    }

    public int insert(Long userId, Long productId, int quantity) {
        String sql = "INSERT INTO cart_item(user_id, product_id, quantity, checked) VALUES(?,?,?,1)";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, productId);
            ps.setInt(3, quantity);
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Insert cart item failed", e);
        }
    }

    public int updateQuantityByUserProduct(Long userId, Long productId, int quantity) {
        String sql = "UPDATE cart_item SET quantity = ?, update_time = CURRENT_TIMESTAMP WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setLong(2, userId);
            ps.setLong(3, productId);
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Update cart quantity failed", e);
        }
    }

    public CartItem findDetailById(Long userId, Long cartItemId) {
        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, c.checked, p.name AS product_name, p.price, p.stock " +
                "FROM cart_item c JOIN product p ON c.product_id = p.id WHERE c.user_id = ? AND c.id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, cartItemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDetail(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Query cart detail failed", e);
        }
        return null;
    }

    public int updateQuantityById(Long userId, Long cartItemId, int quantity) {
        String sql = "UPDATE cart_item SET quantity = ?, update_time = CURRENT_TIMESTAMP WHERE user_id = ? AND id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setLong(2, userId);
            ps.setLong(3, cartItemId);
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Update cart quantity by id failed", e);
        }
    }

    public int updateChecked(Long userId, Long cartItemId, int checked) {
        String sql = "UPDATE cart_item SET checked = ?, update_time = CURRENT_TIMESTAMP WHERE user_id = ? AND id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, checked);
            ps.setLong(2, userId);
            ps.setLong(3, cartItemId);
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Update checked failed", e);
        }
    }

    public int deleteById(Long userId, Long cartItemId) {
        String sql = "DELETE FROM cart_item WHERE user_id = ? AND id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, cartItemId);
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Delete cart item failed", e);
        }
    }

    public long countByUser(Long userId) {
        String sql = "SELECT COUNT(*) FROM cart_item WHERE user_id = ?";
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Count cart items failed", e);
        }
        return 0;
    }

    public List<CartItem> pageByUser(Long userId, int offset, int pageSize) {
        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, c.checked, p.name AS product_name, p.price, p.stock " +
                "FROM cart_item c JOIN product p ON c.product_id = p.id WHERE c.user_id = ? ORDER BY c.id DESC LIMIT ?, ?";
        List<CartItem> list = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDetail(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Page cart items failed", e);
        }
        return list;
    }

    public List<CartItem> listCheckedItems(Long userId) {
        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, c.checked, p.name AS product_name, p.price, p.stock " +
                "FROM cart_item c JOIN product p ON c.product_id = p.id WHERE c.user_id = ? AND c.checked = 1 ORDER BY c.id DESC";
        List<CartItem> list = new ArrayList<>();
        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDetail(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("List checked items failed", e);
        }
        return list;
    }

    private CartItem mapDetail(ResultSet rs) throws Exception {
        CartItem item = new CartItem();
        item.setId(rs.getLong("id"));
        item.setUserId(rs.getLong("user_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setChecked(rs.getInt("checked"));
        item.setProductName(rs.getString("product_name"));
        item.setPrice(rs.getBigDecimal("price"));
        item.setStock(rs.getInt("stock"));
        return item;
    }
}
