"""empty message

Revision ID: 269587bfce53
Revises: 
Create Date: 2020-07-15 04:52:30.090934

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '269587bfce53'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('users',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('username', sa.String(), nullable=True),
    sa.Column('first_name', sa.String(), nullable=True),
    sa.Column('last_name', sa.String(), nullable=True),
    sa.Column('password', sa.String(), nullable=True),
    sa.Column('email', sa.String(), nullable=True),
    sa.Column('api_key', sa.String(), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('username')
    )
    op.create_table('graphs',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('user_id', sa.Integer(), nullable=True),
    sa.Column('data', sa.String(), nullable=True),
    sa.Column('typedata', sa.String(), nullable=True),
    sa.Column('date', sa.String(), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('graphs')
    op.drop_table('users')
    # ### end Alembic commands ###