require 'rails_helper'

RSpec.describe "プロフィール編集", type: :request do
  let!(:user) { create(:user) }

  before do
    get edit_user_path(user)
  end

  it "正常なレスポンスを返すこと" do
    expect(response).to be_success
    expect(response).to render_template('users/edit')
  end

  it "有効なプロフィール更新の場合" do
    patch user_path(user), params: { user: { name: "Example User",
                                              email: "user@example.com",
                                              introduction: "こんにちは" } }
    redirect_to user
    follow_redirect!
    expect(response).to render_template('users/show')
  end

  it "無効なプロフィール更新の場合" do
    patch user_path(user), params: { user: { name: "",
                                              email: "user@example.com",
                                              introduction: "こんにちは" } }
    expect(response).to render_template('users/edit')
  end
end
