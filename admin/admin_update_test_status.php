<?php
require_once '../config/db.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);

if (empty($data['user_id']) || empty($data['test_id'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Не указаны обязательные параметры']);
    exit;
}

try {
    $userId = $data['user_id'];
    $testId = $data['test_id'];
    $completed = !empty($data['completed']) ? 1 : 0;
    $now = date('Y-m-d H:i:s');
    
    // Обновляем или создаем запись
    $stmt = $pdo->prepare("
        INSERT INTO test_results (user_id, test_id, completed, completed_at)
        VALUES (:user_id, :test_id, :completed, :completed_at)
        ON DUPLICATE KEY UPDATE 
            completed = VALUES(completed),
            completed_at = IF(VALUES(completed) = 1, VALUES(completed_at), completed_at)
    ");
    
    $stmt->execute([
        ':user_id' => $userId,
        ':test_id' => $testId,
        ':completed' => $completed,
        ':completed_at' => $completed ? $now : null
    ]);
    
    echo json_encode(['success' => true]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}