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

$days = [];
for ($i = 6; $i >= 0; $i--) {
    $key = date('Y-m-d', strtotime('-'.$i.' days'));
    $days[$key] = ['label' => date('D', strtotime($key)), 'revenue' => 0.0, 'orders' => 0];
}

try {
    $stmt = $pdo->query("SELECT DATE(created_at) sale_date, COUNT(*) orders, COALESCE(SUM(total),0) revenue FROM orders WHERE created_at >= CURDATE() - INTERVAL 6 DAY AND status <> 'cancelled' GROUP BY DATE(created_at)");
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
        if (isset($days[$row['sale_date']])) {
            $days[$row['sale_date']]['orders'] = (int)$row['orders'];
            $days[$row['sale_date']]['revenue'] = (float)$row['revenue'];
        }
    }
    $statusRows = $pdo->query('SELECT status, COUNT(*) total FROM orders GROUP BY status')->fetchAll(PDO::FETCH_ASSOC);
    $statuses = [];
    foreach ($statusRows as $row) $statuses[$row['status']] = (int)$row['total'];
    echo json_encode(['days' => array_values($days), 'statuses' => $statuses], JSON_UNESCAPED_UNICODE);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Analytics are temporarily unavailable.']);
}
