require 'rails_helper'

RSpec.describe "プロフィールページ", type: :request do
  let!(:user) { create(:user) }

  context "ログインしているユーザーの場合" do
    it "正常なレスポンスを返すこと" do
      login_for_request(user)
      get user_path(user)
      expect(response).to be_success
      expect(response).to render_template('users/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクトされること" do
      get user_path(user)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
    end
  end
end
