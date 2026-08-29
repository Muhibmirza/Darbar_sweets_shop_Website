CREATE DATABASE IF NOT EXISTS darbar_sweets CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE darbar_sweets;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS order_items, payments, reviews, product_images, product_variants, orders, products, categories, coupons, testimonials, usp_blocks, banners, pages, settings, addresses, users, admins;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE users(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,email VARCHAR(190) UNIQUE,phone VARCHAR(30) UNIQUE,password VARCHAR(255) NOT NULL,is_blocked TINYINT(1) DEFAULT 0,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)ENGINE=InnoDB;
CREATE TABLE addresses(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,user_id INT UNSIGNED NOT NULL,label VARCHAR(50),address TEXT NOT NULL,city VARCHAR(80),area VARCHAR(100),is_default TINYINT(1) DEFAULT 0,FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE)ENGINE=InnoDB;
CREATE TABLE admins(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,email VARCHAR(190) NOT NULL UNIQUE,password VARCHAR(255) NOT NULL,role ENUM('super_admin','manager','editor') DEFAULT 'manager',is_active TINYINT(1) DEFAULT 1,last_login_at DATETIME,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)ENGINE=InnoDB;
CREATE TABLE categories(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,slug VARCHAR(120) UNIQUE,image VARCHAR(255),description TEXT,sort_order INT DEFAULT 0,is_featured TINYINT(1) DEFAULT 0,is_active TINYINT(1) DEFAULT 1)ENGINE=InnoDB;
CREATE TABLE products(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,category_id INT UNSIGNED,name VARCHAR(160) NOT NULL,slug VARCHAR(180) UNIQUE,sku VARCHAR(60) UNIQUE,short_description VARCHAR(255),description TEXT,ingredients TEXT,allergens TEXT,price DECIMAL(12,2) NOT NULL,compare_price DECIMAL(12,2),stock INT DEFAULT 0,image VARCHAR(255),is_featured TINYINT(1) DEFAULT 0,is_active TINYINT(1) DEFAULT 1,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,INDEX idx_product_category(category_id),FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE SET NULL)ENGINE=InnoDB;
CREATE TABLE product_images(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,product_id INT UNSIGNED NOT NULL,path VARCHAR(255) NOT NULL,sort_order INT DEFAULT 0,FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE)ENGINE=InnoDB;
CREATE TABLE product_variants(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,product_id INT UNSIGNED NOT NULL,label VARCHAR(80) NOT NULL,sku VARCHAR(60),price DECIMAL(12,2) NOT NULL,stock INT DEFAULT 0,FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE)ENGINE=InnoDB;
CREATE TABLE coupons(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,code VARCHAR(40) UNIQUE,type ENUM('percentage','fixed') NOT NULL,value DECIMAL(10,2) NOT NULL,min_order DECIMAL(10,2) DEFAULT 0,usage_limit INT,used_count INT DEFAULT 0,expires_at DATETIME,is_active TINYINT(1) DEFAULT 1)ENGINE=InnoDB;
CREATE TABLE orders(id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,order_number VARCHAR(40) UNIQUE NOT NULL,user_id INT UNSIGNED,guest_name VARCHAR(100),guest_email VARCHAR(190),guest_phone VARCHAR(30),delivery_address TEXT NOT NULL,city VARCHAR(80),area VARCHAR(100),notes TEXT,status ENUM('pending','processing','out_for_delivery','delivered','cancelled') DEFAULT 'pending',payment_method VARCHAR(40),coupon_id INT UNSIGNED,subtotal DECIMAL(12,2),delivery_fee DECIMAL(12,2) DEFAULT 0,discount DECIMAL(12,2) DEFAULT 0,total DECIMAL(12,2) NOT NULL,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,INDEX idx_order_status(status),INDEX idx_order_created(created_at),FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,FOREIGN KEY(coupon_id) REFERENCES coupons(id) ON DELETE SET NULL)ENGINE=InnoDB;
CREATE TABLE order_items(id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,order_id BIGINT UNSIGNED NOT NULL,product_id INT UNSIGNED,variant_id INT UNSIGNED,product_name VARCHAR(160) NOT NULL,variant_label VARCHAR(80),quantity INT NOT NULL,unit_price DECIMAL(12,2) NOT NULL,total DECIMAL(12,2) NOT NULL,FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE,FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE SET NULL,FOREIGN KEY(variant_id) REFERENCES product_variants(id) ON DELETE SET NULL)ENGINE=InnoDB;
CREATE TABLE payments(id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,order_id BIGINT UNSIGNED NOT NULL,transaction_id VARCHAR(190),method VARCHAR(40),amount DECIMAL(12,2),status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',payload JSON,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE)ENGINE=InnoDB;
CREATE TABLE reviews(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,product_id INT UNSIGNED NOT NULL,user_id INT UNSIGNED,rating TINYINT UNSIGNED NOT NULL,comment TEXT,is_approved TINYINT(1) DEFAULT 0,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL)ENGINE=InnoDB;
CREATE TABLE banners(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,title VARCHAR(160),subtitle VARCHAR(255),image VARCHAR(255),button_text VARCHAR(80),button_link VARCHAR(255),placement VARCHAR(60) DEFAULT 'home_slider',sort_order INT DEFAULT 0,is_active TINYINT(1) DEFAULT 1)ENGINE=InnoDB;
CREATE TABLE testimonials(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100),photo VARCHAR(255),rating TINYINT UNSIGNED DEFAULT 5,content TEXT,is_active TINYINT(1) DEFAULT 1,sort_order INT DEFAULT 0)ENGINE=InnoDB;
CREATE TABLE usp_blocks(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,title VARCHAR(100),description VARCHAR(255),icon VARCHAR(255),sort_order INT DEFAULT 0,is_active TINYINT(1) DEFAULT 1)ENGINE=InnoDB;
CREATE TABLE pages(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,slug VARCHAR(100) UNIQUE,title VARCHAR(160),content LONGTEXT,meta_title VARCHAR(180),meta_description VARCHAR(255),updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)ENGINE=InnoDB;
CREATE TABLE settings(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,setting_key VARCHAR(120) UNIQUE NOT NULL,setting_value LONGTEXT,setting_group VARCHAR(60) DEFAULT 'general')ENGINE=InnoDB;
INSERT INTO admins(name,email,password,role) VALUES('Darbar Administrator','admin@darbarsweets.pk','$2y$10$WRWyacd9OzH0U6vSTHnaWOca0YMITnwFEVYT4ocL4wJ6ehPEu299W','super_admin');
INSERT INTO categories(name,slug,image,description,sort_order,is_featured) VALUES
('Mithai','mithai','uploads/products/darbar-originals/gulab-jamun.jpg','Classic handcrafted mithai',1,1),
('Halwa','halwa','uploads/products/darbar-originals/patisa-barfi.jpg','Slow-cooked traditional halwa',2,1),
('Dry Fruit Sweets','dry-fruit-sweets','uploads/products/darbar-originals/dry-fruit-seed-ladoo.jpg','Nut-forward premium sweets',3,1),
('Bakery','bakery','uploads/products/darbar-originals/pink-coconut-modak.jpg','Fresh baked favourites',4,1),
('Gift Boxes','gift-boxes','uploads/products/darbar-originals/chocolate-coconut-sandwich.jpg','Curated celebration gifts',5,1),
('Ice Creams','ice-creams','uploads/categories/ice-creams.jpg','Creamy scoops and frozen delights',6,1),
('Samosa Rolls','samosa-rolls','uploads/categories/samosa-rolls.jpg','Crispy rolls and savoury bites',7,1),
('Cakes and Pastries','cakes-and-pastries','uploads/categories/cakes-pastries.jpg','Fresh cakes and buttery pastries',8,1),
('Kulfi & Falooda','kulfi-falooda','uploads/categories/kulfi-falooda.jpg','Traditional kulfi and falooda classics',9,1),
('Dairy Milk Packed Items','dairy-milk-packed-items','uploads/categories/dairy-packed.jpg','Fresh dairy and packed milk essentials',10,1),
('Chips and Snacks','chips-and-snacks','uploads/categories/chips-snacks.jpg','Crunchy snacks for every craving',11,1);
INSERT INTO products(category_id,name,slug,sku,short_description,price,compare_price,stock,image,is_featured) VALUES
(1,'Royal Kaju Katli','royal-kaju-katli','DS-KK-500','Silken cashew diamonds finished with silver leaf.',1850,2050,45,'uploads/products/supplied/product-14.jpg',1),
(1,'Motichoor Ladoo','motichoor-ladoo','DS-ML-500','Delicate saffron pearls shaped by hand.',960,NULL,60,'uploads/products/supplied/product-27.jpg',1),
(1,'Gulab Jamun','gulab-jamun','DS-GJ-500','Soft khoya dumplings steeped in cardamom syrup.',880,NULL,38,'uploads/products/supplied/product-04.jpg',1),
(1,'Pista Barfi','pista-barfi','DS-PB-500','Creamy pistachio barfi with roasted nuts.',1450,1600,31,'uploads/products/supplied/product-22.jpg',1),
(4,'Crisp Jalebi','crisp-jalebi','DS-JA-500','Saffron spirals, fried crisp and syrup-kissed.',720,NULL,50,'assets/images/jalebi.png',0),
(2,'Badam Halwa','badam-halwa','DS-BH-500','Almond-rich halwa slow cooked in pure ghee.',1250,NULL,24,'uploads/products/supplied/product-17.jpg',1),
(3,'Dry Fruit Roll','dry-fruit-roll','DS-DF-500','Dates, figs, pistachios and almonds — no added sugar.',1950,2200,20,'assets/images/dry-fruit-roll.png',1),
(5,'Darbar Celebration Box','celebration-box','DS-CB-01','A generous edit of our most-loved mithai.',2750,3000,18,'assets/images/mithai-velvet-hero.png',1),
(1,'Coconut Barfi','coconut-barfi','DS-CO-500','Fresh coconut and cardamom in a tender barfi.',820,NULL,40,'uploads/products/supplied/product-20.jpg',0),
(1,'Rasgulla','rasgulla','DS-RG-500','Light chenna dumplings in fragrant syrup.',780,NULL,35,'uploads/products/supplied/product-02.jpg',0),
(3,'Anjeer Square','anjeer-square','DS-AS-500','Fig and cashew squares with a soft bite.',2100,NULL,17,'uploads/products/supplied/product-05.jpg',0),
(2,'Sohan Halwa','sohan-halwa','DS-SH-500','A firm Multani classic with almonds and saffron.',1350,NULL,28,'uploads/products/supplied/product-23.jpg',0),
(4,'Almond Nan Khatai','almond-nan-khatai','DS-NK-500','Crumbly ghee biscuits topped with almonds.',750,NULL,55,'uploads/products/supplied/product-24.jpg',0),
(5,'Eid Mubarak Box','eid-mubarak-box','DS-EB-01','Festive mithai selection in signature packaging.',3200,3500,15,'uploads/products/supplied/product-01.jpg',1),
(5,'Corporate Gift Trunk','corporate-gift-trunk','DS-CG-01','Premium customisable gifting for teams and clients.',4950,NULL,12,'uploads/products/supplied/product-15.jpg',0);
INSERT INTO product_variants(product_id,label,price,stock) SELECT id,'500g',price,stock FROM products;
INSERT INTO product_variants(product_id,label,price,stock) SELECT id,'1kg',price*1.9,FLOOR(stock/2) FROM products WHERE category_id<>5;
INSERT INTO settings(setting_key,setting_value,setting_group) VALUES('site_name','Darbar Sweets','branding'),('logo','uploads/logo/darbar-sweets-logo.png','branding'),('color_primary','#006d63','branding'),('color_secondary','#ef8c00','branding'),('announcement','Complimentary delivery across Karachi on orders above Rs. 2,000','branding'),('hero_heading','Tradition, wrapped in sweetness.','homepage'),('hero_subtitle','Small-batch mithai made fresh daily.','homepage'),('hero_intact','assets/images/mithai-velvet-hero.png','animation'),('free_delivery_threshold','2000','commerce'),('contact_phone','+92 21 111 327 227','contact'),('contact_email','hello@darbarsweets.pk','contact'),('footer_about','Handcrafted mithai and thoughtful gifting from the heart of Karachi.','branding');
INSERT INTO banners(title,subtitle,image,button_text,button_link,placement,sort_order,is_active) VALUES
('Celebrating Taste With Elegance','','uploads/banners/hero-taste-elegance.jpg','','?page=shop','home_slider',1,1),
('Wahi Riwayati Mithas','','uploads/banners/desserts-riwayati-mithas.jpg','','?page=shop&category=Halwa','home_slider',2,1),
('Premium Chocolate For Happy Moments','','uploads/banners/premium-chocolate.jpg','','?page=shop&category=Bakery','home_slider',3,1),
('Khushi Ke Lamho Ki Ronaq','','uploads/banners/mithai-lamho-ki-ronaq.jpg','','?page=shop&category=Mithai','home_slider',4,1);
INSERT INTO testimonials(name,rating,content) VALUES('Ayesha K.',5,'Beautifully packed and genuinely fresh.'),('Hammad R.',5,'Darbar handled our wedding boxes flawlessly.'),('Sana M.',5,'That old-Karachi taste, delivered to the door.');
INSERT INTO usp_blocks(title,description,sort_order) VALUES('Pure ingredients','No shortcuts, ever.',1),('Made fresh daily','Small batches every morning.',2),('Carefully packed','Arrives beautifully.',3),('Karachi delivery','Fast and reliable.',4);
-- Seed customer password is "password"
INSERT INTO users(name,email,phone,password) VALUES('Ayesha Khan','ayesha@example.com','03001234567','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.');
INSERT INTO orders(order_number,user_id,guest_name,guest_email,guest_phone,delivery_address,city,status,payment_method,subtotal,total) VALUES('DS-2026-001',1,'Ayesha Khan','ayesha@example.com','03001234567','PECHS Block 2','Karachi','delivered','cod',2810,2810),('DS-2026-002',NULL,'Hamza Ali','hamza@example.com','03007654321','DHA Phase 6','Karachi','processing','jazzcash',2750,2750),('DS-2026-003',NULL,'Sara Ahmed','sara@example.com','03111234567','Clifton Block 5','Karachi','pending','cod',1850,1850);

