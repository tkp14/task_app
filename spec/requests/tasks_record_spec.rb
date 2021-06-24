require 'rails_helper'

RSpec.describe "タスクの投稿", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  context "ログインしている場合" do
    before do
      login_for_request(user)
      get new_task_path
    end

    it "正常なレスポンスを返すこと" do
      expect(response).to have_http_status(200)
      expect(response).to render_template('tasks/new')
    end

    it "有効なデータの場合は投稿できること" do
      expect {
        post tasks_path, params: { task: { name: "今日の積み上げ",
                                           introduction: "筋トレをする"} }
      }.to change(Task, :count).by(1)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end

    it "無効なデータの場合は投稿できないこと" do
      expect {
        post tasks_path, params: { task: { name: "",
                                           introduction: ""} }
      }.not_to change(Task, :count)
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
