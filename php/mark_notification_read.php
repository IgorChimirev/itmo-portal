<?php
session_start();
require_once 'db.php';

if (isset($_POST['notification_id']) && is_numeric($_POST['notification_id'])) {
    $notification_id = $_POST['notification_id'];
    $user_id = $_SESSION['user_id'] ?? null;
    
    if ($user_id) {
        // Проверяем, что уведомление принадлежит текущему пользователю
        $stmt = $conn->prepare("UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?");
        $stmt->bind_param("ii", $notification_id, $user_id);
        $stmt->execute();
        $stmt->close();
    }
}

echo json_encode(['success' => true]);
?>