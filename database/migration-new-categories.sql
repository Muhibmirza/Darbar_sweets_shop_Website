USE darbar_sweets;

INSERT INTO categories (name, slug, image, description, sort_order, is_featured, is_active) VALUES
('Ice Creams', 'ice-creams', 'uploads/categories/ice-creams.jpg', 'Creamy scoops and frozen delights', 6, 1, 1),
('Samosa Rolls', 'samosa-rolls', 'uploads/categories/samosa-rolls.jpg', 'Crispy rolls and savoury bites', 7, 1, 1),
('Cakes and Pastries', 'cakes-and-pastries', 'uploads/categories/cakes-pastries.jpg', 'Fresh cakes and buttery pastries', 8, 1, 1),
('Kulfi & Falooda', 'kulfi-falooda', 'uploads/categories/kulfi-falooda.jpg', 'Traditional kulfi and falooda classics', 9, 1, 1),
('Dairy Milk Packed Items', 'dairy-milk-packed-items', 'uploads/categories/dairy-packed.jpg', 'Fresh dairy and packed milk essentials', 10, 1, 1),
('Chips and Snacks', 'chips-and-snacks', 'uploads/categories/chips-snacks.jpg', 'Crunchy snacks for every craving', 11, 1, 1)
ON DUPLICATE KEY UPDATE
  image = VALUES(image),
  description = VALUES(description),
  sort_order = VALUES(sort_order),
  is_featured = VALUES(is_featured),
  is_active = VALUES(is_active);

