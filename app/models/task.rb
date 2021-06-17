class Task < ApplicationRecord
  belongs_to :user
  validates  :user_id, presence: true
  validates  :name, presence: true, length: { maximum: 50 }
  validates  :introduction, presence: true, length: { maximum: 50 }
  association :user
end
