from enum import Enum


class MediaType(str, Enum):
    """Перечисление типов медиа файлов"""

    IMAGE = "image"
    GIF = "gif"
    VIDEO = "video"
    THUMBNAIL = "thumbnail"
