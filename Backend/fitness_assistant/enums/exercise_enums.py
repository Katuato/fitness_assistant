from enum import Enum


class MuscleRole(str, Enum):
    """Роль мышцы в упражнении"""

    PRIMARY = "primary"
    SECONDARY = "secondary"


class ExerciseForce(str, Enum):
    """Тип мышечного сокращения"""

    PUSH = "push"
    PULL = "pull"
    STATIC = "static"


class ExerciseMechanic(str, Enum):
    """Механика выполнения упражнения"""

    COMPOUND = "compound"
    ISOLATION = "isolation"


class ExerciseLevel(str, Enum):
    """Уровень сложности упражнения"""

    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"
