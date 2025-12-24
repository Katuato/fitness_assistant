-- Проверка текущих данных в таблицах статистики

-- Количество записей в основных таблицах
SELECT '=== OVERVIEW ===' as section;
SELECT
    (SELECT COUNT(*) FROM sessions) as sessions_count,
    (SELECT COUNT(*) FROM session_exercise_runs) as exercise_runs_count,
    (SELECT COUNT(*) FROM users WHERE id = 5) as user_5_exists;

-- Данные sessions для пользователя 5
SELECT '=== SESSIONS FOR USER 5 ===' as section;
SELECT
    id,
    start_time,
    end_time,
    EXTRACT(EPOCH FROM (end_time - start_time))/60 as duration_minutes,
    accuracy,
    body_part,
    notes
FROM sessions
WHERE user_id = 5
ORDER BY start_time DESC;

-- Данные session_exercise_runs
SELECT '=== SESSION EXERCISE RUNS ===' as section;
SELECT
    ser.id,
    ser.session_id,
    ser.exercise_id,
    e.name as exercise_name,
    ser.start_time,
    ser.end_time
FROM session_exercise_runs ser
LEFT JOIN exercises e ON ser.exercise_id = e.id
ORDER BY ser.start_time DESC;

-- Статистика по дням (для weekly stats)
SELECT '=== DAILY STATS FOR LAST 7 DAYS ===' as section;
SELECT
    DATE(start_time) as workout_date,
    COUNT(*) as sessions_count,
    ROUND(AVG(accuracy), 1) as avg_accuracy,
    STRING_AGG(DISTINCT body_part, ', ') as body_parts
FROM sessions
WHERE user_id = 5
    AND start_time >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY DATE(start_time)
ORDER BY workout_date DESC;

-- Текущая серия тренировок
SELECT '=== CURRENT STREAK ===' as section;
WITH workout_days AS (
    SELECT DISTINCT DATE(start_time) as workout_date
    FROM sessions
    WHERE user_id = 5 AND end_time IS NOT NULL
    ORDER BY workout_date DESC
),
streak_calc AS (
    SELECT
        workout_date,
        workout_date - (ROW_NUMBER() OVER (ORDER BY workout_date DESC) - 1) * INTERVAL '1 day' as streak_group
    FROM workout_days
)
SELECT COUNT(*) as current_streak
FROM streak_calc
WHERE streak_group = (SELECT MAX(streak_group) FROM streak_calc)
    AND workout_date >= CURRENT_DATE - INTERVAL '1 day';
