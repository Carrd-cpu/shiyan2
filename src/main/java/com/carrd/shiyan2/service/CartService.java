package com.carrd.shiyan2.service;

import com.carrd.shiyan2.dao.CartDao;
import com.carrd.shiyan2.dao.ProductDao;
import com.carrd.shiyan2.dto.PageResult;
import com.carrd.shiyan2.entity.CartItem;
import com.carrd.shiyan2.entity.Product;

import java.util.List;

public class CartService {
    private final CartDao cartDao = new CartDao();
    private final ProductDao productDao = new ProductDao();

    public void add(Long userId, Long productId, int quantity) {
        Product product = productDao.findById(productId);
        if (product == null) {
            throw new IllegalArgumentException("商品不存在");
        }
        if (quantity < 1) {
            throw new IllegalArgumentException("数量必须大于等于1");
        }

        CartItem existed = cartDao.findByUserAndProduct(userId, productId);
        int targetQty = quantity;
        if (existed != null) {
            targetQty = existed.getQuantity() + quantity;
        }
        if (targetQty > product.getStock()) {
            throw new IllegalArgumentException("数量不能超过库存");
        }

        if (existed == null) {
            cartDao.insert(userId, productId, quantity);
        } else {
            cartDao.updateQuantityByUserProduct(userId, productId, targetQty);
        }
    }

    public PageResult<CartItem> page(Long userId, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safePageSize = Math.max(pageSize, 1);
        long total = cartDao.countByUser(userId);
        int offset = (safePage - 1) * safePageSize;
        List<CartItem> list = cartDao.pageByUser(userId, offset, safePageSize);

        PageResult<CartItem> result = new PageResult<>();
        result.setPage(safePage);
        result.setPageSize(safePageSize);
        result.setTotal(total);
        result.setList(list);
        return result;
    }

    public void updateQuantity(Long userId, Long cartItemId, int quantity) {
        if (quantity < 1) {
            throw new IllegalArgumentException("数量必须大于等于1");
        }
        CartItem item = cartDao.findDetailById(userId, cartItemId);
        if (item == null) {
            throw new IllegalArgumentException("购物车项不存在");
        }
        if (quantity > item.getStock()) {
            throw new IllegalArgumentException("数量不能超过库存");
        }
        cartDao.updateQuantityById(userId, cartItemId, quantity);
    }

    public void updateChecked(Long userId, Long cartItemId, int checked) {
        if (checked != 0 && checked != 1) {
            throw new IllegalArgumentException("checked参数不合法");
        }
        CartItem item = cartDao.findDetailById(userId, cartItemId);
        if (item == null) {
            throw new IllegalArgumentException("购物车项不存在");
        }
        cartDao.updateChecked(userId, cartItemId, checked);
    }

    public void delete(Long userId, Long cartItemId) {
        cartDao.deleteById(userId, cartItemId);
    }

    public List<CartItem> listCheckedItems(Long userId) {
        return cartDao.listCheckedItems(userId);
    }
}
