require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  describe "タスクページ" do
    before do
      login_for_system(user)
      visit root_path
      click_link "タスクを投稿する"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title('タスクの投稿')
      end

      it "タスクの投稿の文字列が表示されていること" do
        expect(page).to have_content "タスクの投稿"
      end
    end
  end
end
