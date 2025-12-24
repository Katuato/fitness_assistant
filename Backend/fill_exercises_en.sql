-- Fill database with exercises from iOS app mock data
-- Execute after applying all migrations

-- Clear existing data (optional)
DELETE FROM exercise_muscle;
DELETE FROM exercise_equipment;
DELETE FROM exercises;
DELETE FROM muscles;
DELETE FROM equipment;

-- Insert muscles
INSERT INTO muscles (name) VALUES
('Biceps'), ('Forearms'), ('Brachialis'), ('Biceps Peak'), ('Chest'), ('Triceps'),
('Shoulders'), ('Quadriceps'), ('Glutes'), ('Hamstrings'), ('Core'), ('Abs'),
('Lower Back'), ('Lats'), ('Upper Back'), ('Rhomboids'), ('Side Delts'),
('Front Delts'), ('Rear Delts'), ('Calves'), ('Gastrocnemius'), ('Obliques'),
('Hip Flexors'), ('Middle Back'), ('Full Body'), ('Cardio');

-- Insert equipment
INSERT INTO equipment (name) VALUES
('dumbbells'), ('barbell'), ('kettlebell'), ('bodyweight'), ('machine'),
('cable'), ('bench'), ('pull-up bar');

-- Insert exercises with detailed information
INSERT INTO exercises (
    name, category, description, difficulty, estimated_duration, calories_burn,
    default_sets, default_reps, image_url, equipment, force, level, mechanic, instructions
) VALUES
-- Biceps exercises
('Dumbbell Bicep Curls', 'biceps', 'Classic isolation exercise for developing biceps. Excellent for building arm strength and definition.',
 'beginner', 8, 35, 3, 12, 'https://example.com/images/bicep-curls.jpg',
 'dumbbells', 'pull', 'beginner', 'isolation',
 '["Stand with feet shoulder-width apart", "Hold dumbbells with palms facing forward", "Keep elbows tucked to your sides", "Curl the weight toward your shoulders", "Lower with control"]'),

('Hammer Curls', 'biceps', 'Targeted exercise for the brachialis for overall arm thickness. Excellent for developing functional strength.',
 'beginner', 7, 30, 3, 10, 'https://example.com/images/hammer-curl.jpg',
 'dumbbells', 'pull', 'beginner', 'isolation',
 '["Stand with dumbbells at your sides", "Palms facing each other", "Curl the weight while maintaining neutral grip", "Squeeze at the top", "Lower slowly and controlled"]'),

('Concentration Curls', 'biceps', 'Isolated movement for maximum bicep peak development. Eliminates momentum for pure muscle contraction.',
 'intermediate', 9, 40, 3, 12, 'https://example.com/images/concentration-curl.jpg',
 'dumbbells', 'pull', 'intermediate', 'isolation',
 '["Sit on a bench with legs spread", "Rest your elbow against inner thigh", "Curl dumbbell toward shoulder", "Focus on bicep contraction", "Lower with full control"]'),

('Preacher Curls', 'biceps', 'Eliminates swinging for strict bicep isolation. Excellent for building muscle mass.',
 'intermediate', 10, 45, 3, 10, 'https://example.com/images/preacher-curl.jpg',
 'dumbbells', 'pull', 'intermediate', 'isolation',
 '["Place arms on preacher bench pad", "Grip bar with underhand grip", "Curl while keeping arms on pad", "Squeeze at peak contraction", "Lower to near straight arms"]'),

-- Chest exercises
('Bench Press', 'chest', 'King of chest exercises. Develops mass and strength throughout the upper body.',
 'intermediate', 12, 60, 4, 10, 'https://example.com/images/bench-press.jpg',
 'barbell', 'push', 'intermediate', 'compound',
 '["Lie on bench with feet on floor", "Grip bar slightly wider than shoulders", "Lower bar to mid-chest with control", "Press up explosively", "Keep shoulder blades retracted"]'),

('Push-ups', 'chest', 'Bodyweight classic for developing strength everywhere. Perfect for functional pressing power.',
 'beginner', 6, 40, 3, 15, 'https://example.com/images/push-ups.jpg',
 'bodyweight', 'push', 'beginner', 'compound',
 '["Assume plank position", "Hands slightly wider than shoulders", "Lower chest toward floor", "Keep core and back straight", "Push back up"]'),

('Incline Bench Press', 'chest', 'Targeted exercise for upper chest development. Essential for balanced chest growth.',
 'intermediate', 11, 55, 4, 10, 'https://example.com/images/incline-bench-press.jpg',
 'dumbbells', 'push', 'intermediate', 'compound',
 '["Set bench to 30-45 degrees", "Lie down with feet planted", "Grip bar at shoulder width", "Lower to upper chest", "Press in straight line"]'),

