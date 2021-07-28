require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:task) { create(:task, user: user) }

  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('ユーザー登録')
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content 'ユーザー登録'
      end
    end

    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録する"
        expect(page).to have_content "タスクシェアへようこそ！"
      end

      it "無効なユーザーでユーザー登録を行うとユーザー登録失敗のフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "プロフィールページ" do
    before do
      login_for_system(user)
      create_list(:task, 10, user: user)
      visit user_path(user)
    end

    context "ページレイアウト" do
      it "「プロフィール」の文字列が存在することを確認" do
        expect(page).to have_content 'プロフィール'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end

      it "自分のページにプロフィール編集のリンクがあること" do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end

      it "タスクの件数が表示されていること" do
        expect(page).to have_content "タスク(#{user.tasks.count})"
      end

      it "タスク情報が表示されることを確認" do
        Task.take(5).each do |task|
          expect(page).to have_link user.name
          expect(page).to have_content task.introduction
        end
      end

      it "タスクのページネーションが表示されていることを確認" do
        expect(page).to have_css "div.pagination"
      end

      it "フォローとフォロワーの人数が表示されており、リンクが繋がっていること" do
        expect(page).to have_link "#{user.following.count}人をフォロー", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}人のフォロワー", href: followers_user_path(user)
      end
    end

    context "タスクの削除処理", js: true do
      it "削除リンクによってタスクを削除できること" do
        click_on "削除", match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "タスクの削除をしました"
      end
    end

    context "ユーザーのフォロー/アンフォロー処理", js: true do
      it "ユーザーのフォロー、アンフォローができること" do
        visit user_path(other_user)
        expect(page).to have_button 'フォローする'
        click_button "フォローする"
        expect(page).to have_button 'フォロー中'
        click_button "フォロー中"
        expect(page).to have_button 'フォローする'
      end
    end
  end

  describe "プロフィール編集ページ" do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link "プロフィール編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title('ユーザー編集')
      end

      it "「ユーザー編集」の文字が存在すること" do
        expect(page).to have_content 'ユーザー編集'
      end

      it "有効なデータでプロフィール編集が成功する場合" do
        fill_in "ユーザー名", with: "User"
        fill_in "メールアドレス", with: "taka@gmail.com"
        fill_in "自己紹介", with: "おはようございます"
        click_button "更新する"
        expect(page).to have_content "プロフィールを更新しました！"
        expect(user.reload.name).to eq "User"
        expect(user.reload.email).to eq "taka@gmail.com"
        expect(user.reload.introduction).to eq "おはようございます"
      end

      it "無効なデータでプロフィール編集が失敗する場合" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: ""
        fill_in "自己紹介", with: "おはようございます"
        click_button "更新する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "メールアドレスは不正な値です"
      end
    end

    context "アカウント削除処理", js: true do
      it "正しく削除できること" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "自分のアカウントを削除しました"
      end
    end
  end

  describe "ユーザー一覧ページ" do
    context "管理者ユーザーの場合" do
      it "ぺージネーション、自分以外のユーザーの削除ボタンが表示されること" do
        create_list(:user, 30)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" unless u == admin_user
        end
      end
    end

    context "管理者以外の場合" do
      it "ページネーション、自分のみ削除ボタンが表示されていること" do
        create_list(:user, 30)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          if u == user
            expect(page).to have_content "#{u.name} | 削除"
          else
            expect(page).not_to have_content "#{u.name} | 削除"
          end
        end
      end
    end
  end

  describe "いいね機能" do
    context "いいね登録/解除" do
      before do
        login_for_system(user)
      end

      it "いいねの登録/解除ができること" do
        expect(user.favorite?(task)).to be_falsey
        user.favorite(task)
        expect(user.favorite?(task)).to be_truthy
        user.unfavorite(task)
        expect(user.favorite?(task)).to be_falsey
      end

      it "トップページからお気に入り登録/解除ができること", js: true do
        visit root_path
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{task.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{task.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{task.id}/create"
      end

      it "ユーザー個別ページからお気に入り登録/解除ができること", js: true do
        visit user_path(user)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{task.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{task.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{task.id}/create"
      end

      it "タスク個別ページからお気に入り登録/解除ができること", js: true do
        visit task_path(task)
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{task.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/favorites/#{task.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/favorites/#{task.id}/create"
      end
    end
  end
end
