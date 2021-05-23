require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページレイアウト" do
      before do
        visit root_path
      end

      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content "タスクシェア"
      end
    end
  end

  describe "タスクシェアとは？ページ" do
    context "ページレイアウト" do
      before do
        visit about_path
      end

      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title('タスクシェアとは？')
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content "タスクシェアとは？"
      end
    end
  end

  describe "使い方ページ" do
    context "ページレイアウト" do
      before do
        visit help_path
      end

      it "正しいタイトルが表示されていること" do
        expect(page).to have_title full_title('使い方')
      end

      it "正しい文字列が表示されていること" do
        expect(page).to have_content "タスクシェアの使い方"
      end
    end
  end
end
