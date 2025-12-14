//
//  ExerciseCategory.swift
//  fitness_assistant
//
//  Created by Andrej Novoseltsev on 04.12.2025.
//

import Foundation
import SwiftUI

// MARK: - Exercise Category

struct ExerciseCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ExerciseCategory, rhs: ExerciseCategory) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Exercise with Category

struct CategorizedExercise: Identifiable {
    let id = UUID()
    let name: String
    let category: ExerciseCategory
    let targetMuscles: [String]
    let description: String
    let instructions: [String]
    let sets: Int
    let reps: Int
    let difficulty: ExercisePreviewData.DifficultyLevel
    let estimatedDuration: Int
    let caloriesBurn: Int
    let imageURL: String?
    
    /// Convert to Exercise model for HomeView
    func toExercise() -> Exercise {
        Exercise(
            name: name,
            sets: sets,
            reps: reps,
            accuracy: nil,
            isCompleted: false
        )
    }
    
    /// Convert to ExercisePreviewData for detail view
    func toPreviewData() -> ExercisePreviewData {
        ExercisePreviewData(
            id: id,
            exercise: toExercise(),
            targetMuscles: targetMuscles,
            description: description,
            instructions: instructions,
            videoThumbnailURL: imageURL,
            videoURL: nil,
            difficulty: difficulty,
            estimatedDuration: estimatedDuration,
            caloriesBurn: caloriesBurn
        )
    }
}

// MARK: - Mock Data

extension ExerciseCategory {
    static let biceps = ExerciseCategory(
        name: "Biceps",
        icon: "figure.strengthtraining.traditional",
        color: Color(red: 0xE4/255, green: 0x7E/255, blue: 0x18/255)
    )
    
    static let chest = ExerciseCategory(
        name: "Chest",
        icon: "figure.strengthtraining.functional",
        color: Color(red: 0x39/255, green: 0xD9/255, blue: 0x63/255)
    )
    
    static let legs = ExerciseCategory(
        name: "Legs",
        icon: "figure.walk",
        color: Color.blue
    )
    
    static let back = ExerciseCategory(
        name: "Back",
        icon: "figure.cooldown",
        color: Color.purple
    )
    
    static let shoulders = ExerciseCategory(
        name: "Shoulders",
        icon: "figure.flexibility",
        color: Color.cyan
    )
    
    static let core = ExerciseCategory(
        name: "Core",
        icon: "figure.core.training",
        color: Color.pink
    )
    
    static let fullBody = ExerciseCategory(
        name: "Full Body",
        icon: "figure.mixed.cardio",
        color: Color.indigo
    )
    
    static let allCategories: [ExerciseCategory] = [
        .biceps, .chest, .legs, .back, .shoulders, .core, .fullBody
    ]
}

extension CategorizedExercise {
    // MARK: - Biceps Exercises
    static let bicepCurl = CategorizedExercise(
        name: "Bicep Curl",
        category: .biceps,
        targetMuscles: ["Biceps", "Forearms"],
        description: "Classic isolation exercise for building bigger, stronger biceps. Perfect for developing arm strength and definition.",
        instructions: [
            "Stand with feet shoulder-width apart",
            "Hold dumbbells with palms facing forward",
            "Keep elbows close to torso",
            "Curl weights up to shoulder level",
            "Lower with control to starting position"
        ],
        sets: 3,
        reps: 12,
        difficulty: .beginner,
        estimatedDuration: 8,
        caloriesBurn: 35,
        imageURL: nil
    )
    
    static let hammerCurl = CategorizedExercise(
        name: "Hammer Curl",
        category: .biceps,
        targetMuscles: ["Biceps", "Brachialis", "Forearms"],
        description: "Targets the brachialis muscle for overall arm thickness. Great for building functional strength.",
        instructions: [
            "Stand holding dumbbells at sides",
            "Keep palms facing each other",
            "Curl weights up keeping neutral grip",
            "Squeeze at the top",
            "Lower slowly and controlled"
        ],
        sets: 3,
        reps: 10,
        difficulty: .beginner,
        estimatedDuration: 7,
        caloriesBurn: 30,
        imageURL: nil
    )
    
