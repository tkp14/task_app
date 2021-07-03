require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:relationship) { create(:relationship) }

  context "バリデーション" do
    it "関係性が有効であること" do
      expect(relationship).to be_valid
    end

    it "follower_idがnilの場合、関係性が無効になること" do
      relationship.follower_id = nil
      expect(relationship).not_to be_valid
    end

    it "followed_idがnilの場合、関係性が無効になること" do
      relationship.followed_id = nil
      expect(relationship).not_to be_valid
    end
  end
end
