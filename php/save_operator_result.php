<?php
session_start();
header('Content-Type: application/json');

// Проверка авторизации
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Необходима авторизация']);
    exit;
}

$host = 'localhost';
$dbname = 'it_portal';
$username = 'root';
$password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Ошибка подключения к базе данных: ' . $e->getMessage()]);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

// Проверяем обязательные поля
if (isset($data['score'], $data['duration'])) {
    $userId = $_SESSION['user_id'];
    $testName = $data['test_name'] ?? 'Совмещённая операторская деятельность';
    $score = $data['score'];
    $duration = $data['duration'];
    $speedMultiplier = $data['speed_multiplier'] ?? null;

    try {
        $stmt = $conn->prepare("INSERT INTO operator_activity_results 
            (user_id, test_name, score, duration, speed_multiplier) 
            VALUES 
            (:user_id, :test_name, :score, :duration, :speed_multiplier)");
        
        $stmt->bindParam(':user_id', $userId);
        $stmt->bindParam(':test_name', $testName);
        $stmt->bindParam(':score', $score);
        $stmt->bindParam(':duration', $duration);
        $stmt->bindParam(':speed_multiplier', $speedMultiplier);

        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Результат успешно сохранен']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Ошибка при сохранении результата']);
        }
    } catch (PDOException $e) {
        echo json_encode(['status' => 'error', 'message' => 'Ошибка базы данных: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Неверные данные: отсутствуют обязательные поля']);
}
?>