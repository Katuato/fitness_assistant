-- Демо данные для пользователя y0r1k (user_id = 5)
-- Демонстрация нового функционала PHASE 1

-- ===========================================
-- 1. ДОБАВИМ УПРАЖНЕНИЯ С НОВЫМИ ПОЛЯМИ
-- ===========================================

INSERT INTO exercises (
    name, category, equipment, force, level, mechanic, instructions, raw,
    description, difficulty, estimated_duration, calories_burn,
    default_sets, default_reps, image_url, created_at
) VALUES
-- Верхняя часть тела
('Push-ups', 'chest', 'bodyweight', 'push', 'intermediate', 'compound',
 '["Start in a plank position", "Lower your body until your chest nearly touches the floor", "Push yourself back up"]',
 '{"source": "demo"}',
 'Classic push-up exercise targeting chest, shoulders, and triceps', 'intermediate', 5, 8, 3, 12,
 'https://example.com/images/push-ups.jpg', NOW()),

('Pull-ups', 'back', 'bar', 'pull', 'advanced', 'compound',
 '["Hang from a bar with palms facing away", "Pull yourself up until chin is over the bar", "Lower back down with control"]',
 '{"source": "demo"}',
 'Excellent compound exercise for back and biceps development', 'advanced', 8, 12, 3, 8,
 'https://example.com/images/pull-ups.jpg', NOW()),

('Bench Press', 'chest', 'barbell', 'push', 'intermediate', 'compound',
 '["Lie on bench, grip bar shoulder-width", "Lower bar to chest", "Press bar up until arms are extended"]',
 '{"source": "demo"}',
 'Fundamental chest exercise using barbell', 'intermediate', 10, 15, 4, 10,
 'https://example.com/images/bench-press.jpg', NOW()),

('Squats', 'legs', 'barbell', 'push', 'intermediate', 'compound',
 '["Stand with feet shoulder-width, bar on shoulders", "Lower by bending knees and hips", "Return to standing position"]',
 '{"source": "demo"}',
 'King of all exercises for lower body strength', 'intermediate', 12, 18, 4, 8,
 'https://example.com/images/squats.jpg', NOW()),

('Deadlifts', 'legs', 'barbell', 'pull', 'advanced', 'compound',
 '["Stand with feet hip-width, grip bar overhand", "Lift by extending hips and knees", "Keep back straight throughout"]',
 '{"source": "demo"}',
 'Full body exercise targeting posterior chain', 'advanced', 15, 25, 3, 6,
 'https://example.com/images/deadlifts.jpg', NOW()),

-- Низкая часть тела
('Lunges', 'legs', 'dumbbells', 'push', 'beginner', 'compound',
 '["Step forward with one leg", "Lower until both knees are bent", "Push back to starting position"]',
 '{"source": "demo"}',
 'Great unilateral leg exercise for balance and strength', 'beginner', 8, 10, 3, 10,
 'https://example.com/images/lunges.jpg', NOW()),

('Plank', 'core', 'bodyweight', 'static', 'beginner', 'isolation',
 '["Start in forearm plank position", "Keep body straight", "Hold for specified time"]',
 '{"source": "demo"}',
 'Isometric core exercise for stability and endurance', 'beginner', 3, 5, 3, 30,
 'https://example.com/images/plank.jpg', NOW()),

('Bicep Curls', 'arms', 'dumbbells', 'pull', 'beginner', 'isolation',
 '["Stand with dumbbells, palms forward", "Curl weights up to shoulders", "Lower with control"]',
 '{"source": "demo"}',
 'Isolation exercise for bicep development', 'beginner', 6, 6, 3, 12,
 'https://example.com/images/bicep-curls.jpg', NOW());

-- ===========================================
-- 2. ДОБАВИМ ТРЕНИРОВОЧНЫЕ СЕССИИ ДЛЯ ПОЛЬЗОВАТЕЛЯ 5
-- ===========================================

INSERT INTO sessions (
    user_id, start_time, end_time, accuracy, body_part, device_info, notes
) VALUES
-- Тренировки за последнюю неделю
(5, NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days' + INTERVAL '45 minutes', 85, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Good upper body session'),

(5, NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days' + INTERVAL '60 minutes', 78, 'Legs',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Heavy leg day'),

(5, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days' + INTERVAL '50 minutes', 92, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Excellent chest and back workout'),

