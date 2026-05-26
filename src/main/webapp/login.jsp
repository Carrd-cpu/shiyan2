<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - MVC Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
    <script src="https://cdn.staticfile.org/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<div class="auth-wrap">
    <div class="card auth-card">
        <div class="navbar" style="padding:0 0 14px;">
            <div class="brand">
                <span class="logo"></span>
                <div>
                    <div>MVC Shop</div>
                    <span class="sub">Servlet / JSP / JDBC / Druid</span>
                </div>
            </div>
        </div>

        <h2 class="auth-title">在线购物系统登录</h2>
        <p class="auth-desc">请输入账号密码登录（示例账号：student / 123456）。</p>

        <div class="form-row">
            <input class="input" id="username" placeholder="用户名" autocomplete="username"/>
        </div>
        <div class="form-row">
            <input class="input" id="password" type="password" placeholder="密码" autocomplete="current-password"/>
        </div>
        <div class="form-row">
            <button class="btn btn-primary" id="loginBtn" style="width:100%;">登录</button>
        </div>
        <div class="msg" id="msg"></div>

        <div class="muted" style="font-size:12px; margin-top: 8px;">
            提示：如登录后出现 500，请先检查 <code>druid.properties</code> 的数据库账号密码是否正确。
        </div>
    </div>
</div>
<script>
    const ctx = '${pageContext.request.contextPath}';

    function doLogin() {
        $('#msg').text('');
        $.post(ctx + '/auth?action=login', {
            username: $('#username').val(),
            password: $('#password').val()
        }, function (res) {
            if (res.code === 0) {
                window.location.href = ctx + '/product_list.jsp';
            } else {
                $('#msg').text(res.msg || '登录失败');
            }
        }, 'json');
    }

    $('#loginBtn').on('click', doLogin);
    $('#password').on('keydown', function (e) {
        if (e.key === 'Enter') doLogin();
    });
</script>
</body>
</html>
