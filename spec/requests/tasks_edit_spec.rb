require 'rails_helper'

RSpec.describe "タスクの編集", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      login_for_request(user)
      get edit_task_path(task)
      patch task_path(task), params: { task: { name: "今日の積み上げ",
                                               introduction: "頑張ります" } }
      redirect_to task
      follow_redirect!
      expect(response).to render_template('tasks/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクトされること" do
      #編集
      get edit_task_path(task)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
      #更新
      patch task_path(task), params: { task: { name: "今日の積み上げ",
                                               introduction: "頑張ります" } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_path
    end
  end
end
