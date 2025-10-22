<?php
require_once '../config/db.php';
header('Content-Type: application/json');

try {
    $filters = [
        'username' => $_GET['username'] ?? '',
        'test' => $_GET['test'] ?? '',
        'status' => $_GET['status'] ?? ''
    ];
    
    // Запрос к базе данных с учетом фильтров
    $query = "SELECT u.id, u.username, u.email, 
                     COUNT(t.id) as total_tests,
                     SUM(CASE WHEN tr.completed = 1 THEN 1 ELSE 0 END) as completed_tests
              FROM users u
              LEFT JOIN test_results tr ON tr.user_id = u.id
              LEFT JOIN tests t ON t.id = tr.test_id
              WHERE 1=1";
    
    if (!empty($filters['username'])) {
        $query .= " AND u.username LIKE :username";
        $params[':username'] = '%' . $filters['username'] . '%';
    }
    
    if (!empty($filters['test'])) {
        $query .= " AND t.test_code = :test";
        $params[':test'] = $filters['test'];
    }
    
    $query .= " GROUP BY u.id";
    
    if (!empty($filters['status'])) {
        if ($filters['status'] === 'completed') {
            $query .= " HAVING completed_tests = total_tests";
        } elseif ($filters['status'] === 'incomplete') {
            $query .= " HAVING completed_tests < total_tests OR completed_tests IS NULL";
        }
    }
    
    $stmt = $pdo->prepare($query);
    $stmt->execute($params ?? []);
    
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(['success' => true, 'users' => $users]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}