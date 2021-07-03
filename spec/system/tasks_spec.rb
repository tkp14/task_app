require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:task) { create(:task, :picture, user: user) }

  describe "タスクの投稿について" do
    before do
      login_for_system(user)
      visit root_path
      click_link "タスクを投稿する"
    end

    context "タスクの投稿ページ" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('タスクの投稿')
      end

      it "タスクの投稿の文字列が表示されていること" do
        expect(page).to have_content "タスクの投稿"
      end
    end

    context "タスクの投稿" do
      it "有効なデータでタスクの投稿を行うと成功する場合" do
        fill_in "タスク名", with: "今日の積み上げ"
        fill_in "タスクの内容", with: "筋トレを行う"
        attach_file 'task[picture]', "#{Rails.root}/spec/fixtures/test_task.jpg"
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
    context "ページレイアウト（認可されたユーザーの場合)", js: true do
      before do
        login_for_system(user)
        visit root_path
        click_link task.name
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title task.name
      end

      it "タスクの名前と内容が表示されていること" do
        expect(page).to have_content task.name
        expect(page).to have_content task.introduction
        expect(page).to have_link nil, href: task_path(task), class: 'task-picture'
      end

      it "編集リンクが表示されていること" do
        expect(page).to have_link "編集", href: edit_task_path(task)
      end

      it "削除リンクが表示されており、タスクを削除できること" do
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "タスクの削除をしました"
      end
    end

    context "認可されていないユーザーの場合" do
      it "編集リンクと削除リンクが表示されていないこと" do
        login_for_system(other_user)
        visit user_path(user)
        expect(page).not_to have_link "編集"
        expect(page).not_to have_link "削除"
      end
    end
  end

  describe "タスクの編集について" do
    before do
      login_for_system(user)
      visit task_path(task)
      click_link '編集'
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("タスクの編集")
      end

      it "タスクの編集の文字列が表示されていること" do
        expect(page).to have_content "タスクの編集"
      end
    end

    context "タスクの更新処理" do
      it "有効なデータでタスクの更新が成功する場合" do
        fill_in "タスク名", with: "明日の予定"
        fill_in "タスクの内容", with: "朝、散歩にいく"
        attach_file 'task[picture]', "#{Rails.root}/spec/fixtures/test_task2.jpg"
        click_button "更新する"
        expect(page).to have_content "タスクを更新しました！"
        expect(task.reload.name).to eq "明日の予定"
        expect(task.reload.introduction).to eq "朝、散歩にいく"
        expect(task.reload.picture.url).to include "test_task2.jpg"
      end

      it "無効なデータでタスクの更新が失敗する場合" do
        fill_in "タスク名", with: ""
        fill_in "タスクの内容", with: ""
        click_button "更新する"
        expect(task.reload.name).not_to eq ""
        expect(task.reload.introduction).not_to eq ""
        expect(page).to have_content "タスク名を入力してください"
        expect(page).to have_content "タスクの内容を入力してください"
      end
    end

    context "タスクの削除処理", js: true do
      it "「タスクを削除する」のリンクによってタスクを削除できること" do
        click_link "タスクを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "タスクの削除をしました"
      end
    end
  end
end
