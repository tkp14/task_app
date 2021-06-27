require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページレイアウト" do
      before do
        visit root_path
      end

      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content "タスクシェア"
      end
    end

    context "タスクフィード", js: true do
      let!(:user) { create(:user) }
      let!(:task) { create(:task, user: user) }

      it "タスクのぺージネーションが表示されること" do
        login_for_system(user)
        create_list(:task, 10, user: user)
        visit root_path
        expect(page).to have_content "みんなのタスク (#{user.tasks.count})"
        Task.take(5).each do |task|
          expect(page).to have_link user.name
          expect(page).to have_content task.introduction
        end
          expect(page).to have_css "div.pagination"
      end

      it "タスクを投稿するボタンが表示されていること" do
        login_for_system(user)
        visit root_path
        expect(page).to have_link "タスクを投稿する", href: new_task_path
      end

      it "削除リンクで削除できること", js: true do
        login_for_system(user)
        visit root_path
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "タスクの削除をしました"
      end
    end
  end

  describe "タスクシェアとは？ページ" do
    context "ページレイアウト" do
      before do
        visit about_path
      end

      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title('タスクシェアとは？')
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content "タスクシェアとは？"
      end
    end
  end

  describe "使い方ページ" do
    context "ページレイアウト" do
      before do
        visit help_path
      end

      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title('使い方')
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content "タスクシェアの使い方"
      end
    end
  end
end
