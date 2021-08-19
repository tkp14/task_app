require 'rails_helper'

RSpec.describe "コメント機能", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:task) { create(:task) }
  let!(:comment) { create(:comment, user_id: user.id, task: task) }

  describe "コメント登録" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "有効なものはコメントできること" do
        expect {
          post comments_path, params: { task_id: task.id,
                                        comment: { content: "最高です！" } }
        }.to change(task.comments, :count).by(1)
      end

      it "無効なものはコメントできないこと" do
        expect {
          post comments_path, params: { task_id: task.id,
                                        comment: { content: "" } }
        }.not_to change(task.comments, :count)
      end
    end

    context "ログインしていない場合" do
      it "コメントできずログインページへリダイレクト" do
        expect {
          post comments_path, params: { task_id: task.id,
                                        comment: { content: "最高です！" } }
        }.not_to change(task.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "コメント削除" do
    context "ログインしている場合" do
      it "コメントした本人はコメントを削除できること" do
        login_for_request(user)
        expect {
          delete comment_path(comment)
        }.to change(task.comments, :count).by(-1)
      end

      it "コメントした本人ではない場合はコメントを削除できないこと" do
        login_for_request(other_user)
        expect {
          delete comment_path(comment)
        }.not_to change(task.comments, :count)
      end
    end

    context "ログインしていない場合" do
      it "コメントを削除できずログインページへリダイレクト" do
        expect {
          delete comment_path(comment)
        }.not_to change(task.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
