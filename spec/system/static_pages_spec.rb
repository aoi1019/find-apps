require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "FindAppsの文字列が存在することを確認" do
        expect(page).to have_content 'FindApps'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end

      context "アプリフィード", js: true do
        before do
          @user = FactoryBot.create(:user)
          @app = FactoryBot.create(:app, user: @user)
        end

        it "アプリのぺージネーションが表示されること" do
          login_for_system(@user)
          create_list(:app, 6, user: @user)
          visit root_path
          expect(page).to have_content("アプリ一覧 (#{@user.apps.count})")
          expect(page).to have_css "div.pagination"
          App.take(5).each do |d|
            expect(page).to have_link d.name
          end
        end
      end
    end
  end

  describe "ヘルプページ" do
    before do
      visit about_path
    end

    it "FindAppsとは？の文字列が存在することを確認" do
      expect(page).to have_content 'FindAppsとは？'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('FindAppsとは？')
    end
  end

  describe "利用規約ページ" do
    before do
      visit use_of_terms_path
    end

    it "利用規約の文字列が存在することを確認" do
      expect(page).to have_content '利用規約'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('利用規約')
    end
  end
end
