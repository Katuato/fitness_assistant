"""add new table for exercises

Revision ID: 8528d6796c8e
Revises: f051ea17fb4c
Create Date: 2025-12-15 01:36:30.884179

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision: str = '8528d6796c8e'
down_revision: Union[str, None] = 'f051ea17fb4c'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table('user_daily_plans',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('plan_date', sa.Date(), nullable=False),
    sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
    sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('user_measurements',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=False),
    sa.Column('measured_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
    sa.Column('weight', sa.Text(), nullable=True),
    sa.Column('height', sa.Text(), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('plan_exercises',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('plan_id', sa.Integer(), nullable=False),
    sa.Column('exercise_id', sa.Integer(), nullable=False),
    sa.Column('sets', sa.Integer(), nullable=False),
    sa.Column('reps', sa.Integer(), nullable=False),
    sa.Column('order_index', sa.Integer(), nullable=False),
    sa.Column('is_completed', sa.Boolean(), nullable=False),
    sa.Column('completed_at', sa.DateTime(timezone=True), nullable=True),
    sa.ForeignKeyConstraint(['exercise_id'], ['exercises.id'], ),
    sa.ForeignKeyConstraint(['plan_id'], ['user_daily_plans.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.drop_table('user_mesurments')
    op.add_column('exercises', sa.Column('description', sa.Text(), nullable=True))
    op.add_column('exercises', sa.Column('difficulty', sa.Text(), nullable=True))
    op.add_column('exercises', sa.Column('estimated_duration', sa.Integer(), nullable=True))
    op.add_column('exercises', sa.Column('calories_burn', sa.Integer(), nullable=True))
    op.add_column('exercises', sa.Column('default_sets', sa.Integer(), nullable=True))
    op.add_column('exercises', sa.Column('default_reps', sa.Integer(), nullable=True))
    op.add_column('exercises', sa.Column('image_url', sa.Text(), nullable=True))
    op.add_column('sessions', sa.Column('accuracy', sa.Integer(), nullable=True))
    op.add_column('sessions', sa.Column('body_part', sa.Text(), nullable=True))



def downgrade() -> None:

    op.drop_column('sessions', 'body_part')
    op.drop_column('sessions', 'accuracy')
    op.drop_column('exercises', 'image_url')
    op.drop_column('exercises', 'default_reps')
    op.drop_column('exercises', 'default_sets')
    op.drop_column('exercises', 'calories_burn')
    op.drop_column('exercises', 'estimated_duration')
    op.drop_column('exercises', 'difficulty')
    op.drop_column('exercises', 'description')
    op.create_table('user_mesurments',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('user_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('measured_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.text('now()'), autoincrement=False, nullable=False),
    sa.Column('weight', sa.TEXT(), autoincrement=False, nullable=True),
    sa.Column('height', sa.TEXT(), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], name=op.f('user_mesurments_user_id_fkey')),
    sa.PrimaryKeyConstraint('id', name=op.f('user_mesurments_pkey'))
    )
    op.drop_table('plan_exercises')
    op.drop_table('user_measurements')
    op.drop_table('user_daily_plans')

