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

      it "ユーザー未登録、パスワードを忘れた人のための表示と正しいURLがあること" do
        expect(page).to have_content 'ユーザー登録がまだの方は'
        expect(page).to have_content 'パスワードを忘れた方は'
        expect(page).to have_link 'こちら', href: signup_path
      end
    end

    context "ログイン処理について" do
      it "有効なユーザーの場合はログインできること&ログイン前後でヘッダーが切り替わること" do
        expect(page).to have_link 'タスクシェアとは？', href: about_path
        expect(page).to have_link 'ユーザー登録(無料)', href: signup_path
        expect(page).to have_link 'ログイン', href: login_path
        expect(page).not_to have_link 'ログアウト', href: logout_path
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "ログイン"
        expect(page).to have_link 'タスクシェアとは？', href: about_path
        expect(page).to have_link 'ユーザー一覧', href: users_path
        expect(page).to have_link 'プロフィール', href: user_path(user)
        expect(page).to have_link 'ログアウト', href: logout_path
        expect(page).not_to have_link 'ログイン', href: login_path
      end

      it "無効なユーザーの場合はログインできないこと" do
        fill_in "user_email", with: "aaa@example.com"
        fill_in "user_password", with: "pass"
        click_button "ログイン"
        expect(page).to have_content 'メールアドレスとパスワードの組み合わせが誤っています'
      end
    end
  end
end
