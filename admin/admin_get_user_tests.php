<?php
require_once '../config/db.php';
header('Content-Type: application/json');

if (empty($_GET['user_id'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Не указан ID пользователя']);
    exit;
}

try {
    $userId = $_GET['user_id'];
    
    // Получаем информацию о пользователе
    $stmt = $pdo->prepare("SELECT id, username, email FROM users WHERE id = ?");
    $stmt->execute([$userId]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$user) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'Пользователь не найден']);
        exit;
    }
    
    // Получаем список тестов и статус их прохождения
    $stmt = $pdo->prepare("
        SELECT t.id, t.test_name, t.test_code, 
               tr.completed, tr.completed_at, tr.result
        FROM tests t
        LEFT JOIN test_results tr ON tr.test_id = t.id AND tr.user_id = ?
        ORDER BY t.id
    ");
    $stmt->execute([$userId]);
    $tests = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Проверяем, все ли тесты пройдены
    $completedAll = true;
    foreach ($tests as $test) {
        if (!$test['completed']) {
            $completedAll = false;
            break;
        }
    }
    
    echo json_encode([
        'success' => true,
        'user' => $user,
        'tests' => $tests,
        'completed_all' => $completedAll
    ]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}