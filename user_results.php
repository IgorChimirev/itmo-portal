<?php
session_start();

// Включаем отображение ошибок
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Подключение к базе данных
try {
    require_once 'php/db.php';
    
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
} catch (Exception $e) {
    die("Ошибка подключения к БД: " . $e->getMessage());
}

// Проверка авторизации
if (!isset($_SESSION['user_id'])) {
    header('Location: ../index.php');
    exit();
}

if ($_SESSION['user_role'] !== 'user') {
    header('Location: ../index.php');
    exit();
}

$user_id = $_SESSION['user_id'];

// Функция для получения всех уникальных тестов пользователя
function getUserTests($conn, $user_id) {
    try {
        $sql = "SELECT DISTINCT test_name FROM test_results WHERE user_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $user_id);
        
        if (!$stmt->execute()) {
            throw new Exception("Ошибка выполнения запроса: " . $stmt->error);
        }
        
        $result = $stmt->get_result();
        $tests = $result->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
        
        return array_column($tests, 'test_name');
    } catch (Exception $e) {
        error_log("Database error: " . $e->getMessage());
        return [];
    }
}

// Функция для получения результатов конкретного теста
function getTestResults($conn, $user_id, $test_name) {
    try {
        $sql = "SELECT * FROM test_results 
                WHERE user_id = ? AND test_name = ?
                ORDER BY created_at ASC";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("is", $user_id, $test_name);
        
        if (!$stmt->execute()) {
            throw new Exception("Ошибка выполнения запроса: " . $stmt->error);
        }
        
        $result = $stmt->get_result();
        $data = $result->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
        
        return $data;
    } catch (Exception $e) {
        error_log("Database error: " . $e->getMessage());
        return [];
    }
}

// Функция для определения метрик для теста
function getTestMetrics($test_name) {
    // Определяем какие поля использовать для разных тестов
    if (strpos($test_name, 'реакц') !== false || strpos($test_name, 'reaction') !== false) {
        return [
            'reaction_time' => 'Время реакции (мс)',
            'accuracy' => 'Точность (%)'
        ];
    } elseif (strpos($test_name, 'addition') !== false || strpos($test_name, 'сложен') !== false) {
        return [
            'correct_answers' => 'Правильные ответы',
            'average_time' => 'Среднее время (мс)'
        ];
    } elseif (strpos($test_name, 'circle') !== false) {
        return [
            'correct_answers' => 'Правильные ответы',
            'accuracy' => 'Точность (%)'
        ];
    }
    
    // По умолчанию возвращаем эти метрики
    return [
        'reaction_time' => 'Время реакции (мс)',
        'correct_answers' => 'Правильные ответы'
    ];
}

// Получаем список всех тестов пользователя
$user_tests = getUserTests($conn, $user_id);

// Собираем данные для каждого теста
$test_data = [];
foreach ($user_tests as $test_name) {
    $results = getTestResults($conn, $user_id, $test_name);
    if (count($results) > 1) { // Показываем динамику только если есть несколько результатов
        $test_data[$test_name] = [
            'results' => $results,
            'metrics' => getTestMetrics($test_name)
        ];
    }
}

