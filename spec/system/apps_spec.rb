require 'rails_helper'

RSpec.describe "Apps", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app, :picture, user: @user)
  end

  describe 'アプリ登録ページ' do
    before do
      login_for_system(@user)
      visit new_app_path
    end

    context 'ページレイアウト' do
      it 'アプリ登録の文字列があることを確認' do
        expect(page).to have_content('アプリ登録')
      end

      it 'タイトルが正しく表示されているか確認' do
        expect(page).to have_title('アプリ登録')
      end

      it '入力部分のラベルが正しく表示されているか確認' do
        expect(page).to have_content('アプリ名')
        expect(page).to have_content('説明')
        expect(page).to have_content('技術的ポイント')
        expect(page).to have_content('アプリURL')
        expect(page).to have_content('開発日数')
      end
    end

    context 'アプリの新規登録' do
      it '正しい情報を入力すればアプリ投稿ができてアプリ詳細ページに移動する' do
        fill_in 'app_name', with: @app.name
        fill_in 'app_description', with: @app.description
        fill_in 'app_point', with: @app.point
        fill_in 'app_reference', with: @app.reference
        fill_in 'app_period', with: @app.period
        attach_file "app[picture]", "#{Rails.root}/spec/fixtures/mac.jpg"
        expect {
          find('input[name="commit"]').click
        }.to change(App, :count).by(1)
        expect(page).to have_content "アプリが登録されました！"
        expect(page).to have_content(@app.name)
      end
    end

    context 'アプリの新規登録ができないとき' do
      it 'ログインしていないと新規投稿ページに移動できない' do
        visit root_path
        expect(page).not_to have_content('アプリ登録')
      end
      it '無効な情報を入力するとアプリ登録ができない' do
        expect(page).to have_content('アプリ登録')
        fill_in 'app_name', with: ""
        fill_in 'app_description', with: @app.description
        fill_in 'app_point', with: @app.point
        fill_in 'app_reference', with: @app.reference
        fill_in 'app_period', with: @app.period
        expect {
          find('input[name="commit"]').click
        }.to change(App, :count).by(0)
        expect(page).to have_content('アプリ名を入力してください')
      end
    end
  end

  describe 'アプリ詳細ページ' do
    context 'ページレイアウト' do
      before do
        login_for_system(@user)
        visit app_path(@app)
      end

      it '正しいタイトルが表示されることを確認' do
        expect(page).to have_title(@app.name)
      end

      it 'アプリ情報が表示されることを確認' do
        expect(page).to have_content(@app.name)
        expect(page).to have_content(@app.description)
        expect(page).to have_content(@app.point)
        expect(page).to have_content(@app.period)
        expect(page).to have_content(@app.reference)
        expect(page).to have_link nil, href: app_path(@app), class: 'app-picture'
      end
    end

    context 'アプリの削除', js: true do
      before do
        login_for_system(@user)
        visit app_path(@app)
      end

      it '削除成功のフラッシュが出ること' do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'アプリが削除されました'
      end
    end
  end

  describe 'アプリ編集ページ' do
    before do
      login_for_system(@user)
      visit app_path(@app)
    end

    context 'ページレイアウト' do
      it 'アプリ情報が表示されることを確認' do
        expect(page).to have_content(@app.name)
        expect(page).to have_content(@app.description)
        expect(page).to have_content(@app.point)
        expect(page).to have_content(@app.period)
        expect(page).to have_content(@app.reference)
      end
    end

    context '編集ができるか確認' do
      it '有効な更新' do
        click_link "編集"
        fill_in 'app_name', with: @app.name
        fill_in 'app_description', with: @app.description
        fill_in 'app_point', with: @app.point
        fill_in 'app_reference', with: @app.reference
        fill_in 'app_period', with: @app.period
        attach_file "app[picture]", "#{Rails.root}/spec/fixtures/mac2.jpg"
        click_button '更新する'
        expect(@app.reload.picture.url).to include "mac2.jpg"
        expect(current_path).to eq app_path(@app)
      end

      it '無効な更新' do
        click_link "編集"
        fill_in 'app_name', with: ''
        click_button '更新する'
        expect(page).to have_content('アプリ名を入力してください')
      end
    end

    context 'アプリの削除処理', js: true do
      it '削除成功のフラッシュが表示されることを確認' do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'アプリが削除されました'
      end
    end
  end

  context 'コメントの登録・解除' do
    before do
      @comment = FactoryBot.create(:comment, user: @user)
    end

    it '自分のアプリに対するコメントの登録＆削除が正常に完了すること' do
      login_for_system(@user)
        visit app_path(@app)
      fill_in "comment_content", with: "素晴らしいアプリですね"
      click_button 'コメント'
      within find("#comment-#{Comment.last.id}") do
        expect(page).to have_selector 'span', text: @user.name
        expect(page).to have_selector 'span', text: '素晴らしいアプリですね'
      end
      expect(page).to have_content "コメントを追加しました！"
      click_link "削除", href: comment_path(Comment.last)
      expect(page).not_to have_selector 'span', text: '素晴らしいアプリですね'
      expect(page).to have_content "コメントを削除しました"
    end
  end
end
