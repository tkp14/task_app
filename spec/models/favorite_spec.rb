require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let!(:favorite) { create(:favorite) }

  context "バリデーション" do
    it "関係性が有効であること" do
      expect(favorite).to be_valid
    end

    it "user_idがnilの場合は関係性が無効になること" do
      favorite.user_id = nil
      expect(favorite).not_to be_valid
    end

    it "task_idがnilの場合は関係性が無効になること" do
      favorite.task_id = nil
      expect(favorite).not_to be_valid
    end
  end
end
