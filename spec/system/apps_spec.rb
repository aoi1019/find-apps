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
          find('input.app-submit').click
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
          find('input.app-submit').click
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

    context 'ログ登録&解除' do
      before do
        @other_user = FactoryBot.create(:user)
      end

      context 'アプリ詳細ページから' do
        it '自分のアプリに対するログ登録&解除が正常に完了することを確認' do
          login_for_system(@user)
          visit app_path(@app)
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          within find("#log-#{Log.first.id}") do
            expect(page).to have_selector 'span', text: "#{@app.logs.count}回目"
            expect(page).to have_selector 'span',
                                          text: %Q(#{Log.last.created_at.strftime("%Y/%m/%d(%a)")})
            expect(page).to have_selector 'span', text: 'ログ投稿テスト'
          end
          expect(page).to have_content "開発ログを追加しました！"
          click_link "削除", href: log_path(Log.first)
          expect(page).not_to have_selector 'span', text: 'ログ投稿テスト'
          expect(page).to have_content "開発ログを削除しました"
        end

        it '別ユーザーのアプリログにはログ登録フォームがないことを確認' do
          login_for_system(@other_user)
          visit app_path(@app)
          expect(page).not_to have_button "追加"
        end
      end

      context 'トップページから' do
        it '自分のアプリに対するログ登録が正常に完了することを確認' do
          login_for_system(@user)
          visit root_path
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq "ログ投稿テスト"
          expect(page).to have_content '開発ログを追加しました！'
        end

        it '別ユーザーのアプリには登録フォームがないことを確認' do
          create(:app, user: @other_user)
          login_for_system(@user)
          @user.follow(@other_user)
          visit root_path
          within find("#app-#{App.first.id}") do
            expect(page).to have_button "追加"
          end
        end
      end

      context 'プロフィールページから' do
        it '自分のアプリに対するログ登録が正常に完了すること' do
          login_for_system(@user)
          visit user_path(@user)
          fill_in "log_content", with: "ログ投稿テスト"
          click_button "追加"
          expect(Log.first.content).to eq "ログ投稿テスト"
          expect(page).to have_content "開発ログを追加しました！"
        end
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

  context '検索機能' do
    context 'ログインしている場合' do
      before do
        login_for_system(@user)
        visit root_path
      end

      it 'ログイン後の各ページに検索窓が表示されていることを確認' do
        expect(page).to have_css 'form#app_search'
        visit about_path
        expect(page).to have_css 'form#app_search'
        visit use_of_terms_path
        expect(page).to have_css 'form#app_search'
        visit users_path
        expect(page).to have_css 'form#app_search'
        visit user_path(@user)
        expect(page).to have_css 'form#app_search'
        visit edit_user_path(@user)
        expect(page).to have_css 'form#app_search'
        visit following_user_path(@user)
        expect(page).to have_css 'form#app_search'
        visit followers_user_path(@user)
        expect(page).to have_css 'form#app_search'
        visit apps_path
        expect(page).to have_css 'form#app_search'
        visit app_path(@app)
        expect(page).to have_css 'form#app_search'
        visit new_app_path
        expect(page).to have_css 'form#app_search'
        visit edit_app_path(@app)
        expect(page).to have_css 'form#app_search'
      end
    end
    context 'ログインしていない場合' do
      it '検索フォームが表示されないことを確認' do
        visit root_path
        expect(page).not_to have_css 'form#app_search'
      end
    end
  end
end
