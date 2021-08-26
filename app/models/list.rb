class List < ApplicationRecord
  belongs_to :user
  belongs_to :task
  validates :user_id, presence: true
  validates :task_id, presence: true
  validates :from_user_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
