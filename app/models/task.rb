class Task < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :introduction, presence: true, length: { maximum: 50 }
end
