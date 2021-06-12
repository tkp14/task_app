require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }

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

    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
        expect(page).to have_content "タスクシェアへようこそ！"
      end

      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        visit user_path(user)
      end

      it "「プロフィール」の文字列が存在することを確認" do
        expect(page).to have_content 'プロフィール'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end

      it "プロフィール編集のボタンがあり、リンクがつながっていること" do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end
    end
  end

  describe "プロフィール編集ページ" do
    before do
      visit user_path(user)
      click_link "プロフィール編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title('ユーザー編集')
      end

      it "「ユーザー編集」の文字が存在すること" do
        expect(page).to have_content 'ユーザー編集'
      end

      it "有効なデータでプロフィール編集が成功する場合" do
        fill_in "ユーザー名", with: "User"
        fill_in "メールアドレス", with: "taka@gmail.com"
        fill_in "自己紹介", with: "おはようございます"
        click_button "更新する"
        expect(page).to have_content "プロフィールを更新しました！"
        expect(user.reload.name).to eq "User"
        expect(user.reload.email).to eq "taka@gmail.com"
        expect(user.reload.introduction).to eq "おはようございます"
      end

      it "無効なデータでプロフィール編集が失敗する場合" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: ""
        fill_in "自己紹介", with: "おはようございます"
        click_button "更新する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "メールアドレスは不正な値です"
      end
    end
  end
end
