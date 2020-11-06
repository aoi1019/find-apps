require 'rails_helper'

RSpec.describe "Apps", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
  end
  # let!(:user) { create(:user) }
  # let!(:app) { create(:app, user: user) }

  describe "アプリ登録ページ" do
    before do
      login_for_system(@user)
      visit new_app_path
    end

    context "ページレイアウト" do
      it "「アプリ登録」の文字列が存在すること" do
        expect(page).to have_content 'アプリ登録'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('アプリ登録')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'アプリ名'
        expect(page).to have_content '説明'
        expect(page).to have_content '技術的ポイント'
        expect(page).to have_content 'アプリURL'
        expect(page).to have_content '開発日数 [日]'
      end
    end

    context "アプリ登録処理" do
      it "有効な情報でアプリ登録を行うとアプリ登録成功のフラッシュが表示されること" do
        fill_in "アプリ名", with: "イカの塩焼き"
        fill_in "説明", with: "オリジナルアプリです"
        fill_in "技術的ポイント", with: "Ruby on Railsで開発"
        fill_in "アプリURL", with: "https://find-apps.herokuapp.com/"
        fill_in "開発日数", with: 30
        click_button "登録する"
        expect(page).to have_content "アプリが登録されました！"
      end

      it "無効な情報でアプリ登録を行うとアプリ登録失敗のフラッシュが表示されること" do
        fill_in "アプリ名", with: ""
        fill_in "説明", with: "オリジナルアプリです"
        fill_in "技術的ポイント", with: "Ruby on Railsで開発"
        fill_in "アプリURL", with: "https://find-apps.herokuapp.com/"
        fill_in "開発日数", with: 30
        click_button "登録する"
        expect(page).to have_content "アプリ名を入力してください"
      end
    end
  end
  describe "アプリ詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(@user)
        visit app_path(@app)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{@app.name}")
      end

      it "アプリ情報が表示されること" do
        expect(page).to have_content @app.name
        expect(page).to have_content @app.description
        expect(page).to have_content @app.point
        expect(page).to have_content @app.reference
        expect(page).to have_content @app.period
      end
    end
  end
end