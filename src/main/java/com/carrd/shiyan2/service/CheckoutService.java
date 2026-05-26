package com.carrd.shiyan2.service;

import com.carrd.shiyan2.dto.CheckoutSummary;
import com.carrd.shiyan2.entity.CartItem;

import java.math.BigDecimal;
import java.util.List;

public class CheckoutService {
    private final CartService cartService = new CartService();

    public CheckoutSummary summary(Long userId) {
        List<CartItem> items = cartService.listCheckedItems(userId);
        int totalCount = 0;
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : items) {
            totalCount += item.getQuantity();
            totalAmount = totalAmount.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }

        CheckoutSummary summary = new CheckoutSummary();
        summary.setItems(items);
        summary.setTotalCount(totalCount);
        summary.setTotalAmount(totalAmount);
        return summary;
    }
}
