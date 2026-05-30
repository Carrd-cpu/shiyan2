<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>商品列表 - MVC Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
    <script src="https://cdn.staticfile.org/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="navbar">
            <div class="brand">
                <span class="logo"></span>
                <div>
                    <div>商品列表</div>
                    <span class="sub">分页浏览 · 加入购物车</span>
                </div>
            </div>
            <div class="nav-actions">
                <a class="link" href="${pageContext.request.contextPath}/cart.jsp">我的购物车</a>
                <button class="btn btn-secondary" id="logoutBtn">退出登录</button>
            </div>
        </div>

        <div class="card-body" style="padding-top:0;">
            <table class="table">
                <thead>
                <tr>
                    <th style="width:96px;">图片</th>
                    <th style="width:80px;">ID</th>
                    <th style="text-align:left;">名称</th>
                    <th style="width:120px;">价格</th>
                    <th style="width:120px;">库存</th>
                    <th style="width:140px;">操作</th>
                </tr>
                </thead>
                <tbody id="tbody"></tbody>
            </table>
        </div>

        <div class="toolbar">
            <div class="badge" id="pageInfo">加载中...</div>
            <div class="pager">
                <button class="btn btn-secondary" id="prev">上一页</button>
                <button class="btn btn-secondary" id="next">下一页</button>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    let page = 1;
    const pageSize = 10;
    let total = 0;

    function escapeHtml(text) {
        return $('<div/>').text(text == null ? '' : text).html();
    }

    function fmtMoney(n) {
        const v = Number(n);
        if (isNaN(v)) return n;
        return v.toFixed(2);
    }

    function safeImg(img) {
        if (!img) return ctx + '/assets/products/placeholder.png';
        // DB stores like /assets/products/p01.png
        return img.startsWith('http') ? img : (ctx + img);
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
                    <td><img class="thumb" src="\${safeImg(p.img)}" alt="img" onerror="this.src='\${ctx}/assets/products/placeholder.png'"/></td>
                    <td>\${p.id}</td>
                    <td class="left">\${escapeHtml(p.name)}</td>
                    <td>￥\${fmtMoney(p.price)}</td>
                    <td>\${p.stock}</td>
                    <td><button class="btn btn-primary" onclick="addToCart(\${p.id})">加入购物车</button></td>
                </tr>
            `).join('');

            $('#tbody').html(rows || `<tr><td colspan="6" class="muted">暂无数据</td></tr>`);
            $('#pageInfo').text(`第 \${data.page} 页 / 共 \${Math.max(1, Math.ceil(total / pageSize))} 页 · 共 \${total} 条`);
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
