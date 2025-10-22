<?php
session_start();

// Включаем отображение ошибок
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Подключение к базе данных
require_once '../php/db.php';

// Проверка роли пользователя
if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'consultant') {
    header('Location: ../index.php');
    exit();
}

// Обработка формы назначения тестов
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['respondent_id']) && isset($_POST['tests'])) {
    // ... (код обработки формы остается без изменений)
}

// Получаем список всех пользователей
$users = [];
$sql = "SELECT id, username FROM users WHERE role = 'user'";
$result = $conn->query($sql);
if ($result) {
    $users = $result->fetch_all(MYSQLI_ASSOC);
}

// Получаем выбранных пользователей для динамики
$selected_user_ids = isset($_GET['user_ids_for_dynamics']) ? (array)$_GET['user_ids_for_dynamics'] : [];
$selected_user_ids = array_filter($selected_user_ids, 'is_numeric');

// Получаем данные для графиков
$test_data = [];
if (!empty($selected_user_ids)) {
    // Получаем результаты тестов для выбранных пользователей
    $placeholders = implode(',', array_fill(0, count($selected_user_ids), '?'));
    $sql = "SELECT tr.*, u.username 
            FROM test_results tr
            JOIN users u ON tr.user_id = u.id
            WHERE tr.user_id IN ($placeholders)
            ORDER BY tr.test_name, tr.user_id, tr.created_at ASC";
    
    $stmt = $conn->prepare($sql);
    $types = str_repeat('i', count($selected_user_ids));
    $stmt->bind_param($types, ...$selected_user_ids);
    $stmt->execute();
    $results = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    
    // Группируем данные по тестам и пользователям
    foreach ($results as $row) {
        $test_name = $row['test_name'];
        $user_id = $row['user_id'];
        
        if (!isset($test_data[$test_name][$user_id])) {
            $test_data[$test_name][$user_id] = [
                'username' => $row['username'],
                'results' => []
            ];
        }
        $test_data[$test_name][$user_id]['results'][] = $row;
    }
}
?>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Панель консультанта</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { padding-top: 60px; }
        .chart-container { height: 400px; margin-bottom: 30px; }
        .user-color { display: inline-block; width: 12px; height: 12px; border-radius: 50%; margin-right: 5px; }
    </style>
