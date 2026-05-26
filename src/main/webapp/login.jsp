<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - MVC Shop</title>
    <script src="https://cdn.staticfile.org/jquery/3.7.1/jquery.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        .box { width: 320px; margin: 120px auto; background: #fff; padding: 20px; border-radius: 8px; }
        input { width: 100%; padding: 8px; margin-bottom: 12px; box-sizing: border-box; }
        button { width: 100%; padding: 9px; }
        .msg { color: #d00; min-height: 20px; }
    </style>
</head>
<body>
<div class="box">
    <h3>在线购物系统登录</h3>
    <input id="username" placeholder="用户名" value="student"/>
    <input id="password" type="password" placeholder="密码" value="123456"/>
    <button id="loginBtn">登录</button>
    <div class="msg" id="msg"></div>
</div>
<script>
    const ctx = '${pageContext.request.contextPath}';
    $('#loginBtn').on('click', function () {
        $.post(ctx + '/auth?action=login', {
            username: $('#username').val(),
            password: $('#password').val()
        }, function (res) {
            if (res.code === 0) {
                window.location.href = ctx + '/product_list.jsp';
            } else {
                $('#msg').text(res.msg);
            }
        }, 'json');
    });
</script>
</body>
</html>
