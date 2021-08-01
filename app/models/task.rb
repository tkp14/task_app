class Task < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates  :user_id, presence: true
  validates  :name, presence: true, length: { maximum: 50 }
  validates  :introduction, presence: true, length: { maximum: 200 }
  validate   :picture_size

  private

    # アップロードされた画像のサイズを制限する
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "：5MBより大きい画像はアップロードできません。")
      end
    end
end