    static let concentrationCurl = CategorizedExercise(
        name: "Concentration Curl",
        category: .biceps,
        targetMuscles: ["Biceps Peak"],
        description: "Isolated movement for maximum bicep peak development. Eliminates momentum for pure muscle contraction.",
        instructions: [
            "Sit on bench with legs spread",
            "Rest elbow on inner thigh",
            "Curl dumbbell toward shoulder",
            "Focus on squeezing bicep",
            "Lower with complete control"
        ],
        sets: 3,
        reps: 12,
        difficulty: .intermediate,
        estimatedDuration: 9,
        caloriesBurn: 40,
        imageURL: nil
    )
    
    static let preacherCurl = CategorizedExercise(
        name: "Preacher Curl",
        category: .biceps,
        targetMuscles: ["Biceps", "Brachialis"],
        description: "Eliminates swinging for strict bicep isolation. Excellent for building muscle mass and definition.",
        instructions: [
            "Position arms on preacher bench pad",
            "Grip barbell with underhand grip",
            "Curl up keeping arms on pad",
            "Squeeze at peak contraction",
            "Lower until arms nearly straight"
        ],
        sets: 3,
        reps: 10,
        difficulty: .intermediate,
        estimatedDuration: 10,
        caloriesBurn: 45,
        imageURL: nil
    )
    
    // MARK: - Chest Exercises
    static let benchPress = CategorizedExercise(
        name: "Bench Press",
        category: .chest,
        targetMuscles: ["Chest", "Triceps", "Shoulders"],
        description: "The king of chest exercises. Builds mass and strength across the entire upper body.",
        instructions: [
            "Lie flat on bench with feet on floor",
            "Grip bar slightly wider than shoulders",
            "Lower bar to mid-chest with control",
            "Press up explosively to start position",
            "Keep shoulder blades retracted"
        ],
        sets: 4,
        reps: 10,
        difficulty: .intermediate,
        estimatedDuration: 12,
        caloriesBurn: 60,
        imageURL: nil
    )
    
    static let pushUps = CategorizedExercise(
        name: "Push-Ups",
        category: .chest,
        targetMuscles: ["Chest", "Triceps", "Core"],
        description: "Bodyweight classic that builds strength anywhere. Perfect for building functional pressing power.",
        instructions: [
            "Start in plank position",
            "Hands slightly wider than shoulders",
            "Lower chest to ground",
            "Keep core tight and back straight",
            "Push back up to starting position"
        ],
        sets: 3,
        reps: 15,
        difficulty: .beginner,
        estimatedDuration: 6,
        caloriesBurn: 40,
        imageURL: nil
    )
    
    static let inclineBench = CategorizedExercise(
        name: "Incline Bench Press",
        category: .chest,
        targetMuscles: ["Upper Chest", "Shoulders", "Triceps"],
        description: "Targets upper chest for a complete pectoral development. Essential for balanced chest growth.",
        instructions: [
            "Set bench to 30-45 degree angle",
            "Lie back with feet planted",
            "Grip bar at shoulder width",
            "Lower to upper chest",
            "Press up in straight line"
        ],
        sets: 4,
        reps: 10,
        difficulty: .intermediate,
        estimatedDuration: 11,
        caloriesBurn: 55,
        imageURL: nil
    )
    
    static let dumbbellFlyes = CategorizedExercise(
        name: "Dumbbell Flyes",
        category: .chest,
        targetMuscles: ["Chest", "Front Shoulders"],
        description: "Isolation movement for chest stretch and definition. Great for building width and detail.",
        instructions: [
            "Lie on flat bench holding dumbbells",
            "Start with arms extended above chest",
            "Lower weights in arc to sides",
            "Feel deep stretch in chest",
            "Squeeze chest to bring weights back up"
        ],
        sets: 3,
        reps: 12,
        difficulty: .intermediate,
        estimatedDuration: 9,
        caloriesBurn: 45,
        imageURL: nil
    )
    
    // MARK: - Legs Exercises
    static let squats = CategorizedExercise(
        name: "Squats",
        category: .legs,
        targetMuscles: ["Quadriceps", "Glutes", "Hamstrings", "Core"],
        description: "The king of leg exercises. Builds functional strength and mobility while developing powerful legs.",
        instructions: [
            "Stand with feet shoulder-width apart",
            "Keep your chest up and core engaged",
            "Lower down as if sitting in a chair",
            "Push through heels to return to start",
            "Maintain neutral spine throughout"
        ],
        sets: 4,
        reps: 12,
        difficulty: .intermediate,
        estimatedDuration: 10,
        caloriesBurn: 55,
        imageURL: nil
    )
    
