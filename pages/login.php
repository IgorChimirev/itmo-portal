<?php
session_start();
require __DIR__ . '/../php/db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Получаем пользователя из базы данных с использованием PDO
    $sql = "SELECT * FROM users WHERE username = ?";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // Проверяем пароль
        if (password_verify($password, $user['password'])) {
            // Пароль верный, сохраняем данные пользователя в сессии
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['username'] = $user['username'];
            $_SESSION['user_role'] = $user['role']; // Сохраняем роль пользователя
            
            // Перенаправляем в зависимости от роли
            switch ($user['role']) {
                case 'admin':
                    header("Location: ../pages/admin_page.php");
                    break;
                case 'expert':
                    header("Location: ../pages/expert_page.php");
                    break;
                case 'consultant':
                    header("Location: ../consultant/consultant_panel.php");
                    break;
                default:
                    header("Location: ../index.php");
            }
            exit();
        } else {
            $error = "Неверный пароль!";
        }
    } else {
        $error = "Пользователь не найден!";
    }
}
?>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход - ITMO Portal</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="text-center">Вход в систему</h4>
                    </div>
                    <div class="card-body">
                        <?php if (isset($error)): ?>
                            <div class="alert alert-danger"><?php echo $error; ?></div>
                        <?php endif; ?>
                        
                        <form method="POST" action="">
                            <div class="form-group">
                                <label for="username">Имя пользователя:</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Пароль:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Войти</button>
                        </form>
                        
                        <div class="text-center mt-3">
                            <a href="../index.php">На главную</a> | 
                            <a href="register.html">Зарегистрироваться</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>