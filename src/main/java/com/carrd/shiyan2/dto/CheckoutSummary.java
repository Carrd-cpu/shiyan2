package com.carrd.shiyan2.dto;

import com.carrd.shiyan2.entity.CartItem;

import java.math.BigDecimal;
import java.util.List;

public class CheckoutSummary {
    private List<CartItem> items;
    private int totalCount;
    private BigDecimal totalAmount;

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
}
