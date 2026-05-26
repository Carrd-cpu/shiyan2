<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
    <script src="https://cdn.staticfile.org/jquery/3.7.1/jquery.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    </style>
</head>
<body>
<h3>我的购物车</h3>
<div>
    <a href="${pageContext.request.contextPath}/product_list.jsp">继续购物</a>
    <a href="${pageContext.request.contextPath}/checkout.jsp">去结算</a>
</div>
<table>
    <thead>
    <tr>
        <th>选择</th>
        <th>ID</th>
        <th>商品</th>
        <th>价格</th>
        <th>库存</th>
        <th>数量</th>
        <th>小计</th>
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
                    <td>\${escapeHtml(item.productName)}</td>
                    <td>\${item.price}</td>
                    <td>\${item.stock}</td>
                    <td>
                        <input type="number"
                               min="1"
                               max="\${item.stock}"
                               value="\${item.quantity}"
                               data-stock="\${item.stock}"
                               data-old="\${item.quantity}"
                               onchange="updateQty(\${item.id}, this)"
                               style="width:70px;"/>
                    </td>
                    <td>\${(item.price * item.quantity).toFixed(2)}</td>
                    <td><button onclick="delItem(\${item.id})">删除</button></td>
                </tr>
            `).join('');
            $('#tbody').html(rows);
            $('#pageInfo').text(`第 \${data.page} 页 / 共 \${Math.max(1, Math.ceil(total / pageSize))} 页`);
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