('Dumbbell Flyes', 'chest', 'Isolation movement for chest stretch and definition. Excellent for width and detailing.',
 'intermediate', 9, 45, 3, 12, 'https://example.com/images/dumbbell-flyes.jpg',
 'dumbbells', 'push', 'intermediate', 'isolation',
 '["Lie on flat bench with dumbbells", "Start with arms extended over chest", "Lower weight in an arc to sides", "Feel deep stretch in chest", "Squeeze chest bringing weight back up"]'),

-- Legs exercises
('Squats', 'legs', 'King of leg exercises. Develops functional strength and mobility, creating powerful legs.',
 'intermediate', 10, 55, 4, 12, 'https://example.com/images/squats.jpg',
 'bodyweight', 'push', 'intermediate', 'compound',
 '["Stand with feet shoulder-width apart", "Keep chest up, core engaged", "Lower as if sitting back into chair", "Drive through heels to return", "Maintain neutral spine"]'),

('Lunges', 'legs', 'Unilateral movement for balanced leg development. Improves stability and functional strength.',
 'beginner', 8, 45, 3, 10, 'https://example.com/images/lunges.jpg',
 'bodyweight', 'push', 'beginner', 'compound',
 '["Stand straight with feet shoulder-width apart", "Step forward with one leg", "Lower hips until both knees are at 90 degrees", "Return to starting position", "Alternate legs each repetition"]'),

('Leg Press', 'legs', 'Machine exercise for safely loading heavy weight. Perfect for building mass and strength.',
 'intermediate', 10, 50, 4, 12, 'https://example.com/images/leg-press.jpg',
 'machine', 'push', 'intermediate', 'compound',
 '["Sit in leg press machine", "Place feet on platform shoulder-width apart", "Release safety locks and lower weight", "Press through heels straightening legs", "Dont lock knees at top"]'),

('Calf Raises', 'legs', 'Isolation movement for calf development. Important for balanced lower leg strength.',
 'beginner', 6, 30, 3, 15, 'https://example.com/images/calf-raises.jpg',
 'bodyweight', 'push', 'beginner', 'isolation',
 '["Stand with toes on elevated surface", "Keep torso engaged and straight", "Rise onto toes as high as possible", "Hold at peak contraction", "Lower heels below platform level"]'),

-- Back exercises
('Deadlifts', 'back', 'Ultimate compound movement. Develops full body strength and proper hip hinge mechanics.',
 'advanced', 12, 70, 4, 8, 'https://example.com/images/deadlifts.jpg',
 'barbell', 'pull', 'advanced', 'compound',
 '["Stand with feet shoulder-width apart", "Hinge at hips and grip barbell", "Engage lats and brace core", "Drive through heels and stand up straight", "Control weight on descent"]'),

('Pull-ups', 'back', 'Bodyweight classic for back width and strength. Essential for upper body development.',
 'intermediate', 8, 50, 3, 10, 'https://example.com/images/pull-ups.jpg',
 'bodyweight', 'pull', 'intermediate', 'compound',
 '["Hang from bar with palms facing away", "Engage lats, retract shoulder blades", "Pull up until chin clears bar", "Lower with control to full extension", "Avoid swinging or kipping"]'),

('Bent-over Barbell Rows', 'back', 'Compound movement for back thickness. Develops powerful pulling strength and posture.',
 'intermediate', 10, 55, 4, 10, 'https://example.com/images/bent-over-row.jpg',
 'barbell', 'pull', 'intermediate', 'compound',
 '["Hinge at hips with slight knee bend", "Grip barbell at shoulder width", "Pull barbell to lower chest", "Squeeze shoulder blades together", "Lower with control"]'),

('Lat Pulldowns', 'back', 'Machine exercise for lat width and V-taper shape. Excellent for building pull-up strength.',
 'beginner', 9, 45, 3, 12, 'https://example.com/images/lat-pulldown.jpg',
 'machine', 'pull', 'beginner', 'compound',
 '["Sit at lat pulldown machine", "Grip handle wider than shoulders", "Pull handle to upper chest", "Squeeze lats at bottom", "Control weight on return"]'),

