require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  describe "ログインページ" do
    before do
      visit login_path
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title('ログイン')
      end

      it "正しい文字が表示されること" do
        expect(page).to have_content 'ログイン'
      end

      it "ヘッダーにログインページへのリンクがあること" do
        expect(page).to have_link 'ログイン', href: login_path
      end

      it "ログインフォームのラベルが正しく表示される" do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
      end

      it "ログインフォームが正しく表示される" do
        expect(page).to have_css 'input#user_email'
        expect(page).to have_css 'input#user_password'
      end

      it "ログインボタンが表示される" do
        expect(page).to have_button 'ログイン'
      end
    end

    context "ログイン処理について" do
      it "有効なユーザーの場合はログインできること" do
      end

      it "無効なユーザーの場合はログインできないこと" do

      end
    end
  end
end