INSERT INTO products (category_id, name, slug, sku, short_description, price, compare_price, stock, image, is_featured, is_active) VALUES
((SELECT id FROM categories WHERE slug='ice-creams'), 'Mango Ice Cream', 'mango-ice-cream', 'DS-IC-01', 'Rich mango ice cream made with real fruit pulp.', 450, NULL, 40, 'uploads/categories/ice-creams.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='ice-creams'), 'Pistachio Kulfi Scoop', 'pistachio-kulfi-scoop', 'DS-IC-02', 'Creamy pistachio kulfi served as a generous scoop.', 520, 580, 35, 'uploads/products/darbar-originals/milk-peda.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='ice-creams'), 'Chocolate Sundae', 'chocolate-sundae', 'DS-IC-03', 'Chocolate ice cream topped with nuts and syrup.', 680, NULL, 30, 'uploads/products/darbar-originals/chocolate-coconut-ball.jpg', 0, 1),
((SELECT id FROM categories WHERE slug='samosa-rolls'), 'Chicken Samosa Roll', 'chicken-samosa-roll', 'DS-SR-01', 'Crispy roll filled with spiced chicken.', 180, NULL, 60, 'uploads/categories/samosa-rolls.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='samosa-rolls'), 'Aloo Samosa Roll', 'aloo-samosa-roll', 'DS-SR-02', 'Golden potato-filled samosa roll, freshly fried.', 120, NULL, 80, 'uploads/products/darbar-originals/patisa-barfi.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='samosa-rolls'), 'Spring Roll Pack', 'spring-roll-pack', 'DS-SR-03', 'Six-piece vegetable spring roll pack.', 350, 400, 45, 'uploads/products/darbar-originals/coconut-barfi.jpg', 0, 1),
((SELECT id FROM categories WHERE slug='cakes-and-pastries'), 'Black Forest Slice', 'black-forest-slice', 'DS-CP-01', 'Chocolate sponge with cherries and cream.', 420, NULL, 25, 'uploads/categories/cakes-pastries.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='cakes-and-pastries'), 'Chocolate Pastry', 'chocolate-pastry', 'DS-CP-02', 'Buttery pastry filled with chocolate cream.', 280, NULL, 40, 'uploads/products/darbar-originals/chocolate-coconut-sandwich.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='cakes-and-pastries'), 'Fruit Cake Slice', 'fruit-cake-slice', 'DS-CP-03', 'Light sponge with mixed fruit and cream.', 380, 420, 20, 'uploads/products/darbar-originals/pink-coconut-modak.jpg', 0, 1),
((SELECT id FROM categories WHERE slug='kulfi-falooda'), 'Malai Kulfi', 'malai-kulfi', 'DS-KF-01', 'Traditional malai kulfi on a stick.', 150, NULL, 50, 'uploads/categories/kulfi-falooda.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='kulfi-falooda'), 'Falooda Classic', 'falooda-classic', 'DS-KF-02', 'Rose falooda with vermicelli, jelly and ice cream.', 550, NULL, 30, 'uploads/products/darbar-originals/milk-peda.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='kulfi-falooda'), 'Pista Kulfi', 'pista-kulfi', 'DS-KF-03', 'Pistachio-rich kulfi slow frozen to perfection.', 180, NULL, 45, 'uploads/products/darbar-originals/pista-coconut-ladoo.jpg', 0, 1),
((SELECT id FROM categories WHERE slug='dairy-milk-packed-items'), 'Fresh Milk 1L', 'fresh-milk-1l', 'DS-DM-01', 'Pure packed milk, farm fresh.', 280, NULL, 100, 'uploads/categories/dairy-packed.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='dairy-milk-packed-items'), 'Yogurt Cup', 'yogurt-cup', 'DS-DM-02', 'Creamy dahi cup, perfect with meals.', 90, NULL, 80, 'uploads/products/darbar-originals/milk-barfi.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='dairy-milk-packed-items'), 'Fresh Cream 200ml', 'fresh-cream-200ml', 'DS-DM-03', 'Thick fresh cream for desserts and cooking.', 220, NULL, 40, 'uploads/products/darbar-originals/white-cham-cham.jpg', 0, 1),
((SELECT id FROM categories WHERE slug='chips-and-snacks'), 'Masala Chips', 'masala-chips', 'DS-CS-01', 'Crispy masala chips with a bold kick.', 80, NULL, 120, 'uploads/categories/chips-snacks.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='chips-and-snacks'), 'Nimko Mix', 'nimko-mix', 'DS-CS-02', 'Traditional nimko blend with lentils and spices.', 250, NULL, 70, 'uploads/products/darbar-originals/dry-fruit-seed-ladoo.jpg', 1, 1),
((SELECT id FROM categories WHERE slug='chips-and-snacks'), 'Peanut Chana', 'peanut-chana', 'DS-CS-03', 'Roasted peanut and chana snack mix.', 180, 200, 90, 'uploads/products/darbar-originals/coconut-ladoo.jpg', 0, 1)
ON DUPLICATE KEY UPDATE
  category_id = VALUES(category_id),
  short_description = VALUES(short_description),
  price = VALUES(price),
  compare_price = VALUES(compare_price),
  stock = VALUES(stock),
  image = VALUES(image),
  is_featured = VALUES(is_featured),
  is_active = VALUES(is_active);

INSERT INTO product_variants (product_id, label, price, stock)
SELECT p.id, '1 pc', p.price, p.stock FROM products p
WHERE p.slug IN ('mango-ice-cream','pistachio-kulfi-scoop','chocolate-sundae','chicken-samosa-roll','aloo-samosa-roll','spring-roll-pack','black-forest-slice','chocolate-pastry','fruit-cake-slice','malai-kulfi','falooda-classic','pista-kulfi','fresh-milk-1l','yogurt-cup','fresh-cream-200ml','masala-chips','nimko-mix','peanut-chana')
AND NOT EXISTS (SELECT 1 FROM product_variants pv WHERE pv.product_id = p.id);

INSERT INTO settings (setting_key, setting_value, setting_group) VALUES
('about_eyebrow', 'Our beginning', 'pages'),
('about_heading', 'Made with patience since 1989.', 'pages'),
('about_para1', 'Darbar began as one family counter in Karachi, where every tray was cooked in small batches and every customer was welcomed like a guest. More than three decades later, the scale has changed—but the standard has not.', 'pages'),
('about_para2', 'Our karigars balance recipes by aroma, colour and touch. Pure ghee, fresh milk, real nuts and whole spices come first. Shortcuts never do.', 'pages'),
('about_stat1_num', '35+', 'pages'),
('about_stat1_label', 'years of craft', 'pages'),
('about_stat2_num', '24h', 'pages'),
('about_stat2_label', 'fresh-batch promise', 'pages'),
('about_stat3_num', '4.9★', 'pages'),
('about_stat3_label', 'customer rating', 'pages'),
('about_values_heading', 'Old soul. Modern standard.', 'pages'),
('about_value1_title', 'Pure ingredients', 'pages'),
('about_value1_text', 'Real milk, ghee, nuts and spices—selected without compromise.', 'pages'),
('about_value2_title', 'Karigar craft', 'pages'),
('about_value2_text', 'Traditional technique, practiced patiently and passed forward.', 'pages'),
('about_value3_title', 'Gift-worthy care', 'pages'),
('about_value3_text', 'Every order is packed as though it is going to our own family.', 'pages'),
('about_image', 'assets/images/kaju-katli.png', 'pages'),
('contact_hero_text', 'We are here to make every celebration a little sweeter.', 'pages'),
('contact_store_title', 'Flagship store', 'pages'),
('contact_address', 'Main Tariq Road, PECHS\nKarachi, Pakistan', 'pages'),
('contact_phone', '+92 21 111 327 227', 'pages'),
('contact_whatsapp', '+92 300 327 2277', 'pages'),
('contact_hours', 'Monday–Sunday\n9:00 AM–11:00 PM', 'pages'),
('contact_map_text', 'Darbar Sweets · Tariq Road, Karachi', 'pages'),
('seo_site_description', 'Darbar Sweets — handcrafted mithai, halwa, ice cream, kulfi, cakes and celebration boxes delivered fresh across Karachi.', 'seo'),
('seo_keywords', 'darbar sweets, mithai karachi, halwa, kulfi, falooda, ice cream, samosa rolls, cakes pastries, gift boxes, pakistani sweets', 'seo')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);
