require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:task) { create(:task) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(task).to be_valid
    end

    it "名前がなければ無効なこと" do
      task = build(:task, name: nil)
      task.valid?
      expect(task.errors[:name]).to include("を入力してください")
    end

    it "名前が50文字以内であること" do
      task = build(:task, name: "a" * 51)
      task.valid?
      expect(task.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "introductionがなければ無効であること" do
      task = build(:task, introduction: nil)
      task.valid?
      expect(task.errors[:introduction]).to include("を入力してください")
    end

    it "introductionが50文字以内であること" do
      task = build(:task, introduction: "a" * 51)
      task.valid?
      expect(task.errors[:introduction]).to include("は50文字以内で入力してください")
    end
  end
end
