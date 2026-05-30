<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>购物车 - MVC Shop</title>
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
                    <div>我的购物车</div>
                    <span class="sub">勾选结算 · 修改数量 · 删除</span>
                </div>
            </div>
            <div class="nav-actions">
                <a class="link" href="${pageContext.request.contextPath}/product_list.jsp">继续购物</a>
                <a class="link" href="${pageContext.request.contextPath}/checkout.jsp">去结算</a>
            </div>
        </div>

        <div class="card-body" style="padding-top:0;">
            <table class="table">
                <thead>
                <tr>
                    <th style="width:72px;">选择</th>
                    <th style="width:80px;">ID</th>
                    <th style="text-align:left;">商品</th>
                    <th style="width:120px;">价格</th>
                    <th style="width:100px;">库存</th>
                    <th style="width:140px;">数量</th>
                    <th style="width:120px;">小计</th>
                    <th style="width:120px;">操作</th>
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
        return img.startsWith('http') ? img : (ctx + img);
    }

    function loadCart() {
        $.getJSON(ctx + '/cart?action=page&page=' + page + '&pageSize=' + pageSize, function (res) {
            if (res.code === 401) {
                window.location.href = ctx + '/login.jsp';
                return;
            }
            if (res.code !== 0) {
                alert(res.msg);
                return;
            }
            const data = res.data;
            total = data.total;

            const rows = (data.list || []).map(item => `
                <tr>
                    <td><input type="checkbox" \${item.checked === 1 ? 'checked' : ''} onchange="toggleCheck(\${item.id}, this.checked)"/></td>
                    <td>\${item.id}</td>
                    <td class="left">
                        <div class="prod">
                            <img class="thumb" src="\${safeImg(item.productImg)}" alt="img" onerror="this.src='\${ctx}/assets/products/placeholder.png'"/>
                            <div>\${escapeHtml(item.productName)}</div>
                        </div>
                    </td>
                    <td>￥\${fmtMoney(item.price)}</td>
                    <td>\${item.stock}</td>
                    <td>
                        <input class="input" type="number"
                               min="1"
                               max="\${item.stock}"
                               value="\${item.quantity}"
                               data-stock="\${item.stock}"
                               data-old="\${item.quantity}"
                               onchange="updateQty(\${item.id}, this)"
                               style="width:100px; padding:8px 10px;"/>
                    </td>
                    <td>￥\${fmtMoney(item.price * item.quantity)}</td>
                    <td><button class="btn btn-danger" onclick="delItem(\${item.id})">删除</button></td>
                </tr>
            `).join('');

            $('#tbody').html(rows || `<tr><td colspan="8" class="muted">购物车为空</td></tr>`);
            $('#pageInfo').text(`第 \${data.page} 页 / 共 \${Math.max(1, Math.ceil(total / pageSize))} 页 · 共 \${total} 条`);
        });
    }

    function toggleCheck(cartItemId, checked) {
        $.post(ctx + '/cart?action=check', {cartItemId: cartItemId, checked: checked ? 1 : 0}, function (res) {
            if (res.code !== 0) alert(res.msg);
        }, 'json');
    }

    // quantityInput: HTMLInputElement
    function updateQty(cartItemId, quantityInput) {
        const stock = parseInt($(quantityInput).data('stock'), 10);
        const oldVal = parseInt($(quantityInput).data('old'), 10);

        let q = parseInt(quantityInput.value, 10);
        if (isNaN(q)) q = oldVal;

        if (q < 1) {
            alert('数量不能小于 1');
            q = 1;
        }
        if (!isNaN(stock) && q > stock) {
            alert('数量不能超过库存（当前库存：' + stock + '）');
            q = stock;
        }

        // fix input value immediately
        quantityInput.value = String(q);

        $.post(ctx + '/cart?action=updateQty', {cartItemId: cartItemId, quantity: q}, function (res) {
            if (res.code !== 0) {
                alert(res.msg);
            }
            loadCart();
        }, 'json');
    }

    function delItem(cartItemId) {
        $.post(ctx + '/cart?action=delete', {cartItemId: cartItemId}, function (res) {
            if (res.code !== 0) {
                alert(res.msg);
            }
            loadCart();
        }, 'json');
    }

    $('#prev').on('click', function () {
        if (page > 1) {
            page--;
            loadCart();
        }
    });
    $('#next').on('click', function () {
        if (page * pageSize < total) {
            page++;
            loadCart();
        }
    });

    loadCart();
</script>
</body>
</html>
