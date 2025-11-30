from enum import Enum


class AnalysisStatus(str, Enum):
    """Перечисление статусов задач анализа"""

    QUEUED = "queued"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"
