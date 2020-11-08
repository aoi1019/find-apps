require 'rails_helper'

RSpec.describe "お気に入り登録機能", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app  = FactoryBot.create(:app)
  end

  context 'お気に入り登録' do
    context 'ログインしていない場合' do
      it 'お気に入り登録はできず、ログインページへリダイレクトすることを確認' do
        expect{
          post "/favorites/#{@app.id}/create"
        }.not_to change{Favorite.count}
        expect(response).to redirect_to login_path
      end

      it 'お気に入り解除はできず、ログインページへリダイレクトすることを確認' do
        expect{
          delete "/favorites/#{@app.id}/destroy"
        }.not_to change{Favorite.count}
        expect(response).to redirect_to login_path
      end
    end
  end
end
