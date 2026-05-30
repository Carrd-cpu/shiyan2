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
    img VARCHAR(255) NOT NULL DEFAULT '/assets/products/placeholder.png',
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

INSERT INTO product (name, img, price, stock) VALUES
('笔记本电脑', '/assets/products/p01.png', 4999.00, 30),
('机械键盘', '/assets/products/p02.png', 299.00, 80),
('无线鼠标', '/assets/products/p03.png', 99.00, 120),
('27寸显示器', '/assets/products/p04.png', 1299.00, 40),
('固态硬盘1TB', '/assets/products/p05.png', 499.00, 60),
('移动硬盘2TB', '/assets/products/p06.png', 459.00, 50),
('Type-C扩展坞', '/assets/products/p07.png', 189.00, 90),
('蓝牙耳机', '/assets/products/p08.png', 239.00, 100),
('路由器AX3000', '/assets/products/p09.png', 329.00, 55),
('手机支架', '/assets/products/p10.png', 29.00, 300),
('高清摄像头', '/assets/products/p11.png', 199.00, 70),
('桌面音箱', '/assets/products/p12.png', 159.00, 65),
('USB风扇', '/assets/products/p13.png', 39.00, 200),
('办公椅', '/assets/products/p14.png', 699.00, 25),
('护眼台灯', '/assets/products/p15.png', 89.00, 140),
('平板电脑', '/assets/products/p16.png', 2199.00, 35),
('智能手环', '/assets/products/p17.png', 169.00, 85),
('电动牙刷', '/assets/products/p18.png', 149.00, 95),
('咖啡机', '/assets/products/p19.png', 559.00, 28),
('保温杯', '/assets/products/p20.png', 59.00, 180),
('打印机', '/assets/products/p21.png', 899.00, 33),
('扫描仪', '/assets/products/p22.png', 1099.00, 22),
('电竞鼠标垫', '/assets/products/p23.png', 49.00, 210),
('便携电源', '/assets/products/p24.png', 199.00, 76);