</head>
<body>
    <!-- Навигационная панель -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
        <a class="navbar-brand" href="../index.php">ITMO Portal</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <span class="navbar-text mr-2"><?= htmlspecialchars($_SESSION['username']) ?></span>
                    <a href="../pages/logout.php" class="btn btn-outline-dark">Выйти</a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container mt-5 pt-5">
        <h1 class="text-center mb-4">Панель консультанта</h1>

        <!-- Форма выбора пользователей -->
        <div class="card mb-4">
            <div class="card-header">
                <h3>Сравнение динамики</h3>
            </div>
            <div class="card-body">
                <form method="GET" class="mb-4">
                    <div class="form-row">
                        <div class="col-md-9">
                            <select name="user_ids_for_dynamics[]" class="form-control select2" multiple required>
                                <?php foreach ($users as $user): ?>
                                    <option value="<?= $user['id'] ?>" <?= in_array($user['id'], $selected_user_ids) ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($user['username']) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary btn-block">Показать</button>
                        </div>
                    </div>
                </form>

                <!-- Графики -->
                <?php if (!empty($selected_user_ids) && !empty($test_data)): ?>
                    <?php foreach ($test_data as $test_name => $users_data): 
                        // Проверяем, есть ли у кого-то достаточно данных
                        $has_enough_data = false;
                        foreach ($users_data as $user_data) {
                            if (count($user_data['results']) > 1) {
                                $has_enough_data = true;
                                break;
                            }
                        }
                        if (!$has_enough_data) continue;
                        
                        $chart_id = 'chart-' . md5($test_name . implode('-', $selected_user_ids));
                    ?>
                        <div class="mb-5">
                            <h4><?= htmlspecialchars($test_name) ?></h4>
                            <div class="chart-container">
                                <canvas id="<?= $chart_id ?>"></canvas>
                            </div>
                            
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    const ctx = document.getElementById('<?= $chart_id ?>');
                                    if (!ctx) return;
                                    
                                    // Цвета для разных пользователей
                                    const colors = [
                                        '#4BC0C0', '#FF6384', '#36A2EB', '#FFCE56', '#9966FF'
                                    ];
                                    
                                    // Собираем все уникальные даты
                                    const allDates = [];
                                    <?php
                                    $dates = [];
                                    foreach ($users_data as $user_data) {
                                        foreach ($user_data['results'] as $result) {
                                            $date = date('d.m.Y H:i', strtotime($result['created_at']));
                                            if (!in_array($date, $dates)) {
                                                $dates[] = $date;
                                            }
                                        }
                                    }
                                    sort($dates);
                                    ?>
                                    
                                    const labels = [
                                        <?php foreach ($dates as $date): ?>
                                            '<?= $date ?>',
                                        <?php endforeach; ?>
                                    ];
                                    
                                    const datasets = [];
                                    <?php 
                                    $color_index = 0;
                                    foreach ($users_data as $user_id => $user_data): 
                                        if (count($user_data['results']) < 2) continue;
                                    ?>
                                        // Данные для времени реакции
                                        datasets.push({
                                            label: '<?= htmlspecialchars($user_data['username']) ?> - Время реакции',
                                            data: [
                                                <?php 
                                                foreach ($dates as $date): 
                                                    $value = null;
                                                    foreach ($user_data['results'] as $result) {
                                                        if (date('d.m.Y H:i', strtotime($result['created_at'])) === $date) {
                                                            $value = $result['reaction_time'];
                                                            break;
                                                        }
                                                    }
                                                    echo $value !== null ? $value . ',' : 'null,';
                                                endforeach; 
                                                ?>
                                            ],
                                            borderColor: colors[<?= $color_index ?>],
                                            backgroundColor: colors[<?= $color_index ?>] + '33',
                                            borderWidth: 2,
                                            tension: 0.1,
                                            yAxisID: 'y'
                                        });
                                        
                                        // Данные для точности
                                        datasets.push({
                                            label: '<?= htmlspecialchars($user_data['username']) ?> - Точность',
                                            data: [
                                                <?php 
                                                foreach ($dates as $date): 
                                                    $value = null;
                                                    foreach ($user_data['results'] as $result) {
                                                        if (date('d.m.Y H:i', strtotime($result['created_at'])) === $date) {
                                                            $accuracy = $result['total_questions'] > 0 
                                                                ? round(($result['correct_answers'] / $result['total_questions']) * 100, 2)
                                                                : 0;
                                                            $value = $accuracy;
                                                            break;
                                                        }
                                                    }
                                                    echo $value !== null ? $value . ',' : 'null,';
                                                endforeach; 
                                                ?>
                                            ],
                                            borderColor: colors[<?= $color_index ?>],
                                            backgroundColor: colors[<?= $color_index ?>] + '33',
                                            borderWidth: 2,
                                            borderDash: [5, 5],
                                            tension: 0.1,
                                            yAxisID: 'y1'
                                        });
                                        
                                        <?php $color_index = ($color_index + 1) % 5; ?>
                                    <?php endforeach; ?>
                                    
                                    new Chart(ctx, {
                                        type: 'line',
                                        data: { labels, datasets },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            scales: {
                                                y: {
                                                    type: 'linear',
                                                    display: true,
                                                    position: 'left',
                                                    title: { display: true, text: 'Время реакции (мс)' }
                                                },
                                                y1: {
                                                    type: 'linear',
                                                    display: true,
                                                    position: 'right',
                                                    title: { display: true, text: 'Точность (%)' },
                                                    min: 0,
                                                    max: 100,
                                                    grid: { drawOnChartArea: false }
                                                },
                                                x: {
                                                    title: { display: true, text: 'Дата прохождения теста' }
                                                }
                                            }
                                        }
                                    });
                                });
                            </script>
                        </div>
                    <?php endforeach; ?>
                <?php elseif (!empty($selected_user_ids)): ?>
                    <div class="alert alert-info">
                        Нет данных для отображения или недостаточно результатов для построения графиков.
                        Для отображения динамики у каждого пользователя должно быть минимум 2 результата теста.
                    </div>
                <?php endif; ?>
            </div>
        </div>

        <!-- Форма назначения тестов -->
        <div class="card">
            <div class="card-header">
                <h3>Назначить тесты</h3>
            </div>
            <div class="card-body">
                <form method="POST">
                    <div class="form-group">
                        <label>Выберите пользователя:</label>
                        <select name="respondent_id" class="form-control" required>
                            <?php foreach ($users as $user): ?>
                                <option value="<?= $user['id'] ?>"><?= htmlspecialchars($user['username']) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Выберите тесты:</label>
                        <div id="tests-container">
                            <div class="input-group mb-2">
                                <select name="tests[]" class="form-control" required>
                                    <option value="Тест на реакцию на свет">Тест на реакцию на свет</option>
                                    <option value="Тест на сложение">Тест на сложение</option>
                                    <option value="Комплексный тест">Комплексный тест</option>
                                    <option value="Тест с одним кружком">Тест с одним кружком</option>
                                </select>
                                <div class="input-group-append">
                                    <button type="button" class="btn btn-danger remove-test">×</button>
                                </div>
                            </div>
                        </div>
                        <button type="button" id="add-test" class="btn btn-secondary mt-2">Добавить тест</button>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Назначить тесты</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            // Инициализация Select2
            $('.select2').select2({
                placeholder: "Выберите пользователей",
                allowClear: true
            });
            
            // Добавление нового теста
            $('#add-test').click(function() {
                const newTest = `
                    <div class="input-group mb-2">
                        <select name="tests[]" class="form-control" required>
                            <option value="Тест на реакцию на свет">Тест на реакцию на свет</option>
                            <option value="Тест на сложение">Тест на сложение</option>
                            <option value="Комплексный тест">Комплексный тест</option>
                            <option value="Тест с одним кружком">Тест с одним кружком</option>
                        </select>
                        <div class="input-group-append">
                            <button type="button" class="btn btn-danger remove-test">×</button>
                        </div>
                    </div>
                `;
                $('#tests-container').append(newTest);
            });
            
            // Удаление теста
            $(document).on('click', '.remove-test', function() {
                if ($('#tests-container').children().length > 1) {
                    $(this).closest('.input-group').remove();
                } else {
                    alert('Должен остаться хотя бы один тест');
                }
            });
        });
    </script>
</body>
</html>