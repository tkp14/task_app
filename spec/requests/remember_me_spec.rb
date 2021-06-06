require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "永続セッション" do
    context "ログインしたままにチェックしてログインする場合" do
      before do
        login_remember(user)
      end

      it "remember_tokenが空でないことを確認" do
        expect(response.cookies['remember_token']).not_to eq nil
      end

      it "セッションがnilのときでもcurrent_userが正しいユーザーを指すことを確認" do
        expect(current_user).to eq user
        expect(is_logged_in?).to be_truthy
      end
    end

    context "ログインしたままにチェックしていないでログインする場合" do
      it "remember_tokenが空であることを確認" do
        # クッキーを保存してログイン
        login_remember(user)
        delete logout_path
        # クッキーを保存しないでログイン
        post login_path, params: { session: { email: "xxx@example.com",
                                              password: user.password,
                                              remember_me: '0' } }
        expect(response.cookies['remember_token']).to eq nil
      end
    end

    context "ログアウトする場合" do
      it "ログイン中のみログアウトできること" do
        login_for_request(user)
        expect(response).to redirect_to user_path(user)
        delete logout_path
        expect(response).to redirect_to root_path
        expect(session[:user_id]).to eq nil
        # 2番目のウィンドウでログアウトする
        delete logout_path
        expect(response).to redirect_to root_path
        expect(session[:user_id]).to eq nil
      end
    end
  end
end
