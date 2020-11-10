require 'rails_helper'

RSpec.describe "Logs", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app, user: @user)
  end

  context '開発ログ登録' do
    context 'ログインしている場合' do
      context 'アプリを投稿したユーザーである場合' do
        before do
          login_for_request(@user)
        end

        it '有効なログが登録できることを確認' do
          expect{
            post logs_path, params: { app_id: @app.id,
                                      log: { content: "チャット機能を追加" } }
            }.to change(@app.logs, :count).by(1)
            expect(response).to redirect_to app_path(@app)
        end

        it '無効なログが登録できないことを確認' do
          expect{
            post logs_path, params: { app_id: nil,
                                      log: { content: "チャット機能の追加" } }
            }.not_to change(@app.logs, :count)
        end
      end
      context 'アプリを作成したユーザーでない場合' do
        it 'ログ登録ができず、トップページにリダイレクトすることを確認' do
          login_for_request(@other_user)
          expect{
            post logs_path, params: { app_id: @app.id,
                                      log: { content: "チャット機能の追加です" } }
            }.not_to change(@app.logs, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログ登録できず、ログインページへリダイレクトすることを確認' do
        expect{
          post logs_path, params: { app_id: @app.id, 
                                    log: { content: "チャット機能を追加" } }
          }.not_to change(@app.logs, :count)
          expect(response).to redirect_to login_path
      end
    end
  end

  context '開発ログ解除' do
    before do
      @log = FactoryBot.create(:log, app: @app)
    end
    context 'ログインしている場合' do
      context 'ログを作成したユーザーである場合' do
        it 'ログ解除ができることを確認' do
          login_for_request(@user)
          expect{
            delete log_path(@log)
          }.to change(@app.logs, :count).by(-1)
        end
      end
      context 'ログを作成したユーザーでない場合' do
        it 'ログ解除はできず、アプリ詳細ページへリダイレクトすることを確認' do
          login_for_request(@other_user)
          expect{
            delete log_path(@log)
          }.not_to change(@app.logs, :count)
          expect(response).to redirect_to app_path(@app)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログ解除はできず、ログインページへリダイレクトすることを確認' do
        expect{
          delete log_path(@log)
        }.not_to change(@app.logs, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
