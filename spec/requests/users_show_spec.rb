require 'rails_helper'

RSpec.describe "プロフィールページ", type: :request do
  let!(:user) { create(:user) }

  it "正常なレスポンスを返すこと" do
    get user_path(user)
    expect(response).to be_success
    expect(response).to render_template('users/show')
  end
end