-- Shoulders exercises
('Dumbbell Shoulder Press', 'shoulders', 'Primary movement for shoulder mass and strength. Develops powerful overhead pressing capability.',
 'intermediate', 10, 50, 4, 10, 'https://example.com/images/shoulder-press.jpg',
 'dumbbells', 'push', 'intermediate', 'compound',
 '["Sit or stand with dumbbells at shoulders", "Press weight straight overhead", "Fully extend arms at top", "Lower with control to shoulders", "Keep core braced"]'),

('Lateral Raises', 'shoulders', 'Isolation for shoulder width. Important for developing the dome shape of shoulders.',
 'beginner', 7, 35, 3, 12, 'https://example.com/images/lateral-raises.jpg',
 'dumbbells', 'push', 'beginner', 'isolation',
 '["Stand holding dumbbells at sides", "Raise arms out to sides", "Raise to shoulder level", "Slight elbow bend", "Lower slowly and controlled"]'),

('Front Raises', 'shoulders', 'Targeted work for front delts for complete shoulder development. Complements pressing movements.',
 'beginner', 7, 35, 3, 12, 'https://example.com/images/front-raises.jpg',
 'dumbbells', 'push', 'beginner', 'isolation',
 '["Stand with dumbbells in front of thighs", "Raise weight forward and up", "Raise to shoulder level", "Keep arms straight", "Lower back to starting position"]'),

('Rear Delt Flyes', 'shoulders', 'Often neglected rear delt isolation. Important for shoulder health and balanced development.',
 'intermediate', 8, 40, 3, 15, 'https://example.com/images/rear-delt-flyes.jpg',
 'dumbbells', 'pull', 'intermediate', 'isolation',
 '["Hinge at hips with dumbbells hanging", "Raise arms out to sides", "Squeeze shoulder blades together", "Focus on rear delts", "Lower with control"]'),

-- Core exercises
('Plank', 'core', 'Isometric exercise for core stability and endurance. Essential for core strength.',
 'beginner', 5, 25, 3, 1, 'https://example.com/images/plank.jpg',
 'bodyweight', 'static', 'beginner', 'isolation',
 '["Assume plank position on forearms", "Keep body in straight line", "Engage core and squeeze glutes", "Hold position without sagging", "Breathe steadily throughout"]'),

('Crunches', 'core', 'Classic ab exercise for developing upper abdominals. Excellent for creating six-pack definition.',
 'beginner', 6, 30, 3, 20, 'https://example.com/images/crunches.jpg',
 'bodyweight', 'pull', 'beginner', 'isolation',
 '["Lie on back with knees bent", "Place hands behind head", "Lift shoulders off ground", "Focus on contracting abs", "Lower back down with control"]'),

('Russian Twists', 'core', 'Rotational exercise for developing obliques. Builds core strength and rotational power.',
 'intermediate', 7, 40, 3, 20, 'https://example.com/images/russian-twists.jpg',
 'bodyweight', 'pull', 'intermediate', 'isolation',
 '["Sit with knees bent and feet lifted", "Lean back slightly", "Hold weight at chest", "Rotate torso side to side", "Touch weight to ground on each side"]'),

('Leg Raises', 'core', 'Targeted work for lower abs for complete core development. Challenging movement for advanced definition.',
 'intermediate', 7, 35, 3, 15, 'https://example.com/images/leg-raises.jpg',
 'bodyweight', 'pull', 'intermediate', 'isolation',
 '["Lie flat on back", "Keep legs straight", "Raise legs to 90 degrees", "Lower slowly without touching floor", "Keep lower back pressed down"]'),

-- Full Body exercises
('Burpees', 'full body', 'High-intensity full body movement. Burns maximum calories while building strength and endurance.',
 'advanced', 8, 60, 3, 10, 'https://example.com/images/burpees.jpg',
 'bodyweight', 'push', 'advanced', 'compound',
 '["Start standing", "Drop to push-up position", "Do a push-up", "Jump feet forward", "Explosive jump with hands overhead"]'),

('Mountain Climbers', 'full body', 'Dynamic exercise combining cardio and core strength. Excellent for conditioning and fat burning.',
 'intermediate', 6, 50, 3, 20, 'https://example.com/images/mountain-climbers.jpg',
 'bodyweight', 'push', 'intermediate', 'compound',
 '["Start in plank position", "Bring one knee to chest", "Quickly switch legs", "Maintain plank position", "Keep core engaged"]'),

('Jumping Jacks', 'full body', 'Classic cardio exercise for warm-up and conditioning. Increases heart rate and burns calories.',
 'beginner', 5, 40, 3, 30, 'https://example.com/images/jumping-jacks.jpg',
 'bodyweight', 'push', 'beginner', 'compound',
 '["Start standing with feet together", "Jump spreading feet and raising arms", "Jump back to starting position", "Maintain steady rhythm", "Keep core engaged"]'),

