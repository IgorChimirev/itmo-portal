<?php
session_start();
require '../php/db.php';

if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
    die("Доступ запрещен. Только администраторы могут просматривать эту страницу.");
}
$action = $_GET['action'];
$user_id = $_GET['id'];

if ($action == 'approve') {
    // Получаем запрошенную роль
    $request = $conn->query("SELECT request FROM users WHERE id = $user_id")->fetch_assoc()['request'];
    
    // Обновляем роль и сбрасываем запрос
    $conn->query("UPDATE users SET role = '$request', request = NULL WHERE id = $user_id");
    echo "Роль обновлена!";
} 
elseif ($action == 'reject') {
    // Просто сбрасываем запрос
    $conn->query("UPDATE users SET request = NULL WHERE id = $user_id");
    echo "Запрос отклонён.";
}

header("Location: admin_page.php"); // Возвращаемся в админ-панель
?>