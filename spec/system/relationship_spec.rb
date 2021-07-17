require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let!(:user)  { create(:user) }
  let!(:other_users)  { create_list(:user, 20)  }

  describe "フォロー中(following一覧)ページ" do
    before do
      other_users[0..9].each do |other_user|
        user.active_relationships.create!(followed_id: other_user.id)
        user.passive_relationships.create!(follower_id: other_user.id)
      end
      login_for_system(user)
      visit following_user_path(user)
    end

    context "ページレイアウト" do
      it "「フォロー中」の文字列が存在すること" do
        expect(page).to have_content 'フォロー中'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('フォロー中')
      end

      it "ユーザー情報が表示されていること" do
        expect(page).to have_content user.name
        expect(page).to have_link "プロフィール", href: user_path(user)
        expect(page).to have_content "タスク#{user.tasks.count}件"
        expect(page).to have_link "#{user.following.count}人をフォロー", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}人のフォロワー", href: followers_user_path(user)
      end

      it "フォロー中のユーザーが表示されていること" do
        within find('.users') do
          expect(page).to have_css 'li', count: user.following.count
          user.following.each do |u|
            expect(page).to have_link u.name, href: user_path(u)
          end
        end
      end
    end
  end

  describe "フォロワー(followers一覧)ページ" do
    before do
      other_users[0..9].each do |other_user|
        user.active_relationships.create!(followed_id: other_user.id)
        user.passive_relationships.create!(follower_id: other_user.id)
      end
      login_for_system(user)
      visit followers_user_path(user)
    end

    context "ページレイアウト" do
      it "「フォロワー」の文字列が存在すること" do
        expect(page).to have_content 'フォロワー'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('フォロワー')
      end

      it "ユーザー情報が表示されていること" do
        expect(page).to have_content user.name
        expect(page).to have_link "プロフィール", href: user_path(user)
        expect(page).to have_content "タスク#{user.tasks.count}件"
        expect(page).to have_link "#{user.following.count}人をフォロー", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}人のフォロワー", href: followers_user_path(user)
      end

      it "フォロワーが表示されていること" do
        within find('.users') do
          expect(page).to have_css 'li', count: user.followers.count
          user.followers.each do |u|
            expect(page).to have_link u.name, href: user_path(u)
          end
        end
      end
    end
  end
end