    static let lunges = CategorizedExercise(
        name: "Lunges",
        category: .legs,
        targetMuscles: ["Quadriceps", "Glutes", "Hamstrings"],
        description: "Unilateral movement for balanced leg development. Improves stability and functional strength.",
        instructions: [
            "Stand tall with feet hip-width apart",
            "Step forward with one leg",
            "Lower hips until both knees at 90 degrees",
            "Push back to starting position",
            "Alternate legs for each rep"
        ],
        sets: 3,
        reps: 10,
        difficulty: .beginner,
        estimatedDuration: 8,
        caloriesBurn: 45,
        imageURL: nil
    )
    
    static let legPress = CategorizedExercise(
        name: "Leg Press",
        category: .legs,
        targetMuscles: ["Quadriceps", "Glutes", "Hamstrings"],
        description: "Machine exercise for safely loading heavy weight. Perfect for building mass and strength.",
        instructions: [
            "Sit in leg press machine",
            "Place feet shoulder-width on platform",
            "Release safety and lower weight",
            "Push through heels to extend legs",
            "Don't lock knees at top"
        ],
        sets: 4,
        reps: 12,
        difficulty: .intermediate,
        estimatedDuration: 10,
        caloriesBurn: 50,
        imageURL: nil
    )
    
    static let calfRaises = CategorizedExercise(
        name: "Calf Raises",
        category: .legs,
        targetMuscles: ["Calves", "Gastrocnemius"],
        description: "Isolation movement for calf development. Essential for balanced lower leg strength.",
        instructions: [
            "Stand with balls of feet on elevated surface",
            "Keep core engaged and upright",
            "Rise up onto toes as high as possible",
            "Hold peak contraction briefly",
            "Lower heels below platform level"
        ],
        sets: 3,
        reps: 15,
        difficulty: .beginner,
        estimatedDuration: 6,
        caloriesBurn: 30,
        imageURL: nil
    )
    
    // MARK: - Back Exercises
    static let deadlifts = CategorizedExercise(
        name: "Deadlifts",
        category: .back,
        targetMuscles: ["Back", "Hamstrings", "Glutes", "Core"],
        description: "The ultimate compound movement. Builds total body strength and develops proper hip hinge mechanics.",
        instructions: [
            "Stand with feet hip-width apart",
            "Hinge at hips and grip the bar",
            "Engage lats and brace your core",
            "Drive through heels to stand tall",
            "Control the weight back down"
        ],
        sets: 4,
        reps: 8,
        difficulty: .advanced,
        estimatedDuration: 12,
        caloriesBurn: 70,
        imageURL: nil
    )
    
    static let pullUps = CategorizedExercise(
        name: "Pull-Ups",
        category: .back,
        targetMuscles: ["Lats", "Biceps", "Upper Back"],
        description: "Classic bodyweight exercise for back width and strength. Fundamental for upper body development.",
        instructions: [
            "Hang from bar with palms facing away",
            "Engage lats and pull shoulder blades down",
            "Pull chin over bar",
            "Lower with control to full extension",
            "Avoid swinging or kipping"
        ],
        sets: 3,
        reps: 10,
        difficulty: .intermediate,
        estimatedDuration: 8,
        caloriesBurn: 50,
        imageURL: nil
    )
    
    static let bentOverRow = CategorizedExercise(
        name: "Bent Over Row",
        category: .back,
        targetMuscles: ["Middle Back", "Lats", "Rhomboids"],
        description: "Compound movement for back thickness. Develops powerful pulling strength and posture.",
        instructions: [
            "Hinge at hips with slight knee bend",
            "Grip barbell at shoulder width",
            "Pull bar to lower chest",
            "Squeeze shoulder blades together",
            "Lower with control"
        ],
        sets: 4,
        reps: 10,
        difficulty: .intermediate,
        estimatedDuration: 10,
        caloriesBurn: 55,
        imageURL: nil
    )
    
    static let latPulldown = CategorizedExercise(
        name: "Lat Pulldown",
        category: .back,
        targetMuscles: ["Lats", "Biceps", "Upper Back"],
        description: "Machine exercise for lat width and V-taper. Great for building pull-up strength.",
        instructions: [
            "Sit at lat pulldown machine",
            "Grip bar wider than shoulders",
            "Pull bar down to upper chest",
            "Squeeze lats at bottom",
            "Control weight back up"
        ],
        sets: 3,
        reps: 12,
        difficulty: .beginner,
        estimatedDuration: 9,
        caloriesBurn: 45,
        imageURL: nil
    )
    
