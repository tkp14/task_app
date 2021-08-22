require 'rails_helper'

RSpec.describe "通知機能", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
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

    context "ログインユーザーではない場合" do
      it "通知一覧ページが表示されず、ログインページへリダイレクトされること" do
        get notifications_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "通知処理" do
    before do
      login_for_request(user)
    end

    context "他のユーザーのタスクに対して" do
      it "お気に入りした場合、通知が作成されること" do
        post "/favorites/#{other_task.id}/create"
        expect(user.reload.notification).to be_falsey
        expect(other_user.reload.notification).to be_truthy
      end

      it "コメントした場合、通知が作成されること" do
        post comments_path, params: { task_id: other_task.id,
                                      comment: { content: "最高です！" } }
        expect(user.reload.notification).to be_falsey
        expect(other_user.reload.notification).to be_truthy
      end
    end

    context "自分のタスクに対して" do
      it "お気に入りした場合、通知が作成されないこと" do
        post "/favorites/#{task.id}/create"
        expect(user.reload.notification).to be_falsey
      end

      it "コメントした場合、通知が作成されないこと" do
        post comments_path, params: { task_id: task.id,
                                      comment: { content: "最高です！" } }
        expect(user.reload.notification).to be_falsey
      end
    end
  end
end
