require 'rails_helper'

RSpec.describe "タスクの削除", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:task) { create(:task, user: user) }

  context "認可されたユーザーの場合" do
    it "タスクを削除した場合、トップページへリダイレクトされること" do
      login_for_request(user)
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
      redirect_to user_url(user)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
  end

  context "ログインユーザーが他人のユーザーのタスクを削除しようとした場合" do
    it "削除はできず、トップページへリダイレクトされること" do
      login_for_request(other_user)
      expect {
        delete task_path(task)
      }.not_to change(Task, :count)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_url
    end
  end

  context "ログインユーザーではない場合" do
    it "タスクの削除はできず、ログインページへリダイレクトされること" do
      expect {
        delete task_path(task)
      }.not_to change(Task, :count)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_url
    end
  end
end
