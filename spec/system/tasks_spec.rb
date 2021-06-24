require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  describe "タスクの投稿について" do
    before do
      login_for_system(user)
      visit root_path
      click_link "タスクを投稿する"
    end

    context "タスクの投稿ページ" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title('タスクの投稿')
      end

      it "タスクの投稿の文字列が表示されていること" do
        expect(page).to have_content "タスクの投稿"
      end
    end

    context "タスクの投稿" do
      it "有効なデータでタスクの投稿を行うと成功する場合" do
        fill_in "タスク名", with: "今日の積み上げ"
        fill_in "タスクの内容", with: "筋トレを行う"
        click_button "投稿する"
        expect(page).to have_content "タスクの投稿が完了しました！"
        redirect_to root_url
      end

      it "無効なデータで、投稿に失敗する場合" do
        fill_in "タスク名", with: ""
        fill_in "タスクの内容", with: ""
        click_button "投稿する"
        expect(page).to have_content "タスク名を入力してください"
        expect(page).to have_content "タスクの内容を入力してください"
      end
    end
  end

  describe "タスクの詳細について" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit root_path
        click_link task.name
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title task.name
      end

      it "タスクの名前と内容が表示されていること" do
        expect(page).to have_content task.name
        expect(page).to have_content task.introduction
      end
    end
  end
end
