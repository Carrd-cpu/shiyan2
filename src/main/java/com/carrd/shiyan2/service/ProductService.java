package com.carrd.shiyan2.service;

import com.carrd.shiyan2.dao.ProductDao;
import com.carrd.shiyan2.dto.PageResult;
import com.carrd.shiyan2.entity.Product;

import java.util.List;

public class ProductService {
    private final ProductDao productDao = new ProductDao();

    public PageResult<Product> page(int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safePageSize = Math.max(pageSize, 1);
        long total = productDao.countAll();
        int offset = (safePage - 1) * safePageSize;
        List<Product> list = productDao.page(offset, safePageSize);

        PageResult<Product> result = new PageResult<>();
        result.setPage(safePage);
        result.setPageSize(safePageSize);
        result.setTotal(total);
        result.setList(list);
        return result;
    }
}
