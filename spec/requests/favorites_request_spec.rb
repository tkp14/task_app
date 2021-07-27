require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe "お気に入り登録処理" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "お気に入り登録できること" do
        expect {
          post "/favorites/#{task.id}/create"
        }.to change(Favorite, :count).by(1)
      end

      it "Ajaxによるお気に入り登録できること" do
        expect {
          post "/favorites/#{task.id}/create", xhr: true
        }.to change(Favorite, :count).by(1)
      end

      it "お気に入りの解除ができること" do
        expect {
          delete "/favorites/#{task.id}/destroy"
        }.to change(Favorite, :count).by(-1)
      end

      it "Ajaxによるお気に入りの解除ができること" do
        expect {
          delete "/favorites/#{task.id}/destroy", xhr: true
        }.to change(Favorite, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "お気に入り登録は実行できず、ログインページへリダイレクトすること" do
        expect {
          post "/favorites/#{task.id}/create"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end

      it "お気に入り解除は実行できず、ログインページへリダイレクトすること" do
        expect {
          delete "/favorites/#{task.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
