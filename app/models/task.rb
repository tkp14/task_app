class Task < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates  :user_id, presence: true
  validates  :name, presence: true, length: { maximum: 50 }
  validates  :introduction, presence: true, length: { maximum: 200 }
end
