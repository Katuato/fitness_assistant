-- Добавление дополнительных демо-данных для статистики

-- Добавим больше тренировочных сессий за последние 30 дней
INSERT INTO sessions (
    user_id, start_time, end_time, accuracy, body_part, device_info, notes
) VALUES
-- Прошлая неделя (дополнительно к существующим)
(5, CURRENT_DATE - INTERVAL '7 days' + INTERVAL '2 hours', CURRENT_DATE - INTERVAL '7 days' + INTERVAL '2 hours 45 minutes', 82, 'Legs',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Light leg day'),

(5, CURRENT_DATE - INTERVAL '8 days' + INTERVAL '1 hour', CURRENT_DATE - INTERVAL '8 days' + INTERVAL '1 hour 55 minutes', 89, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Back and shoulder focus'),

(5, CURRENT_DATE - INTERVAL '10 days' + INTERVAL '3 hours', CURRENT_DATE - INTERVAL '10 days' + INTERVAL '3 hours 40 minutes', 91, 'Full Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Weekend full body workout'),

-- 2 недели назад
(5, CURRENT_DATE - INTERVAL '14 days' + INTERVAL '2 hours', CURRENT_DATE - INTERVAL '14 days' + INTERVAL '2 hours 50 minutes', 87, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Chest and tricep day'),

(5, CURRENT_DATE - INTERVAL '16 days' + INTERVAL '1 hour', CURRENT_DATE - INTERVAL '16 days' + INTERVAL '1 hour 45 minutes', 84, 'Legs',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Squat and lunge focus'),

-- 3 недели назад
(5, CURRENT_DATE - INTERVAL '21 days' + INTERVAL '3 hours', CURRENT_DATE - INTERVAL '21 days' + INTERVAL '3 hours 55 minutes', 93, 'Full Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'High intensity session'),

(5, CURRENT_DATE - INTERVAL '23 days' + INTERVAL '2 hours', CURRENT_DATE - INTERVAL '23 days' + INTERVAL '2 hours 40 minutes', 86, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Pull day - back and biceps'),

-- Месяц назад
(5, CURRENT_DATE - INTERVAL '28 days' + INTERVAL '1 hour', CURRENT_DATE - INTERVAL '28 days' + INTERVAL '1 hour 50 minutes', 88, 'Legs',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Heavy compound lifts'),

(5, CURRENT_DATE - INTERVAL '30 days' + INTERVAL '3 hours', CURRENT_DATE - INTERVAL '30 days' + INTERVAL '3 hours 45 minutes', 90, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Push day - chest and shoulders');

-- Добавим данные о выполненных упражнениях для некоторых сессий
-- Сначала получим ID последних сессий
INSERT INTO session_exercise_runs (session_id, exercise_id, start_time, end_time)
SELECT
    s.id,
    e.id,
    s.start_time + INTERVAL '5 minutes',
    s.start_time + INTERVAL '15 minutes'
FROM sessions s
CROSS JOIN (SELECT id FROM exercises WHERE name IN ('Push-Ups', 'Squats', 'Bench Press') LIMIT 3) e
WHERE s.user_id = 5 AND s.start_time >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY s.start_time DESC, e.id
LIMIT 15;

-- Добавим еще немного упражнений для разнообразия
INSERT INTO session_exercise_runs (session_id, exercise_id, start_time, end_time)
SELECT
    s.id,
    e.id,
    s.start_time + INTERVAL '20 minutes',
    s.start_time + INTERVAL '30 minutes'
FROM sessions s
CROSS JOIN (SELECT id FROM exercises WHERE name IN ('Pull-Ups', 'Deadlifts', 'Plank') LIMIT 3) e
WHERE s.user_id = 5 AND s.start_time >= CURRENT_DATE - INTERVAL '14 days'
ORDER BY s.start_time DESC, e.id
LIMIT 12;

-- Выведем итоговую статистику
SELECT '=== STATS SUMMARY AFTER ADDING DATA ===' as section;
SELECT
    (SELECT COUNT(*) FROM sessions WHERE user_id = 5) as total_sessions,
    (SELECT COUNT(*) FROM session_exercise_runs) as total_exercise_runs,
    (SELECT ROUND(AVG(accuracy), 1) FROM sessions WHERE user_id = 5) as avg_accuracy,
    (SELECT COUNT(DISTINCT DATE(start_time)) FROM sessions WHERE user_id = 5 AND start_time >= CURRENT_DATE - INTERVAL '30 days') as active_days_last_30;

-- Покажем распределение тренировок по типам
SELECT '=== WORKOUT DISTRIBUTION ===' as section;
SELECT
    body_part,
    COUNT(*) as count,
    ROUND(AVG(accuracy), 1) as avg_accuracy
FROM sessions
WHERE user_id = 5
GROUP BY body_part
ORDER BY count DESC;