// Получаем все результаты для таблицы
$all_results = [];
if (!empty($user_tests)) {
    $sql = "SELECT * FROM test_results WHERE user_id = ? ORDER BY created_at DESC";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $all_results = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мои результаты</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            padding-top: 60px;
        }
        .chart-container {
            height: 400px;
            margin-bottom: 30px;
        }
        .table-responsive {
            margin-bottom: 30px;
        }
        .no-data {
            color: #6c757d;
            font-style: italic;
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.php">ITMO Portal</a>
            <div class="navbar-collapse collapse">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <span class="navbar-text mr-2"><?= htmlspecialchars($_SESSION['username']) ?></span>
                        <a href="pages/logout.php" class="btn btn-outline-dark">Выйти</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1 class="text-center my-4">Мои результаты</h1>

        <!-- Таблица всех результатов -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Все результаты тестов</h3>
            </div>
            <div class="card-body">
                <?php if (!empty($all_results)): ?>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Тест</th>
                                    <th>Дата</th>
                                    <th>Время реакции (мс)</th>
                                    <th>Правильные ответы</th>
                                    <th>Всего вопросов</th>
                                    <th>Попытки</th>
                                    <th>Среднее время (мс)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($all_results as $result): ?>
                                    <tr>
                                        <td><?= htmlspecialchars($result['test_name']) ?></td>
                                        <td><?= date('d.m.Y H:i', strtotime($result['created_at'])) ?></td>
                                        <td><?= $result['reaction_time'] ? number_format($result['reaction_time'], 3) : '-' ?></td>
                                        <td><?= $result['correct_answers'] ?></td>
                                        <td><?= $result['total_questions'] ?></td>
                                        <td><?= $result['attempts'] ?></td>
                                        <td><?= $result['average_time'] ? number_format($result['average_time'], 3) : '-' ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php else: ?>
                    <div class="no-data">Нет данных о тестах</div>
                <?php endif; ?>
            </div>
        </div>

        <!-- Динамика по тестам -->
        <?php if (!empty($test_data)): ?>
            <?php foreach ($test_data as $test_name => $data): ?>
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h3 class="mb-0">Динамика: <?= htmlspecialchars($test_name) ?></h3>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="chart-<?= md5($test_name) ?>"></canvas>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        <?php else: ?>
            <div class="alert alert-info">Нет достаточных данных для отображения динамики (требуется более одного результата теста)</div>
        <?php endif; ?>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            <?php foreach ($test_data as $test_name => $data): 
                $chart_id = "chart-" . md5($test_name);
                $results = $data['results'];
                $metrics = $data['metrics'];
            ?>
                try {
                    const ctx = document.getElementById('<?= $chart_id ?>');
                    if (!ctx) {
                        console.error('Canvas element not found: <?= $chart_id ?>');
                        return;
                    }
                    
                    // Подготовка данных
                    const labels = [
                        <?php foreach ($results as $result): ?>
                            '<?= date("d.m.Y H:i", strtotime($result["created_at"])) ?>',
                        <?php endforeach; ?>
                    ];
                    
                    const datasets = [];
                    <?php 
                    $colors = [
                        ['75, 192, 192', 'Среднее время реакции'],
                        ['255, 99, 132', 'Точность ответов'],
                        ['54, 162, 235', 'Правильные ответы']
                    ];
                    $color_index = 0;
                    ?>
                    
                    <?php foreach ($metrics as $field => $label): ?>
                        datasets.push({
                            label: '<?= $label ?>',
                            data: [
                                <?php foreach ($results as $result): ?>
                                    <?php
                                    $value = 0;
                                    if ($field === 'accuracy') {
                                        $value = ($result['total_questions'] > 0) 
                                            ? round(($result['correct_answers'] / $result['total_questions']) * 100, 2)
                                            : 0;
                                    } else {
                                        $value = isset($result[$field]) ? (float)$result[$field] : 0;
                                    }
                                    ?>
                                    <?= $value ?>,
                                <?php endforeach; ?>
                            ],
                            borderColor: 'rgba(<?= $colors[$color_index % count($colors)][0] ?>, 1)',
                            backgroundColor: 'rgba(<?= $colors[$color_index % count($colors)][0] ?>, 0.1)',
                            borderWidth: 2,
                            tension: 0.1,
                            yAxisID: 'y<?= $color_index + 1 ?>'
                        });
                        <?php $color_index++; ?>
                    <?php endforeach; ?>
                    
                    // Создаем график
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: labels,
                            datasets: datasets
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                x: {
                                    title: {
                                        display: true,
                                        text: 'Дата прохождения теста'
                                    }
                                },
                                y1: {
                                    type: 'linear',
                                    display: true,
                                    position: 'left',
                                    title: {
                                        display: true,
                                        text: datasets[0].label
                                    }
                                }
                                <?php if (count($metrics) > 1): ?>
                                ,
                                y2: {
                                    type: 'linear',
                                    display: true,
                                    position: 'right',
                                    title: {
                                        display: true,
                                        text: datasets[1].label
                                    },
                                    grid: {
                                        drawOnChartArea: false
                                    }
                                }
                                <?php endif; ?>
                            },
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function(context) {
                                            let label = context.dataset.label || '';
                                            if (label) label += ': ';
                                            label += context.parsed.y.toFixed(2);
                                            if (context.dataset.label.includes('%')) {
                                                label += '%';
                                            } else if (context.dataset.label.includes('мс')) {
                                                label += ' мс';
                                            }
                                            return label;
                                        }
                                    }
                                }
                            }
                        }
                    });
                    
                    console.log('Chart created: <?= $chart_id ?>');
                } catch (error) {
                    console.error('Error creating chart <?= $chart_id ?>:', error);
                }
            <?php endforeach; ?>
        });
    </script>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>