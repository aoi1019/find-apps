require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app  = FactoryBot.create(:app)
  end

  context 'お気に入り一覧ページの表示' do
    context 'ログインしている場合' do
      it 'レスポンスが正常に表示されること' do
        login_for_request(@user)
        get favorites_path
        expect(response.status).to eq 200
        expect(response).to render_template("favorites/index")
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面にリダイレクトすることを確認' do
        get favorites_path
        expect(response.status).not_to eq 200
        expect(response).to redirect_to login_path
      end
    end
  end

  context 'お気に入り登録' do
    context 'ログインしている場合' do
      before do
        login_for_request(@user)
      end

      it 'アプリのお気に入り登録ができることを確認' do
        expect {
          post "/favorites/#{@app.id}/create"
        }.to change(Favorite, :count).by(1)
      end

      it 'アプリのAjaxによるお気に入り登録ができることを確認' do
        expect {
          post "/favorites/#{@app.id}/create", xhr: true
        }.to change(Favorite, :count).by(1)
      end

      it 'アプリのお気に入り登録を解除できることを確認' do
        @user.favorite(@app)
        expect {
          delete "/favorites/#{@app.id}/destroy"
        }.to change(Favorite, :count).by(-1)
      end

      it 'アプリのAjaxによるお気に入り登録を解除できることを確認' do
        @user.favorite(@app)
        expect {
          delete "/favorites/#{@app.id}/destroy", xhr: true
        }.to change(Favorite, :count).by(-1)
      end
    end

    context 'ログインしていない場合' do
      it 'お気に入り登録はできず、ログインページへリダイレクトすることを確認' do
        expect {
          post "/favorites/#{@app.id}/create"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end

      it 'お気に入り解除はできず、ログインページへリダイレクトすることを確認' do
        expect {
          delete "/favorites/#{@app.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
