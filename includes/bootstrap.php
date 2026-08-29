<?php
declare(strict_types=1);

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_name('darbar_customer');
    session_start();
}

define('BASE_PATH', dirname(__DIR__));
define('BASE_URL', rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '')), '/admin'));

require_once __DIR__ . '/db.php';

function e(?string $value): string { return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8'); }
function url(string $path = ''): string {
    $root = str_replace('/admin', '', rtrim(dirname($_SERVER['SCRIPT_NAME'] ?? ''), '/'));
    return ($root === '/' ? '' : $root) . '/' . ltrim($path, '/');
}
function csrf_token(): string {
    $_SESSION['csrf'] ??= bin2hex(random_bytes(32));
    return $_SESSION['csrf'];
}
function csrf_field(): string { return '<input type="hidden" name="csrf" value="' . e(csrf_token()) . '">'; }
function verify_csrf(): void {
    if (!hash_equals($_SESSION['csrf'] ?? '', (string)($_POST['csrf'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? ''))) {
        http_response_code(419); exit('Security token expired. Refresh and try again.');
    }
}
function setting(string $key, string $fallback = ''): string {
    global $pdo;
    if (!$pdo) return $fallback;
    static $cache = [];
    if (!array_key_exists($key, $cache)) {
        $q = $pdo->prepare('SELECT setting_value FROM settings WHERE setting_key = ? LIMIT 1');
        $q->execute([$key]); $cache[$key] = $q->fetchColumn() ?: $fallback;
    }
    return (string)$cache[$key];
}
function products(string $query = '', string $category = ''): array {
    global $pdo;
    if ($pdo) {
        try {
            $sql="SELECT p.*, c.name category FROM products p LEFT JOIN categories c ON c.id=p.category_id WHERE p.is_active=1";
            $params=[];
            if($query!==''){$sql.=" AND (p.name LIKE ? OR p.short_description LIKE ? OR p.description LIKE ?)";$like='%'.$query.'%';$params=[$like,$like,$like];}
            if($category!==''){$sql.=" AND c.name = ?";$params[]=$category;}
            $sql.=" ORDER BY p.is_featured DESC,p.id DESC LIMIT 48";
            $q=$pdo->prepare($sql);$q->execute($params);return $q->fetchAll();
        } catch (Throwable $exception) {}
    }
    $names = ['Royal Kaju Katli','Motichoor Ladoo','Gulab Jamun','Pista Barfi','Crisp Jalebi','Badam Halwa','Dry Fruit Roll','Celebration Box'];
    $images=['kaju-katli.png','motichoor-ladoo.png','gulab-jamun.png','dry-fruit-roll.png','jalebi.png','badam-halwa.png','dry-fruit-roll.png','mithai-velvet-hero.png'];
    return array_map(fn($n,$i)=>['id'=>$i+1,'name'=>$n,'slug'=>strtolower(str_replace(' ','-',$n)),'category'=>['Mithai','Mithai','Mithai','Mithai','Bakery','Halwa','Dry Fruit','Gift Boxes'][$i],'short_description'=>'Handcrafted today with pure ingredients and traditional recipes.','price'=>[1850,960,880,1450,720,1250,1950,2750][$i],'compare_price'=>[2050,0,0,1600,0,0,2200,3000][$i],'image'=>'assets/images/'.$images[$i]], $names, array_keys($names));
}
function product_by_id(int $id): ?array {
    global $pdo;
    if(!$pdo)return null;
    $q=$pdo->prepare("SELECT p.*,c.name category FROM products p LEFT JOIN categories c ON c.id=p.category_id WHERE p.id=? AND p.is_active=1 LIMIT 1");
    $q->execute([$id]);$product=$q->fetch();
    if(!$product)return null;
    $q=$pdo->prepare("SELECT * FROM product_variants WHERE product_id=? ORDER BY price");$q->execute([$id]);$product['variants']=$q->fetchAll();
    $q=$pdo->prepare("SELECT path FROM product_images WHERE product_id=? ORDER BY sort_order,id");$q->execute([$id]);$product['images']=$q->fetchAll(PDO::FETCH_COLUMN);
    return $product;
}
function customer(): ?array {
    global $pdo;
    if(empty($_SESSION['user_id'])||!$pdo)return null;
    $q=$pdo->prepare("SELECT id,name,email,phone,created_at FROM users WHERE id=? AND is_blocked=0");$q->execute([$_SESSION['user_id']]);
    return $q->fetch() ?: null;
}
function active_banners(string $placement = 'home_slider'): array {
    global $pdo;
    if (!$pdo) return [];
    try {
        $q=$pdo->prepare('SELECT * FROM banners WHERE placement=? AND is_active=1 ORDER BY sort_order,id');
        $q->execute([$placement]); return $q->fetchAll();
    } catch (Throwable $exception) { return []; }
}
function active_categories(): array {
    global $pdo;
    if (!$pdo) return [];
    try {
        return $pdo->query('SELECT * FROM categories WHERE is_active=1 ORDER BY is_featured DESC,sort_order,id')->fetchAll();
    } catch (Throwable $exception) { return []; }
}
function category_by_name(string $name): ?array {
    global $pdo;
    if ($pdo && $name !== '') {
        try {
            $q = $pdo->prepare('SELECT * FROM categories WHERE name = ? AND is_active = 1 LIMIT 1');
            $q->execute([$name]);
            $row = $q->fetch();
            if ($row) return $row;
        } catch (Throwable $exception) {}
    }
    return null;
}
function seo_meta(string $page, array $context = []): array {
    $site = setting('site_name', 'Darbar Sweets');
    $defaultDescription = setting('seo_site_description', 'Darbar Sweets — handcrafted mithai, halwa and celebration boxes delivered fresh.');
    $keywords = setting('seo_keywords', 'darbar sweets, mithai karachi, halwa, kulfi, gift boxes');
    $logo = setting('logo', 'uploads/logo/darbar-sweets-logo.png');
    $titles = [
        'home' => 'Premium Mithai, Made Fresh Daily',
        'shop' => ($context['category'] ?? '') ?: 'Shop Mithai',
        'product' => $context['product_name'] ?? 'Product Details',
        'cart' => 'Your Cart',
        'checkout' => 'Checkout',
        'login' => 'Customer Login',
        'register' => 'Create Account',
        'account' => 'My Account',
        'about' => 'Our Story',
        'contact' => 'Contact Us',
        'track' => 'Track Your Order',
    ];
    $title = $titles[$page] ?? ucfirst($page);
    $description = $defaultDescription;
    $image = $logo;
    if ($page === 'product' && !empty($context['product'])) {
        $product = $context['product'];
        $title = $product['name'];
        $description = trim((string)($product['short_description'] ?: $product['description'] ?: $defaultDescription));
        if (!empty($product['image'])) $image = $product['image'];
    } elseif ($page === 'shop' && !empty($context['category_row']['description'])) {
        $description = (string)$context['category_row']['description'];
        if (!empty($context['category_row']['image'])) $image = (string)$context['category_row']['image'];
    } elseif ($page === 'about') {
        $description = trim(setting('about_para1', $defaultDescription));
    } elseif ($page === 'contact') {
        $description = trim(setting('contact_hero_text', 'Contact Darbar Sweets in Karachi for orders, gifting and delivery support.'));
    }
    return [
        'title' => $title,
        'description' => mb_substr($description, 0, 160),
        'keywords' => $keywords,
        'image' => $image,
        'canonical' => $page === 'home' ? url() : url('?page=' . $page . ($page === 'product' && !empty($context['product']['id']) ? '&id=' . $context['product']['id'] : '') . ($page === 'shop' && !empty($context['category']) ? '&category=' . urlencode($context['category']) : '')),
    ];
}
