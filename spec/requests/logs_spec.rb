require 'rails_helper'

RSpec.describe "Logs", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
    @log = FactoryBot.create(:log)
  end

  context '開発ログ登録' do
    context 'ログインしている場合' do
      
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
    context 'ログインしている場合' do
      
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
