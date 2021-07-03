require 'rails_helper'

RSpec.describe "タスクの投稿", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  let(:picture_path) { File.join(Rails.root, 'spec/fixtures/test_task.jpg') }
  let(:picture) { Rack::Test::UploadedFile.new(picture_path) }

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
                                           introduction: "筋トレをする",
                                           picture: picture} }
      }.to change(Task, :count).by(1)
      follow_redirect!
      expect(response).to render_template('tasks/show')
    end

    it "無効なデータの場合は投稿できないこと" do
      expect {
        post tasks_path, params: { task: { name: "",
                                           introduction: "",
                                           picture: picture} }
      }.not_to change(Task, :count)
      expect(response).to render_template('tasks/new')
    end
  end

  context "ログインユーザーのフレンドリーフォワーディングについて" do
    it "正しくリダイレクトされること" do
      get new_task_path
      login_for_request(user)
      expect(request).to redirect_to new_task_url
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
