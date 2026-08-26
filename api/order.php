<?php
require dirname(__DIR__) . '/includes/bootstrap.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { header('Location: ../'); exit; }
verify_csrf();
if (empty($_SESSION['cart'])) { header('Location: ../?page=cart'); exit; }
$orderNo = 'DS-' . date('ymd') . '-' . random_int(1000,9999);
if ($pdo) {
 try {
  $pdo->beginTransaction();
  $total=array_sum(array_map(fn($x)=>$x['price']*$x['qty'],$_SESSION['cart']));
  $q=$pdo->prepare("INSERT INTO orders(order_number,guest_name,guest_email,guest_phone,delivery_address,city,notes,status,payment_method,subtotal,total) VALUES(?,?,?,?,?,?,?,'pending',?,?,?)");
  $q->execute([$orderNo,$_POST['name'],$_POST['email'],$_POST['phone'],$_POST['address'],$_POST['city'],$_POST['notes']??'',$_POST['payment'],$total,$total]);
  $oid=(int)$pdo->lastInsertId(); $line=$pdo->prepare("INSERT INTO order_items(order_id,product_id,product_name,quantity,unit_price,total) VALUES(?,?,?,?,?,?)");
  foreach($_SESSION['cart'] as $i) $line->execute([$oid,$i['id'],$i['name'],$i['qty'],$i['price'],$i['qty']*$i['price']]);
  $pdo->commit();
 } catch(Throwable $e) { if($pdo->inTransaction())$pdo->rollBack(); http_response_code(500); exit('Order could not be placed.'); }
}
$_SESSION['cart']=[]; ?><!doctype html><html><head><meta charset="utf-8"><link rel="stylesheet" href="../assets/css/style.css"></head><body><section class="page-hero"><div class="container"><span class="eyebrow">Order confirmed</span><h1>Shukriya. It’s being prepared.</h1><p>Your order ID is <strong><?=e($orderNo)?></strong>. We’ll contact you shortly with delivery timing.</p><a class="btn" href="../">Return home</a></div></section></body></html>
