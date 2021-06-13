require 'rails_helper'

RSpec.describe "プロフィール編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "認可されたユーザーの場合" do
    it "有効なプロフィール更新の場合に正しく更新されること(+フレンドリーフォワーディング)" do
      get edit_user_path(user)
      login_for_request(user)
      expect(response).to redirect_to edit_user_url(user)
      patch user_path(user), params: { user: { name: "Example User",
                                               email: "user@example.com",
                                               introduction: "こんにちは" } }
      redirect_to user
      follow_redirect!
      expect(response).to render_template('users/show')
    end

    it "無効なプロフィール更新の場合は更新できないこと" do
      login_for_request(user)
      get edit_user_path(user)
      patch user_path(user), params: { user: { name: "",
                                                email: "user@example.com",
                                                introduction: "こんにちは" } }
      expect(response).to render_template('users/edit')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクトされること" do
      #編集
      get edit_user_path(user)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
      #更新
      patch user_path(user), params: { user: { name: user.name,
                                               email: user.email } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
    end
  end

  context "認可されていないユーザーの場合" do
    it "ホーム画面へリダイレクトされること" do
      login_for_request(other_user)
      #編集
      get edit_user_path(user)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
      #更新
      patch user_path(user), params: { user: { name: user.name,
                                               email: user.email } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end
end