    // MARK: - Shoulders Exercises
    static let shoulderPress = CategorizedExercise(
        name: "Shoulder Press",
        category: .shoulders,
        targetMuscles: ["Shoulders", "Triceps", "Upper Chest"],
        description: "Primary movement for shoulder mass and strength. Builds powerful overhead pressing ability.",
        instructions: [
            "Sit or stand with dumbbells at shoulders",
            "Press weights straight overhead",
            "Fully extend arms at top",
            "Lower with control to shoulders",
            "Keep core tight throughout"
        ],
        sets: 4,
        reps: 10,
        difficulty: .intermediate,
        estimatedDuration: 10,
        caloriesBurn: 50,
        imageURL: nil
    )
    
    static let lateralRaises = CategorizedExercise(
        name: "Lateral Raises",
        category: .shoulders,
        targetMuscles: ["Side Delts", "Shoulders"],
        description: "Isolation for shoulder width. Essential for developing that capped shoulder look.",
        instructions: [
            "Stand holding dumbbells at sides",
            "Raise arms out to sides",
            "Lift to shoulder height",
            "Slight bend in elbows",
            "Lower slowly and controlled"
        ],
        sets: 3,
        reps: 12,
        difficulty: .beginner,
        estimatedDuration: 7,
        caloriesBurn: 35,
        imageURL: nil
    )
    
    static let frontRaises = CategorizedExercise(
        name: "Front Raises",
        category: .shoulders,
        targetMuscles: ["Front Delts", "Shoulders"],
        description: "Targets front deltoids for complete shoulder development. Complements pressing movements.",
        instructions: [
            "Stand with dumbbells in front of thighs",
            "Raise weights forward and up",
            "Lift to shoulder height",
            "Keep arms straight",
            "Lower back to start position"
        ],
        sets: 3,
        reps: 12,
        difficulty: .beginner,
        estimatedDuration: 7,
        caloriesBurn: 35,
        imageURL: nil
    )
    
    static let rearDeltFlyes = CategorizedExercise(
        name: "Rear Delt Flyes",
        category: .shoulders,
        targetMuscles: ["Rear Delts", "Upper Back"],
        description: "Often neglected rear delt isolation. Important for shoulder health and balanced development.",
        instructions: [
            "Bend at hips with dumbbells hanging",
            "Raise arms out to sides",
            "Squeeze shoulder blades together",
            "Focus on rear delts",
            "Lower with control"
        ],
        sets: 3,
        reps: 15,
        difficulty: .intermediate,
        estimatedDuration: 8,
        caloriesBurn: 40,
        imageURL: nil
    )
    
    // MARK: - Core Exercises
    static let plank = CategorizedExercise(
        name: "Plank",
        category: .core,
        targetMuscles: ["Core", "Abs", "Lower Back"],
        description: "Isometric core exercise for stability and endurance. Fundamental for core strength.",
        instructions: [
            "Get into push-up position on forearms",
            "Keep body in straight line",
            "Engage core and squeeze glutes",
            "Hold position without sagging",
            "Breathe steadily throughout"
        ],
        sets: 3,
        reps: 1, // Duration based
        difficulty: .beginner,
        estimatedDuration: 5,
        caloriesBurn: 25,
        imageURL: nil
    )
    
    static let crunches = CategorizedExercise(
        name: "Crunches",
        category: .core,
        targetMuscles: ["Upper Abs", "Core"],
        description: "Classic ab exercise for upper abdominal development. Great for building six-pack definition.",
        instructions: [
            "Lie on back with knees bent",
            "Place hands behind head",
            "Lift shoulders off ground",
            "Focus on contracting abs",
            "Lower back down with control"
        ],
        sets: 3,
        reps: 20,
        difficulty: .beginner,
        estimatedDuration: 6,
        caloriesBurn: 30,
        imageURL: nil
    )
    
