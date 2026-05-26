CREATE DATABASE IF NOT EXISTS mvc_shop1 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE mvc_shop1;

DROP TABLE IF EXISTS cart_item;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL UNIQUE,
    password CHAR(32) NOT NULL,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(128) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    checked TINYINT(1) NOT NULL DEFAULT 1,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES `user`(id),
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES product(id),
    CONSTRAINT uk_cart_user_product UNIQUE (user_id, product_id),
    CONSTRAINT chk_cart_quantity CHECK (quantity >= 1)
);

INSERT INTO `user` (username, password) VALUES
-- password md5 for plain text "123456"
('student', 'e10adc3949ba59abbe56e057f20f883e');

INSERT INTO product (name, price, stock) VALUES
('笔记本电脑', 4999.00, 30),
('机械键盘', 299.00, 80),
('无线鼠标', 99.00, 120),
('27寸显示器', 1299.00, 40),
('固态硬盘1TB', 499.00, 60),
('移动硬盘2TB', 459.00, 50),
('Type-C扩展坞', 189.00, 90),
('蓝牙耳机', 239.00, 100),
('路由器AX3000', 329.00, 55),
('手机支架', 29.00, 300),
('高清摄像头', 199.00, 70),
('桌面音箱', 159.00, 65),
('USB风扇', 39.00, 200),
('办公椅', 699.00, 25),
('护眼台灯', 89.00, 140),
('平板电脑', 2199.00, 35),
('智能手环', 169.00, 85),
('电动牙刷', 149.00, 95),
('咖啡机', 559.00, 28),
('保温杯', 59.00, 180),
('打印机', 899.00, 33),
('扫描仪', 1099.00, 22),
('电竞鼠标垫', 49.00, 210),
('便携电源', 199.00, 76);
