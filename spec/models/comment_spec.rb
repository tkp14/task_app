require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) { create(:comment) }

  context "バリデーション" do
    it "関係性が有効であること" do
      expect(comment).to be_valid
    end

    it "user_idがnilの場合は関係性が無効になること" do
      comment.user_id = nil
      expect(comment).not_to be_valid
    end

    it "task_idがnilの場合は関係性が無効になること" do
      comment.task_id = nil
      expect(comment).not_to be_valid
    end

    it "コメントがなければ無効であること" do
      comment = build(:comment, content: nil)
      comment.valid?
      expect(comment.errors[:content]).to include("を入力してください")
    end

    it "コメントは50文字以内であること" do
      comment = build(:comment, content: "a" * 51)
      comment.valid?
      expect(comment.errors[:content]).to include("は50文字以内で入力してください")
    end
  end
end
