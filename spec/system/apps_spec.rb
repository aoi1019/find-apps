require 'rails_helper'

RSpec.describe "Apps", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
  end

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
        fill_in "アプリ名", with: "アプリ"
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
  
  describe "アプリ編集ページ" do
    before do
      login_for_system(@user)
      visit edit_app_path(@app)
      # click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('アプリ情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content 'アプリ名'
        expect(page).to have_content '説明'
        expect(page).to have_content '技術的ポイント'
        expect(page).to have_content 'アプリURL'
        expect(page).to have_content '開発日数'
      end
    end

    context "アプリの更新処理" do
      it "有効な更新" do
        fill_in "アプリ名", with: "編集：アプリ"
        fill_in "説明", with: "編集：オリジナルアプリです"
        fill_in "技術的ポイント", with: "編集：Ruby on Railsで開発"
        fill_in "アプリURL", with: "henshu-https://find-apps.herokuapp.com/"
        fill_in "開発日数", with: 60
        click_button "更新する"
        expect(page).to have_content "アプリ情報が更新されました！"
        expect(@app.reload.name).to eq "編集：アプリ"
        expect(@app.reload.description).to eq "編集：オリジナルアプリです"
        expect(@app.reload.point).to eq "編集：Ruby on Railsで開発"
        expect(@app.reload.reference).to eq "henshu-https://find-apps.herokuapp.com/"
        expect(@app.reload.period).to eq 60
      end

      it "無効な更新" do
        fill_in "アプリ名", with: ""
        click_button "更新する"
        expect(page).to have_content 'アプリ名を入力してください'
        expect(@app.reload.name).not_to eq ""
      end
    end
  end
end