    static let russianTwists = CategorizedExercise(
        name: "Russian Twists",
        category: .core,
        targetMuscles: ["Obliques", "Core", "Abs"],
        description: "Rotational exercise for oblique development. Builds core strength and rotational power.",
        instructions: [
            "Sit with knees bent and feet elevated",
            "Lean back slightly",
            "Hold weight at chest",
            "Rotate torso side to side",
            "Touch weight to ground each side"
        ],
        sets: 3,
        reps: 20,
        difficulty: .intermediate,
        estimatedDuration: 7,
        caloriesBurn: 40,
        imageURL: nil
    )
    
    static let legRaises = CategorizedExercise(
        name: "Leg Raises",
        category: .core,
        targetMuscles: ["Lower Abs", "Hip Flexors"],
        description: "Targets lower abs for complete core development. Challenging movement for advanced definition.",
        instructions: [
            "Lie flat on back",
            "Keep legs straight",
            "Raise legs to 90 degrees",
            "Lower slowly without touching floor",
            "Keep lower back pressed down"
        ],
        sets: 3,
        reps: 15,
        difficulty: .intermediate,
        estimatedDuration: 7,
        caloriesBurn: 35,
        imageURL: nil
    )
    
    // MARK: - Full Body Exercises
    static let burpees = CategorizedExercise(
        name: "Burpees",
        category: .fullBody,
        targetMuscles: ["Full Body", "Cardio", "Core"],
        description: "High intensity full body movement. Burns maximum calories while building strength and endurance.",
        instructions: [
            "Start standing",
            "Drop into push-up position",
            "Perform push-up",
            "Jump feet forward",
            "Explosive jump with arms overhead"
        ],
        sets: 3,
        reps: 10,
        difficulty: .advanced,
        estimatedDuration: 8,
        caloriesBurn: 60,
        imageURL: nil
    )
    
    static let mountainClimbers = CategorizedExercise(
        name: "Mountain Climbers",
        category: .fullBody,
        targetMuscles: ["Core", "Shoulders", "Cardio"],
        description: "Dynamic exercise combining cardio and core strength. Great for conditioning and fat burning.",
        instructions: [
            "Start in plank position",
            "Drive one knee toward chest",
            "Quickly switch legs",
            "Maintain plank position",
            "Keep core engaged"
        ],
        sets: 3,
        reps: 20,
        difficulty: .intermediate,
        estimatedDuration: 6,
        caloriesBurn: 50,
        imageURL: nil
    )
    
    static let jumpingJacks = CategorizedExercise(
        name: "Jumping Jacks",
        category: .fullBody,
        targetMuscles: ["Full Body", "Cardio"],
        description: "Classic cardio exercise for warm-up and conditioning. Elevates heart rate and burns calories.",
        instructions: [
            "Start standing with feet together",
            "Jump feet apart while raising arms",
            "Jump back to starting position",
            "Maintain steady rhythm",
            "Keep core engaged"
        ],
        sets: 3,
        reps: 30,
        difficulty: .beginner,
        estimatedDuration: 5,
        caloriesBurn: 40,
        imageURL: nil
    )
    
    static let kettlebellSwings = CategorizedExercise(
        name: "Kettlebell Swings",
        category: .fullBody,
        targetMuscles: ["Glutes", "Hamstrings", "Core", "Shoulders"],
        description: "Explosive hip hinge movement. Develops power, strength, and cardiovascular fitness.",
        instructions: [
            "Stand with feet shoulder-width apart",
            "Hold kettlebell with both hands",
            "Hinge at hips and swing back",
            "Drive hips forward explosively",
            "Swing kettlebell to shoulder height"
        ],
        sets: 3,
        reps: 15,
        difficulty: .intermediate,
        estimatedDuration: 8,
        caloriesBurn: 55,
        imageURL: nil
    )
    
    // MARK: - All Exercises by Category
    static func exercisesByCategory(_ category: ExerciseCategory) -> [CategorizedExercise] {
        switch category.name {
        case "Biceps":
            return [bicepCurl, hammerCurl, concentrationCurl, preacherCurl]
        case "Chest":
            return [benchPress, pushUps, inclineBench, dumbbellFlyes]
        case "Legs":
            return [squats, lunges, legPress, calfRaises]
        case "Back":
            return [deadlifts, pullUps, bentOverRow, latPulldown]
        case "Shoulders":
            return [shoulderPress, lateralRaises, frontRaises, rearDeltFlyes]
        case "Core":
            return [plank, crunches, russianTwists, legRaises]
        case "Full Body":
            return [burpees, mountainClimbers, jumpingJacks, kettlebellSwings]
        default:
            return []
        }
    }
}
