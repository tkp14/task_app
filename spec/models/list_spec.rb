require 'rails_helper'

RSpec.describe List, type: :model do
  let!(:list) { create(:list) }

  context "バリデーション" do
    it "有効な関係であること" do
      expect(list).to be_valid
    end

    it "user_idがnilの場合は無効であること" do
      list.user_id = nil
      expect(list).not_to be_valid
    end

    it "task_idがnilの場合は無効であること" do
      list.task_id = nil
      expect(list).not_to be_valid
    end

    it "from_user_idがnilの場合は無効であること" do
      list.from_user_id = nil
      expect(list).not_to be_valid
    end
  end
end
