require 'rails_helper'

RSpec.describe "タスクの詳細", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  context "認可されたユーザーの場合" do
    it "正常なレスポンスを返すこと" do
      login_for_request(user)
      get task_path(task)
      expect(response).to have_http_status "200"
      expect(response).to render_template('tasks/show')
    end
  end

  context "認可されていないユーザーの場合" do
    it "ログインページへリダイレクトされること" do
      get task_path(task)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_url
    end
  end
end
