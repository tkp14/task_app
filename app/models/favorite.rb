class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :task
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :task_id, presence: true
end