(5, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day' + INTERVAL '40 minutes', 88, 'Full Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Mixed workout with good form'),

(5, NOW() - INTERVAL '3 hours', NOW() - INTERVAL '30 minutes', 95, 'Upper Body',
 '{"device": "iPhone 15", "app_version": "1.0.0"}', 'Morning chest session');

-- ===========================================
-- 3. СОЗДАДИМ ПЛАНЫ ТРЕНИРОВОК ДЛЯ ПОЛЬЗОВАТЕЛЯ 5
-- ===========================================

-- План на сегодня
INSERT INTO user_daily_plans (user_id, plan_date, created_at, updated_at) VALUES
(5, CURRENT_DATE, NOW(), NOW());

-- План на завтра
INSERT INTO user_daily_plans (user_id, plan_date, created_at, updated_at) VALUES
(5, CURRENT_DATE + INTERVAL '1 day', NOW(), NOW());

-- ===========================================
-- 4. ДОБАВИМ УПРАЖНЕНИЯ В ПЛАНЫ
-- ===========================================

-- Получим ID планов для пользователя 5
-- План на сегодня (некоторые упражнения выполнены, некоторые нет)
INSERT INTO plan_exercises (plan_id, exercise_id, sets, reps, order_index, is_completed, completed_at)
SELECT
    udp.id as plan_id,
    e.id as exercise_id,
    e.default_sets,
    e.default_reps,
    ROW_NUMBER() OVER (ORDER BY e.id) - 1 as order_index,
    CASE
        WHEN ROW_NUMBER() OVER (ORDER BY e.id) <= 3 THEN true  -- Первые 3 упражнения выполнены
        ELSE false  -- Остальные не выполнены
    END as is_completed,
    CASE
        WHEN ROW_NUMBER() OVER (ORDER BY e.id) <= 3 THEN NOW() - INTERVAL '2 hours'
        ELSE NULL
    END as completed_at
FROM user_daily_plans udp
CROSS JOIN exercises e
WHERE udp.user_id = 5 AND udp.plan_date = CURRENT_DATE
ORDER BY e.id
LIMIT 6;

-- План на завтра (все упражнения не выполнены)
INSERT INTO plan_exercises (plan_id, exercise_id, sets, reps, order_index, is_completed)
SELECT
    udp.id as plan_id,
    e.id as exercise_id,
    e.default_sets,
    e.default_reps,
    ROW_NUMBER() OVER (ORDER BY e.id DESC) - 1 as order_index,  -- Обратный порядок
    false as is_completed
FROM user_daily_plans udp
CROSS JOIN exercises e
WHERE udp.user_id = 5 AND udp.plan_date = CURRENT_DATE + INTERVAL '1 day'
ORDER BY e.id DESC
LIMIT 4;

-- ===========================================
-- 5. ДОБАВИМ ДАННЫЕ О МЫШЦАХ ДЛЯ УПРАЖНЕНИЙ
-- ===========================================

-- Сначала добавим мышцы, если их нет
INSERT INTO muscles (name) VALUES
('Chest'), ('Shoulders'), ('Triceps'), ('Back'), ('Biceps'),
('Quadriceps'), ('Hamstrings'), ('Glutes'), ('Calves'), ('Core')
ON CONFLICT (name) DO NOTHING;

-- Добавим связи упражнения-мышцы
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id,
    CASE
        WHEN m.name IN ('Chest', 'Back', 'Quadriceps') THEN 'primary'
        ELSE 'secondary'
    END as role
FROM exercises e
CROSS JOIN muscles m
WHERE
    (e.name = 'Push-ups' AND m.name IN ('Chest', 'Shoulders', 'Triceps')) OR
    (e.name = 'Pull-ups' AND m.name IN ('Back', 'Biceps')) OR
    (e.name = 'Bench Press' AND m.name IN ('Chest', 'Shoulders', 'Triceps')) OR
    (e.name = 'Squats' AND m.name IN ('Quadriceps', 'Hamstrings', 'Glutes')) OR
    (e.name = 'Deadlifts' AND m.name IN ('Hamstrings', 'Glutes', 'Back')) OR
    (e.name = 'Lunges' AND m.name IN ('Quadriceps', 'Hamstrings', 'Glutes')) OR
    (e.name = 'Plank' AND m.name IN ('Core', 'Shoulders')) OR
    (e.name = 'Bicep Curls' AND m.name IN ('Biceps'));

-- ===========================================
-- 6. ВЕРИФИКАЦИЯ ДАННЫХ
-- ===========================================

-- Проверим, что все данные добавлены корректно
SELECT '=== DEMO DATA VERIFICATION ===' as section;

SELECT 'Total exercises:' as info, COUNT(*) as count FROM exercises;
SELECT 'Sessions for user 5:' as info, COUNT(*) as count FROM sessions WHERE user_id = 5;
SELECT 'Daily plans for user 5:' as info, COUNT(*) as count FROM user_daily_plans WHERE user_id = 5;
SELECT 'Plan exercises:' as info, COUNT(*) as count FROM plan_exercises;

SELECT '=== TODAY PLAN ===' as section;
SELECT
    pe.id,
    e.name,
    pe.sets,
    pe.reps,
    pe.is_completed,
    pe.order_index
FROM plan_exercises pe
JOIN user_daily_plans udp ON pe.plan_id = udp.id
JOIN exercises e ON pe.exercise_id = e.id
WHERE udp.user_id = 5 AND udp.plan_date = CURRENT_DATE
ORDER BY pe.order_index;

SELECT '=== COMPLETED EXERCISES TODAY ===' as section;
SELECT COUNT(*) as completed_today
FROM plan_exercises pe
JOIN user_daily_plans udp ON pe.plan_id = udp.id
WHERE udp.user_id = 5 AND udp.plan_date = CURRENT_DATE AND pe.is_completed = true;

SELECT '=== TOMORROW PLAN ===' as section;
SELECT
    pe.id,
    e.name,
    pe.sets,
    pe.reps,
    pe.is_completed,
    pe.order_index
FROM plan_exercises pe
JOIN user_daily_plans udp ON pe.plan_id = udp.id
JOIN exercises e ON pe.exercise_id = e.id
WHERE udp.user_id = 5 AND udp.plan_date = CURRENT_DATE + INTERVAL '1 day'
ORDER BY pe.order_index;

SELECT '=== RECENT SESSIONS ===' as section;
SELECT
    start_time,
    accuracy,
    body_part,
    notes
FROM sessions
WHERE user_id = 5
ORDER BY start_time DESC
LIMIT 5;


