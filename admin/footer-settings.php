<?php
declare(strict_types=1);
session_name('darbar_admin');
session_start();
require_once __DIR__.'/../includes/db.php';
header('Content-Type: application/json; charset=utf-8');
if (empty($_SESSION['admin_id'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}
$defaults = [
    'footer_about' => 'Handcrafted Pakistani sweets made fresh for every celebration.',
    'footer_location' => 'Main Tariq Road, Karachi, Pakistan',
    'footer_hours' => 'Open daily: 10:00 AM - 11:00 PM',
    'footer_phone' => '+92 300 1234567',
    'footer_copyright' => 'Darbar Sweets. All rights reserved.',
    'footer_facebook' => '', 'footer_instagram' => '', 'footer_whatsapp' => '',
    'payment_visa' => '1', 'payment_mastercard' => '1', 'payment_jazzcash' => '1', 'payment_easypaisa' => '1'
];
$rows = $pdo->query("SELECT setting_key, setting_value FROM settings WHERE setting_group = 'footer'")->fetchAll(PDO::FETCH_KEY_PAIR);
echo json_encode(array_merge($defaults, $rows), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
