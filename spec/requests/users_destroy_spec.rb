require 'rails_helper'

RSpec.describe "ユーザー一覧", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  context "管理者ユーザーの場合" do
    it "ユーザーを削除後、ユーザー一覧ページにリダイレクト" do
      login_for_request(admin_user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to users_url
      follow_redirect!
      expect(response).to render_template('users/index')
    end
  end

  context "管理者ではないがログインユーザーの場合" do
    it "自分のアカウントを削除後、ホームページにリダイレクト" do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to root_url
    end

    it "他のユーザーは削除できず、ホームページにリダイレクト" do
      login_for_request(user)
      expect {
        delete user_path(other_user)
      }.not_to change(User, :count)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end

  context "ログインユーザーではない場合" do
    it "削除はできず、ログインページへリダイレクトされること" do
      expect {
        delete user_path(user)
      }.not_to change(User, :count)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
    end
  end
end
