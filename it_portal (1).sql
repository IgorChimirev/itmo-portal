-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Апр 02 2025 г., 13:43
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `it_portal`
--

-- --------------------------------------------------------

--
-- Структура таблицы `assigned_tests`
--

CREATE TABLE `assigned_tests` (
  `id` int(11) NOT NULL,
  `expert_id` int(11) NOT NULL,
  `respondent_id` int(11) NOT NULL,
  `test_name` varchar(255) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `assigned_tests`
--

INSERT INTO `assigned_tests` (`id`, `expert_id`, `respondent_id`, `test_name`, `assigned_at`) VALUES
(1, 4, 2, 'simple_reaction', '2025-03-18 23:16:55'),
(2, 4, 2, 'complex_reaction', '2025-03-18 23:17:00'),
(3, 4, 2, 'simple_reaction', '2025-03-18 23:17:53'),
(4, 4, 2, 'simple_reaction', '2025-03-18 23:19:31'),
(5, 4, 2, 'complex_reaction', '2025-03-18 23:21:36'),
(6, 4, 2, 'complex_reaction', '2025-03-18 23:22:46'),
(7, 4, 2, 'complex_reaction', '2025-03-18 23:25:56'),
(8, 4, 2, 'simple_reaction', '2025-03-18 23:26:02'),
(9, 4, 2, 'complex_reaction', '2025-03-18 23:26:05'),
(10, 4, 5, 'complex_reaction', '2025-03-18 23:56:29'),
(11, 4, 5, 'complex_reaction', '2025-03-18 23:56:31'),
(12, 4, 2, 'complex_reaction', '2025-03-18 23:57:28'),
(13, 4, 2, 'complex_reaction', '2025-03-19 11:18:43'),
(14, 4, 2, 'complex_reaction', '2025-03-19 11:18:45');

-- --------------------------------------------------------

--
-- Структура таблицы `combined_test_circle_results`
--

CREATE TABLE `combined_test_circle_results` (
  `id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `speed` decimal(4,2) NOT NULL,
  `attempts` int(11) NOT NULL,
  `correct_answers` int(11) NOT NULL,
  `average_time` int(11) NOT NULL,
  `best_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `combined_test_circle_results`
--

INSERT INTO `combined_test_circle_results` (`id`, `test_id`, `level`, `speed`, `attempts`, `correct_answers`, `average_time`, `best_time`) VALUES
(1, 1, 1, 1.50, 0, 0, 0, 0),
(2, 1, 2, 2.50, 0, 0, 0, 0),
(3, 1, 3, 3.50, 0, 0, 0, 0),
(4, 2, 1, 1.50, 4, 1, 46, 46),
(5, 2, 2, 2.50, 13, 5, 20, 12),
(6, 2, 3, 3.50, 7, 3, 10, 4),
(7, 3, 1, 1.50, 3, 2, 27, 24),
(8, 3, 2, 2.50, 5, 3, 17, 3),
(9, 3, 3, 3.50, 7, 2, 12, 6);

-- --------------------------------------------------------

--
-- Структура таблицы `combined_test_color_results`
--

CREATE TABLE `combined_test_color_results` (
  `id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `attempts` int(11) NOT NULL,
  `correct_answers` int(11) NOT NULL,
  `average_time` int(11) NOT NULL,
  `best_time` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `combined_test_color_results`
--

INSERT INTO `combined_test_color_results` (`id`, `test_id`, `attempts`, `correct_answers`, `average_time`, `best_time`) VALUES
(1, 1, 10, 10, 413, 388),
(2, 2, 7, 6, 436, 107),
(3, 3, 4, 4, 465, 201);

-- --------------------------------------------------------

--
-- Структура таблицы `combined_test_results`
--

CREATE TABLE `combined_test_results` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `combined_test_results`
--

INSERT INTO `combined_test_results` (`id`, `user_id`, `test_name`, `created_at`) VALUES
(1, 1, 'combined_reaction_test', '2025-04-02 01:15:19'),
(2, 1, 'combined_reaction_test', '2025-04-02 13:38:49'),
(3, 1, 'combined_reaction_test', '2025-04-02 14:42:18');

-- --------------------------------------------------------

--
-- Структура таблицы `experts`
--

CREATE TABLE `experts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `expert_pvk_lists`
--

CREATE TABLE `expert_pvk_lists` (
  `id` int(11) NOT NULL,
  `expert_id` int(11) NOT NULL COMMENT 'ID эксперта',
  `profession_id` int(11) NOT NULL COMMENT 'ID профессии',
  `pvk_id` int(11) NOT NULL COMMENT 'ID ПВК',
  `priority` int(11) NOT NULL COMMENT 'Приоритет ПВК в списке (1 - высший приоритет)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `expert_pvk_lists`
--

INSERT INTO `expert_pvk_lists` (`id`, `expert_id`, `profession_id`, `pvk_id`, `priority`) VALUES
(7, 4, 2, 1, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `timestamp`) VALUES
(1, 4, 2, 'вфвфвфвф', '2025-03-18 19:44:43'),
(2, 4, 2, 'dada', '2025-03-18 23:08:43'),
(3, 2, 4, 'вфвф', '2025-03-19 10:45:51');

-- --------------------------------------------------------

--
-- Структура таблицы `messagescon`
--

CREATE TABLE `messagescon` (
  `id` int(11) NOT NULL,
  `from_user_id` int(11) DEFAULT NULL,
  `to_user_id` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `message`, `is_read`, `created_at`) VALUES
(1, 2, 'Вам назначен тест: simple_reaction', 0, '2025-03-18 23:19:31'),
(2, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:21:36'),
(3, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:22:46'),
(4, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:25:56'),
(5, 2, 'Вам назначен тест: simple_reaction', 0, '2025-03-18 23:26:02'),
(6, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:26:05'),
(7, 5, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:56:29'),
(8, 5, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:56:31'),
(9, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-18 23:57:28'),
(10, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-19 11:18:43'),
(11, 2, 'Вам назначен тест: complex_reaction', 0, '2025-03-19 11:18:45');

-- --------------------------------------------------------

--
-- Структура таблицы `professions`
--

CREATE TABLE `professions` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `professions`
--

INSERT INTO `professions` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'Разработчик', 'Создает веб-сайты и приложения.', '2025-03-18 14:58:35'),
(2, 'Аналитик данных', 'Анализирует данные и строит модели.', '2025-03-18 14:58:35'),
(3, 'Системный администратор', 'Обеспечивает работу IT-инфраструктуры.', '2025-03-18 14:58:35');

-- --------------------------------------------------------

--
-- Структура таблицы `profession_expert`
--

CREATE TABLE `profession_expert` (
  `id` int(11) NOT NULL,
  `profession_id` int(11) NOT NULL,
  `expert_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `profession_expert`
--

INSERT INTO `profession_expert` (`id`, `profession_id`, `expert_id`) VALUES
(1, 1, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `profession_pvk`
--

CREATE TABLE `profession_pvk` (
  `id` int(11) NOT NULL,
  `profession_id` int(11) NOT NULL COMMENT 'ID профессии',
  `pvk_id` int(11) NOT NULL COMMENT 'ID ПВК'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `profession_pvk`
--

INSERT INTO `profession_pvk` (`id`, `profession_id`, `pvk_id`) VALUES
(1, 1, 2),
(2, 1, 3),
(3, 1, 4),
(4, 1, 6),
(5, 1, 7),
(6, 1, 8),
(7, 1, 9),
(8, 1, 11),
(9, 1, 14),
(10, 1, 17),
(11, 1, 18),
(12, 1, 19),
(13, 1, 20),
(14, 1, 26),
(15, 1, 27),
(16, 1, 28),
(17, 1, 32),
(18, 1, 36),
(19, 1, 40),
(20, 2, 2),
(21, 2, 3),
(22, 2, 4),
(23, 2, 6),
(24, 2, 7),
(25, 2, 8),
(26, 2, 9),
(27, 2, 10),
(28, 2, 11),
(29, 2, 13),
(30, 2, 14),
(31, 2, 17),
(32, 2, 18),
(33, 2, 19),
(34, 2, 20),
(35, 2, 27),
(36, 2, 28),
(37, 2, 30),
(38, 2, 32),
(39, 2, 36),
(40, 2, 40),
(41, 3, 4),
(42, 3, 8),
(43, 3, 40),
(44, 3, 18),
(45, 3, 6),
(46, 3, 7),
(47, 3, 17),
(48, 3, 19),
(49, 3, 20),
(50, 3, 15),
(51, 3, 36),
(52, 3, 38),
(53, 3, 27),
(54, 3, 28);

-- --------------------------------------------------------

--
-- Структура таблицы `pvk`
--

CREATE TABLE `pvk` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL COMMENT 'Название ПВК',
  `description` text DEFAULT NULL COMMENT 'Описание ПВК'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pvk`
--

INSERT INTO `pvk` (`id`, `name`, `description`) VALUES
(1, 'Адекватная самооценка', 'Умение объективно оценивать свои силы и возможности.'),
(2, 'Самостоятельность', 'Способность действовать без посторонней помощи.'),
(3, 'Пунктуальность, педантичность', 'Точность и аккуратность в выполнении задач.'),
(4, 'Дисциплинированность', 'Следование правилам и порядку.'),
(5, 'Аккуратность', 'Стремление к чистоте и порядку.'),
(6, 'Организованность', 'Умение планировать и структурировать дела.'),
(7, 'Исполнительность', 'Добросовестное выполнение задач.'),
(8, 'Ответственность', 'Готовность отвечать за свои действия.'),
(9, 'Трудолюбие', 'Усердие в работе.'),
(10, 'Инициативность', 'Способность предлагать идеи и действовать самостоятельно.'),
(11, 'Самокритичность', 'Умение объективно оценивать свои ошибки.'),
(12, 'Оптимизм', 'Позитивный взгляд на жизнь.'),
(13, 'Самообладание', 'Способность контролировать эмоции.'),
(14, 'Самоконтроль', 'Умение управлять своим поведением.'),
(15, 'Предусмотрительность', 'Способность предвидеть последствия.'),
(16, 'Уверенность в себе', 'Вера в свои силы.'),
(17, 'Тайм-менеджмент', 'Умение управлять временем.'),
(18, 'Стрессоустойчивость', 'Способность сохранять спокойствие в сложных ситуациях.'),
(19, 'Гибкость', 'Умение адаптироваться к изменениям.'),
(20, 'Решительность', 'Способность принимать решения.'),
(21, 'Сильная воля', 'Умение добиваться целей.'),
(22, 'Смелость', 'Готовность к риску.'),
(23, 'Чувство долга', 'Ответственность перед другими.'),
(24, 'Честность', 'Правдивость в словах и поступках.'),
(25, 'Порядочность', 'Следование моральным принципам.'),
(26, 'Товарищество', 'Умение поддерживать других.'),
(27, 'Креативность', 'Способность к творчеству.'),
(28, 'Оперативность', 'Быстрое выполнение задач.'),
(29, 'Образное представление', 'Умение визуализировать.'),
(30, 'Абстрактное представление', 'Способность мыслить абстрактно.'),
(31, 'Пространственное воображение', 'Умение представлять объекты в пространстве.'),
(32, 'Зрительная память', 'Способность запоминать зрительные образы.'),
(33, 'Слуховая память', 'Умение запоминать звуки и речь.'),
(34, 'Тактильная память', 'Способность запоминать ощущения.'),
(35, 'Энергичность', 'Активность и жизненная сила.'),
(36, 'Умственная работоспособность', 'Способность к интеллектуальному труду.'),
(37, 'Физическая работоспособность', 'Способность к физическому труду.'),
(38, 'Нервно-эмоциональная устойчивость', 'Устойчивость к стрессу.'),
(39, 'Выносливость', 'Способность переносить нагрузки.'),
(40, 'Внимательность', 'Умение сосредотачиваться на деталях.');

-- --------------------------------------------------------

--
-- Структура таблицы `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `expert_id` int(11) NOT NULL,
  `profession_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `expert_id` int(11) NOT NULL,
  `profession_id` int(11) NOT NULL,
  `review` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tests`
--

CREATE TABLE `tests` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `tests`
--

INSERT INTO `tests` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'Тест на свет', 'Тест, который измеряет реакцию на свет.', '2025-03-18 15:42:43'),
(2, 'Тест на звук', 'Тест, который измеряет реакцию на звук.', '2025-03-18 15:42:43'),
(3, 'Тест на цвет', 'Тест, который измеряет реакцию на цвет.', '2025-03-18 15:42:43'),
(4, 'Тест на сложение', 'Тест, который измеряет скорость решения простых математических задач.', '2025-03-18 15:42:43');

-- --------------------------------------------------------

--
-- Структура таблицы `test_results`
--

CREATE TABLE `test_results` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `reaction_time` float NOT NULL,
  `correct_answers` int(11) NOT NULL,
  `total_questions` int(11) NOT NULL,
  `attempts` int(11) DEFAULT 1,
  `average_time` float DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `test_results`
--

INSERT INTO `test_results` (`id`, `user_id`, `test_name`, `reaction_time`, `correct_answers`, `total_questions`, `attempts`, `average_time`, `created_at`) VALUES
(74, 1, 'Сенсомоторная реакция (цвета)', 1.035, 3, 3, 1, NULL, '2025-03-19 10:28:58'),
(75, 1, 'Сенсомоторная реакция (цвета)', 0.989, 3, 3, 1, NULL, '2025-03-19 10:29:02'),
(76, 1, 'Тест на реакцию на свет', 0.342, 1, 1, 1, 0.342, '2025-03-19 10:43:23'),
(77, 1, 'Тест на реакцию на свет', 0.381, 1, 1, 1, 0.381, '2025-03-19 10:55:14'),
(78, 1, 'Тест на реакцию на свет', 0.563, 1, 1, 1, 0.563, '2025-03-19 10:57:24'),
(79, 1, 'Тест на реакцию на свет', 0.364, 1, 1, 1, 0.364, '2025-03-19 11:04:46'),
(80, 1, 'Тест на реакцию на свет', 0.453, 1, 1, 1, 0.453, '2025-03-19 11:17:16'),
(81, 1, 'Тест на реакцию на свет', 0.337, 1, 1, 1, 0.337, '2025-03-19 11:27:37'),
(82, 1, 'Сенсомоторная реакция (цвета)', 1.006, 3, 3, 1, NULL, '2025-03-19 11:31:43'),
(83, 1, 'Тест на реакцию на свет', 0.525, 1, 1, 1, 0.525, '2025-04-01 21:39:05'),
(84, 1, 'circle_reaction_test', 2, 15, 19, 19, 22, '2025-04-01 22:01:42'),
(85, 1, 'addition_parity_test', 607, 30, 38, 38, 607, '2025-04-02 10:19:31'),
(86, 1, 'circle_reaction_test', 1, 16, 46, 46, 9, '2025-04-02 10:45:25'),
(87, 1, 'Тест на реакцию на цвета', 2.469, 1, 1, 1, 2.469, '2025-04-02 11:25:05'),
(88, 1, 'Тест на реакцию на свет', 0.646, 1, 1, 1, 0.646, '2025-04-02 11:27:29'),
(89, 1, 'Тест на реакцию на свет', 5.239, 1, 1, 1, 5.239, '2025-04-02 11:27:41'),
(90, 1, 'Тест на реакцию на свет', 0.556, 1, 1, 1, 0.556, '2025-04-02 11:27:46'),
(91, 1, 'Тест на реакцию на свет', 0.347, 1, 1, 1, 0.347, '2025-04-02 11:27:54'),
(92, 1, 'Тест на реакцию на свет', 0.369, 1, 1, 1, 0.369, '2025-04-02 11:28:30'),
(93, 1, 'addition_parity_test', 177, 11, 22, 22, 177, '2025-04-02 11:32:24');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','expert','user','consultant') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `gender` enum('male','female') DEFAULT NULL,
  `age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`, `gender`, `age`) VALUES
(2, 'user1', 'sdadada@dadada.com', '$2y$10$y./7BbvvrnMqUMp4AK.d9uW9dv2wxl6C.1c0iOHM9ztZuJb2jXEeO', 'user', '2025-03-18 15:47:35', NULL, NULL),
(4, 'expert_1', 'dada@fafa.com', '$2y$10$gDY3AFmQOx6jUTg1qt0E.uTRumch9GH9.MAzQtxi7EJZ4RS6UX/oi', 'expert', '2025-03-18 19:27:29', NULL, NULL),
(5, 'user2', 'dada@ada.com', '$2y$10$sgAPL7KvEeBKw8s78Ll6hOsKXhlHTAJIq7bbYWUzpkdeAzHIsaZo2', 'user', '2025-03-18 23:50:55', NULL, NULL),
(6, 'admin2', 'dadada@dada.com', '$2y$10$55jeetCukG6shpbPkvQaD.aM229uqh/hmIN9c/roTtIVlUlcF8Wce', 'admin', '2025-03-19 10:38:29', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `user_ratings`
--

CREATE TABLE `user_ratings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `expert_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 0 and 5),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `assigned_tests`
--
ALTER TABLE `assigned_tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expert_id` (`expert_id`),
  ADD KEY `respondent_id` (`respondent_id`);

--
-- Индексы таблицы `combined_test_circle_results`
--
ALTER TABLE `combined_test_circle_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `test_id` (`test_id`);

--
-- Индексы таблицы `combined_test_color_results`
--
ALTER TABLE `combined_test_color_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `test_id` (`test_id`);

--
-- Индексы таблицы `combined_test_results`
--
ALTER TABLE `combined_test_results`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `experts`
--
ALTER TABLE `experts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Индексы таблицы `expert_pvk_lists`
--
ALTER TABLE `expert_pvk_lists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expert_id` (`expert_id`),
  ADD KEY `profession_id` (`profession_id`),
  ADD KEY `pvk_id` (`pvk_id`);

--
-- Индексы таблицы `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Индексы таблицы `messagescon`
--
ALTER TABLE `messagescon`
  ADD PRIMARY KEY (`id`),
  ADD KEY `from_user_id` (`from_user_id`),
  ADD KEY `to_user_id` (`to_user_id`);

--
-- Индексы таблицы `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `professions`
--
ALTER TABLE `professions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `profession_expert`
--
ALTER TABLE `profession_expert`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profession_id` (`profession_id`),
  ADD KEY `expert_id` (`expert_id`);

--
-- Индексы таблицы `profession_pvk`
--
ALTER TABLE `profession_pvk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `profession_id` (`profession_id`),
  ADD KEY `pvk_id` (`pvk_id`);

--
-- Индексы таблицы `pvk`
--
ALTER TABLE `pvk`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `expert_id` (`expert_id`,`profession_id`),
  ADD KEY `profession_id` (`profession_id`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `expert_id` (`expert_id`,`profession_id`),
  ADD KEY `profession_id` (`profession_id`);

--
-- Индексы таблицы `tests`
--
ALTER TABLE `tests`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `test_results`
--
ALTER TABLE `test_results`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Индексы таблицы `user_ratings`
--
ALTER TABLE `user_ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`expert_id`),
  ADD KEY `expert_id` (`expert_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `assigned_tests`
--
ALTER TABLE `assigned_tests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT для таблицы `combined_test_circle_results`
--
ALTER TABLE `combined_test_circle_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `combined_test_color_results`
--
ALTER TABLE `combined_test_color_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `combined_test_results`
--
ALTER TABLE `combined_test_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `experts`
--
ALTER TABLE `experts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `expert_pvk_lists`
--
ALTER TABLE `expert_pvk_lists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `messagescon`
--
ALTER TABLE `messagescon`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `professions`
--
ALTER TABLE `professions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `profession_expert`
--
ALTER TABLE `profession_expert`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `profession_pvk`
--
ALTER TABLE `profession_pvk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT для таблицы `pvk`
--
ALTER TABLE `pvk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT для таблицы `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `tests`
--
ALTER TABLE `tests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `test_results`
--
ALTER TABLE `test_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `user_ratings`
--
ALTER TABLE `user_ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `assigned_tests`
--
ALTER TABLE `assigned_tests`
  ADD CONSTRAINT `assigned_tests_ibfk_1` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `assigned_tests_ibfk_2` FOREIGN KEY (`respondent_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `combined_test_circle_results`
--
ALTER TABLE `combined_test_circle_results`
  ADD CONSTRAINT `combined_test_circle_results_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `combined_test_results` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `combined_test_color_results`
--
ALTER TABLE `combined_test_color_results`
  ADD CONSTRAINT `combined_test_color_results_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `combined_test_results` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `experts`
--
ALTER TABLE `experts`
  ADD CONSTRAINT `experts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `expert_pvk_lists`
--
ALTER TABLE `expert_pvk_lists`
  ADD CONSTRAINT `expert_pvk_lists_ibfk_1` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `expert_pvk_lists_ibfk_2` FOREIGN KEY (`profession_id`) REFERENCES `professions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `expert_pvk_lists_ibfk_3` FOREIGN KEY (`pvk_id`) REFERENCES `pvk` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `messagescon`
--
ALTER TABLE `messagescon`
  ADD CONSTRAINT `messagescon_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messagescon_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `profession_expert`
--
ALTER TABLE `profession_expert`
  ADD CONSTRAINT `profession_expert_ibfk_1` FOREIGN KEY (`profession_id`) REFERENCES `professions` (`id`),
  ADD CONSTRAINT `profession_expert_ibfk_2` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`);

--
-- Ограничения внешнего ключа таблицы `profession_pvk`
--
ALTER TABLE `profession_pvk`
  ADD CONSTRAINT `profession_pvk_ibfk_1` FOREIGN KEY (`profession_id`) REFERENCES `professions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `profession_pvk_ibfk_2` FOREIGN KEY (`pvk_id`) REFERENCES `pvk` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`profession_id`) REFERENCES `professions` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`profession_id`) REFERENCES `professions` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_ratings`
--
ALTER TABLE `user_ratings`
  ADD CONSTRAINT `user_ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_ratings_ibfk_2` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
