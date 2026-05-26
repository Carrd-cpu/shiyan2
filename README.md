# shiyan2 - Java Web MVC 在线购物系统

基于 **JDK 21 + Tomcat 10.x + MySQL 8.5 + Maven WAR** 的 Servlet/JSP MVC 实验项目。

## 技术栈
- Servlet/JSP（jakarta.servlet）
- JDBC + Druid 连接池
- MySQL
- jQuery AJAX

## 项目结构
- `src/main/java/com/carrd/shiyan2/web`：Servlet 控制层（单 Servlet 多 action）
- `src/main/java/com/carrd/shiyan2/service`：业务层
- `src/main/java/com/carrd/shiyan2/dao`：DAO 层
- `src/main/java/com/carrd/shiyan2/entity`：实体层
- `src/main/java/com/carrd/shiyan2/dto`：DTO 层
- `src/main/java/com/carrd/shiyan2/filter`：过滤器
- `src/main/java/com/carrd/shiyan2/listener`：监听器
- `src/main/webapp/*.jsp`：页面
- `sql/init.sql`：数据库初始化脚本

## 功能
1. 登录（无注册，MD5 比对）
2. 商品列表分页（默认每页 10）
3. 购物车（落库，按 user_id + product_id 合并数量）
4. 购物车分页、数量修改、删除、勾选结算项
5. 结算页展示已勾选商品、总数量、总金额（不落订单）

## 数据库初始化
1. 使用 MySQL 执行：`sql/init.sql`
2. 默认数据库：`mvc_shop1`
3. 默认登录账号：
   - 用户名：`student`
   - 密码：`123456`

## 连接池配置
配置文件：`src/main/resources/druid.properties`

当前示例配置（仅本地开发示例）使用：
- `username=root`
- `password=20120104`

请按你自己的环境修改数据库地址、用户名和密码。

## IntelliJ IDEA + Tomcat 运行步骤
1. IDEA 打开项目，等待 Maven 依赖下载。
2. 确认本地 JDK 设置为 21。
3. 在 MySQL 导入 `sql/init.sql`。
4. 按环境修改 `src/main/resources/druid.properties`。
5. 配置 Tomcat 10.x 本地运行，部署 `war exploded`。
6. 启动后访问：`http://localhost:8080/shiyan2/`

## 接口说明（统一 JSON Result）
- `POST /auth?action=login`
- `GET /auth?action=me`
- `POST /auth?action=logout`
- `GET /product?action=page&page=1&pageSize=10`
- `POST /cart?action=add`
- `GET /cart?action=page&page=1&pageSize=10`
- `POST /cart?action=updateQty`
- `POST /cart?action=check`
- `POST /cart?action=delete`
- `GET /checkout?action=summary`

返回格式：`{"code":0,"msg":"ok","data":...}`
