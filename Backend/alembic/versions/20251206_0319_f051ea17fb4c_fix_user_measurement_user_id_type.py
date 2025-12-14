"""fix user_measurement user_id type

Revision ID: f051ea17fb4c
Revises: 360e4ad4e3c6
Create Date: 2025-12-06 03:19:01.592896

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


revision: str = 'f051ea17fb4c'
down_revision: Union[str, None] = '360e4ad4e3c6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.alter_column('user_mesurments', 'user_id',
               existing_type=sa.BIGINT(),
               type_=sa.Integer(),
               existing_nullable=False)


def downgrade() -> None:
    op.alter_column('user_mesurments', 'user_id',
               existing_type=sa.Integer(),
               type_=sa.BIGINT(),
               existing_nullable=False)

