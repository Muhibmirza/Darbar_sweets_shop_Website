<?php
require dirname(__DIR__) . '/includes/bootstrap.php';
header('Content-Type: application/json');
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); exit; }
verify_csrf();
$data = json_decode(file_get_contents('php://input'), true) ?: $_POST;
$id = max(1, (int)($data['id'] ?? 0));
$action = $data['action'] ?? 'add';
$_SESSION['cart'] ??= [];
if ($action === 'remove') unset($_SESSION['cart'][$id]);
else {
    $qty = max(1, min(99, (int)($data['qty'] ?? 1)));
    if ($action === 'set') {
        if ($qty < 1) unset($_SESSION['cart'][$id]); else $_SESSION['cart'][$id]['qty'] = $qty;
    } else {
        if (!isset($_SESSION['cart'][$id])) $_SESSION['cart'][$id] = [
            'id'=>$id,'name'=>substr(strip_tags((string)($data['name']??'Darbar Sweet')),0,80),
            'price'=>(float)($data['price']??0),'image'=>filter_var($data['image']??'',FILTER_SANITIZE_URL),'qty'=>0
        ];
        $_SESSION['cart'][$id]['qty'] += $qty;
    }
}
$count = array_sum(array_column($_SESSION['cart'],'qty'));
$subtotal = array_sum(array_map(fn($x)=>$x['price']*$x['qty'],$_SESSION['cart']));
echo json_encode(['ok'=>true,'cart'=>array_values($_SESSION['cart']),'count'=>$count,'subtotal'=>$subtotal]);