-- Darbar's supplied 2026 product photography (no third-party catalog images).
UPDATE products SET slug=CONCAT('darbar-temp-',id);
UPDATE products SET name='Milk Barfi',slug='milk-barfi',category_id=1,image='uploads/products/darbar-originals/milk-barfi.jpg',short_description='Classic milk barfi with a soft, rich texture.',is_featured=1 WHERE id=1;
UPDATE products SET name='Patisa Barfi',slug='patisa-barfi',category_id=1,image='uploads/products/darbar-originals/patisa-barfi.jpg',short_description='Flaky golden patisa prepared in the Darbar tradition.',is_featured=1 WHERE id=2;
UPDATE products SET name='Gulab Jamun',slug='gulab-jamun',category_id=1,image='uploads/products/darbar-originals/gulab-jamun.jpg',short_description='Soft khoya dumplings steeped in fragrant syrup.',is_featured=1 WHERE id=3;
UPDATE products SET name='Coconut Barfi',slug='coconut-barfi',category_id=1,image='uploads/products/darbar-originals/coconut-barfi.jpg',short_description='Creamy coconut barfi cut into generous squares.',is_featured=1 WHERE id=4;
UPDATE products SET name='Pink Coconut Modak',slug='pink-coconut-modak',category_id=1,image='uploads/products/darbar-originals/pink-coconut-modak.jpg',short_description='Delicate pink and white coconut modak.',is_featured=1 WHERE id=5;
UPDATE products SET name='Brown Cham Cham',slug='brown-cham-cham',category_id=1,image='uploads/products/darbar-originals/brown-cham-cham.jpg',is_featured=1 WHERE id=6;
UPDATE products SET name='Dry Fruit Seed Ladoo',slug='dry-fruit-seed-ladoo',category_id=3,image='uploads/products/darbar-originals/dry-fruit-seed-ladoo.jpg',is_featured=1 WHERE id=7;
UPDATE products SET name='Chocolate Coconut Sandwich',slug='chocolate-coconut-sandwich',category_id=1,image='uploads/products/darbar-originals/chocolate-coconut-sandwich.jpg',is_featured=1 WHERE id=8;
UPDATE products SET name='Pista Coconut Ladoo',slug='pista-coconut-ladoo',category_id=1,image='uploads/products/darbar-originals/pista-coconut-ladoo.jpg',is_featured=0 WHERE id=9;
UPDATE products SET name='White Cham Cham',slug='white-cham-cham',category_id=1,image='uploads/products/darbar-originals/white-cham-cham.jpg',is_featured=0 WHERE id=10;
UPDATE products SET name='Coconut Cham Cham',slug='coconut-cham-cham',category_id=1,image='uploads/products/darbar-originals/coconut-cham-cham.jpg',is_featured=0 WHERE id=11;
UPDATE products SET name='Milk Peda',slug='milk-peda',category_id=1,image='uploads/products/darbar-originals/milk-peda.jpg',is_featured=0 WHERE id=12;
UPDATE products SET name='Coconut Ladoo',slug='coconut-ladoo',category_id=1,image='uploads/products/darbar-originals/coconut-ladoo.jpg',is_featured=0 WHERE id=13;
UPDATE products SET name='Chocolate Coconut Ball',slug='chocolate-coconut-ball',category_id=1,image='uploads/products/darbar-originals/chocolate-coconut-ball.jpg',is_featured=1 WHERE id=14;
UPDATE products SET name='Kala Jamun',slug='kala-jamun',category_id=1,image='uploads/products/darbar-originals/kala-jamun.jpg',is_featured=0 WHERE id=15;
UPDATE categories SET image=CASE id WHEN 1 THEN 'uploads/products/darbar-originals/gulab-jamun.jpg' WHEN 2 THEN 'uploads/products/darbar-originals/patisa-barfi.jpg' WHEN 3 THEN 'uploads/products/darbar-originals/dry-fruit-seed-ladoo.jpg' WHEN 4 THEN 'uploads/products/darbar-originals/pink-coconut-modak.jpg' WHEN 5 THEN 'uploads/products/darbar-originals/chocolate-coconut-sandwich.jpg' ELSE image END;
