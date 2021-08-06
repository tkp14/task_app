class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task
  validates :user_id, presence: true
  validates :task_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
