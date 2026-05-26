<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>结算页</title>
    <script src="https://cdn.staticfile.org/jquery/3.7.1/jquery.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    </style>
</head>
<body>
<h3>结算</h3>
<div><a href="${pageContext.request.contextPath}/cart.jsp">返回购物车</a></div>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>商品</th>
        <th>单价</th>
        <th>数量</th>
        <th>小计</th>
    </tr>
    </thead>
    <tbody id="tbody"></tbody>
</table>
<div style="margin-top: 12px;">
    总件数：<span id="totalCount">0</span>
    总金额：￥<span id="totalAmount">0.00</span>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    function escapeHtml(text) {
        return $('<div/>').text(text == null ? '' : text).html();
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
                    <td>${item.id}</td>
                    <td>${escapeHtml(item.productName)}</td>
                    <td>${item.price}</td>
                    <td>${item.quantity}</td>
                    <td>${(item.price * item.quantity).toFixed(2)}</td>
                </tr>
            `).join('');
            $('#tbody').html(rows);
            $('#totalCount').text(data.totalCount || 0);
            $('#totalAmount').text(data.totalAmount || '0.00');
        });
    }

    loadSummary();
</script>
</body>
</html>
