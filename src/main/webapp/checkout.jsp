<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>结算 - MVC Shop</title>
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
                    <div>结算</div>
                    <span class="sub">仅展示已勾选商品 · 统计总金额</span>
                </div>
            </div>
            <div class="nav-actions">
                <a class="link" href="${pageContext.request.contextPath}/cart.jsp">返回购物车</a>
            </div>
        </div>

        <div class="card-body" style="padding-top:0;">
            <table class="table">
                <thead>
                <tr>
                    <th style="width:80px;">ID</th>
                    <th style="text-align:left;">商品</th>
                    <th style="width:120px;">单价</th>
                    <th style="width:120px;">数量</th>
                    <th style="width:120px;">小计</th>
                </tr>
                </thead>
                <tbody id="tbody"></tbody>
            </table>
        </div>

        <div class="kv">
            <div class="item">总件数：<b id="totalCount">0</b></div>
            <div class="item">总金额：<b>￥<span id="totalAmount">0.00</span></b></div>
        </div>
    </div>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';

    function escapeHtml(text) {
        return $('<div/>').text(text == null ? '' : text).html();
    }

    function fmtMoney(n) {
        const v = Number(n);
        if (isNaN(v)) return n;
        return v.toFixed(2);
    }

    function loadSummary() {
        $.getJSON(ctx + '/checkout?action=summary', function (res) {
            if (res.code === 401) {
                window.location.href = ctx + '/login.jsp';
                return;
            }
            if (res.code !== 0) {
                alert(res.msg);
                return;
            }
            const data = res.data;
            const rows = (data.items || []).map(item => `
                <tr>
                    <td>\${item.id}</td>
                    <td class="left">\${escapeHtml(item.productName)}</td>
                    <td>￥\${fmtMoney(item.price)}</td>
                    <td>\${item.quantity}</td>
                    <td>￥\${fmtMoney(item.price * item.quantity)}</td>
                </tr>
            `).join('');

            $('#tbody').html(rows || `<tr><td colspan="5" class="muted">未勾选任何商品</td></tr>`);
            $('#totalCount').text(data.totalCount || 0);
            $('#totalAmount').text(fmtMoney(data.totalAmount || 0));
        });
    }

    loadSummary();
</script>
</body>
</html>
