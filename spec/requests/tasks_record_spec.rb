require 'rails_helper'

RSpec.describe "タスクについて", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  context "ログインしている場合" do
    it "正常なレスポンスを返すこと" do
      login_for_request(user)
      get new_task_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('tasks/new')
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトされること" do
      get new_task_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
    end
  end
end
