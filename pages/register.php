<?php
session_start();
require '../php/db.php'; 

$error_message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);
    $email = trim($_POST['email']); 
    $role = isset($_POST['role']) ? trim($_POST['role']) : 'user';
    $role_request = !empty($_POST['role_request']) ? $_POST['role_request'] : NULL;
    

    if (empty($username) || empty($password) || empty($email)) {
        $error_message = "Ошибка: имя пользователя, пароль или email не могут быть пустыми.";
    }
    
    if (!in_array($role, ['user', 'expert'])) {
        $error_message = "Ошибка: недопустимая роль пользователя.";
    }
    
    if (empty($error_message)) {
        $stmt = $conn->prepare("SELECT id FROM users WHERE username = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->store_result();
        
        if ($stmt->num_rows > 0) {
            $error_message = "Ошибка: пользователь с таким именем уже существует.";
        }
        $stmt->close();
    }

    if (empty($error_message)) {
        $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $error_message = "Ошибка: этот email уже зарегистрирован.";
        }
        $stmt->close();
    }
    
    if (empty($error_message)) {
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
        
        // Записываем в БД
$stmt = $conn->prepare("INSERT INTO users (username, email, password, request, role) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("sssss", $username, $email, $hashed_password, $role_request, $role);
        
        if ($stmt->execute()) {
            header("Location: ../pages/registr.html");
            exit;
        } else {
            $error_message = "Ошибка при регистрации: " . $stmt->error;
        }
        
        $stmt->close();
    }
} else {
    $error_message = "Некорректный запрос.";
}

if (!empty($error_message)) {
    $_SESSION['error_message'] = $error_message;
}

header("Location: ../pages/registr.html");
exit;
?>