('Kettlebell Swings', 'full body', 'Explosive hip hinge movement. Develops power, strength and cardiovascular endurance.',
 'intermediate', 8, 55, 3, 15, 'https://example.com/images/kettlebell-swings.jpg',
 'kettlebell', 'pull', 'intermediate', 'compound',
 '["Stand with feet shoulder-width apart", "Grip kettlebell with both hands", "Hinge at hips and swing back", "Explosively drive hips forward", "Swing kettlebell to shoulder level"]');

-- Linking exercises with muscles (simplified approach)
-- Bicep exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Dumbbell Bicep Curls' AND m.name = 'Biceps';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'secondary'::text
FROM exercises e, muscles m
WHERE e.name = 'Dumbbell Bicep Curls' AND m.name = 'Forearms';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Hammer Curls' AND m.name = 'Biceps';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Concentration Curls' AND m.name = 'Biceps';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Preacher Curls' AND m.name = 'Biceps';

-- Chest exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Bench Press' AND m.name = 'Chest';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Push-ups' AND m.name = 'Chest';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Incline Bench Press' AND m.name = 'Chest';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Dumbbell Flyes' AND m.name = 'Chest';

-- Leg exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Squats' AND m.name = 'Quadriceps';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Lunges' AND m.name = 'Quadriceps';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Leg Press' AND m.name = 'Quadriceps';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Calf Raises' AND m.name = 'Calves';

-- Back exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Deadlifts' AND m.name = 'Back';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Pull-ups' AND m.name = 'Lats';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Bent-over Barbell Rows' AND m.name = 'Middle Back';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Lat Pulldowns' AND m.name = 'Lats';

-- Shoulder exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Dumbbell Shoulder Press' AND m.name = 'Shoulders';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Lateral Raises' AND m.name = 'Side Delts';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Front Raises' AND m.name = 'Front Delts';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Rear Delt Flyes' AND m.name = 'Rear Delts';

-- Core exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Plank' AND m.name = 'Core';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Crunches' AND m.name = 'Abs';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Russian Twists' AND m.name = 'Obliques';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Leg Raises' AND m.name = 'Abs';

-- Full body exercises
INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Burpees' AND m.name = 'Full Body';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Mountain Climbers' AND m.name = 'Core';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Jumping Jacks' AND m.name = 'Full Body';

INSERT INTO exercise_muscle (exercise_id, muscle_id, role)
SELECT e.id, m.id, 'primary'::text
FROM exercises e, muscles m
WHERE e.name = 'Kettlebell Swings' AND m.name = 'Glutes';

-- Linking exercises with equipment
-- Dumbbell exercises
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name IN ('Dumbbell Bicep Curls', 'Hammer Curls', 'Concentration Curls', 'Preacher Curls', 'Dumbbell Shoulder Press', 'Lateral Raises', 'Front Raises', 'Rear Delt Flyes')
AND eq.name = 'dumbbells';

-- Barbell exercises
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name IN ('Bench Press', 'Deadlifts', 'Bent-over Barbell Rows') AND eq.name = 'barbell';

-- Kettlebell exercises
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name = 'Kettlebell Swings' AND eq.name = 'kettlebell';

-- Bodyweight exercises
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name IN ('Push-ups', 'Squats', 'Lunges', 'Calf Raises', 'Pull-ups', 'Plank', 'Crunches', 'Russian Twists', 'Leg Raises', 'Burpees', 'Mountain Climbers', 'Jumping Jacks')
AND eq.name = 'bodyweight';

-- Machine exercises
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name IN ('Leg Press', 'Lat Pulldowns') AND eq.name = 'machine';

-- Bench (for bench exercises)
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name IN ('Bench Press', 'Incline Bench Press', 'Dumbbell Flyes') AND eq.name = 'bench';

-- Pull-up bar
INSERT INTO exercise_equipment (exercise_id, equipment_id)
SELECT DISTINCT e.id, eq.id
FROM exercises e, equipment eq
WHERE e.name = 'Pull-ups' AND eq.name = 'pull-up bar';

-- Output results
SELECT
    'Exercises inserted: ' || COUNT(*) as result
FROM exercises
WHERE created_at >= CURRENT_TIMESTAMP - INTERVAL '1 minute';

SELECT
    'Muscles linked: ' || COUNT(*) as muscles_linked
FROM exercise_muscle;

SELECT
    'Equipment linked: ' || COUNT(*) as equipment_linked
FROM exercise_equipment;
