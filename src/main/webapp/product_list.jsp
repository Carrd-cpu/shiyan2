<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>商品列表</title>
    <script src="https://cdn.staticfile.org/jquery/3.7.1/jquery.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        .top { display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>
<div class="top">
    <h3>商品列表</h3>
    <div>
        <a href="${pageContext.request.contextPath}/cart.jsp">我的购物车</a>
        <button id="logoutBtn">退出登录</button>
    </div>
</div>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>名称</th>
        <th>价格</th>
        <th>库存</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody id="tbody"></tbody>
</table>
<div style="margin-top:12px;">
    <button id="prev">上一页</button>
    <span id="pageInfo"></span>
    <button id="next">下一页</button>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    let page = 1;
    const pageSize = 10;
    let total = 0;

    function escapeHtml(text) {
        return $('<div/>').text(text == null ? '' : text).html();
    }

    function loadProducts() {
        $.getJSON(ctx + '/product?action=page&page=' + page + '&pageSize=' + pageSize, function (res) {
            if (res.code !== 0) {
                alert(res.msg);
                return;
            }
            const data = res.data;
            total = data.total;
            const rows = (data.list || []).map(p => `
                <tr>
                    <td>${p.id}</td>
                    <td>${escapeHtml(p.name)}</td>
                    <td>${p.price}</td>
                    <td>${p.stock}</td>
                    <td><button onclick="addToCart(${p.id})">加入购物车</button></td>
                </tr>
            `).join('');
            $('#tbody').html(rows);
            $('#pageInfo').text(`第 ${data.page} 页 / 共 ${Math.max(1, Math.ceil(total / pageSize))} 页`);
        });
    }

    function addToCart(productId) {
        $.post(ctx + '/cart?action=add', {productId: productId, quantity: 1}, function (res) {
            if (res.code === 0) {
                alert('加入成功');
            } else if (res.code === 401) {
                window.location.href = ctx + '/login.jsp';
            } else {
                alert(res.msg);
            }
        }, 'json');
    }

    $('#prev').on('click', function () {
        if (page > 1) {
            page--;
            loadProducts();
        }
    });
    $('#next').on('click', function () {
        if (page * pageSize < total) {
            page++;
            loadProducts();
        }
    });

    $('#logoutBtn').on('click', function () {
        $.post(ctx + '/auth?action=logout', function () {
            window.location.href = ctx + '/login.jsp';
        });
    });

    loadProducts();
</script>
</body>
</html>
