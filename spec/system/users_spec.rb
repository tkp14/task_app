require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('ユーザー登録')
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content 'ユーザー登録'
      end
    end
  end
end
