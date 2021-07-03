require 'rails_helper'

RSpec.describe "タスクの編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test_task2.jpg') }
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること+フレンドリーフォワーディング" do
      get edit_task_path(task)
      login_for_request(user)
      expect(request).to redirect_to edit_task_path(task)
      patch task_path(task), params: { task: { name: "今日の積み上げ",
                                               introduction: "頑張ります",
                                               picture: picture2 } }
      redirect_to task
      follow_redirect!
      expect(response).to render_template('tasks/show')
    end
  end

  context "ログインユーザーではあるが本人ではない場合" do
    it "ホームページへリダイレクトされること" do
      #編集
      login_for_request(other_user)
      get edit_task_path(task)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_url
      #更新
      patch task_path(task), params: { task: { name: "今日の積み上げ",
                                               introduction: "頑張ります" } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_url
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクトされること" do
      #編集
      get edit_task_path(task)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_url
      #更新
      patch task_path(task), params: { task: { name: "今日の積み上げ",
                                               introduction: "頑張ります" } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_url
    end
  end
end
