require 'rails_helper'

RSpec.describe "通知機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe "通知一覧ページ" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "通知一覧ページが正しく表示されること" do
        get notifications_path
        expect(response).to have_http_status "200"
        expect(response).to render_template('notifications/index')
      end
    end

    context "ログインユーザーではない場合" do
      it "通知一覧ページが表示されず、ログインページへリダイレクトされること" do
        get notifications_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end
end
