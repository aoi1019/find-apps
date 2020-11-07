require 'rails-helper'

RSpec.describe 'ユーザーフォロー機能' , type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインしていない場合' do
    it 'followingページに移動するとログインページにリダイレクトされることを確認する' do
      get following_user_path(@user)
      expect(response).to redirect_to login_path
    end

    it 'followersページに移動するとログインページにリダイレクトされることを確認する' do
      get followers_user_path(@user)
      expect(response).to redirect_to login_path
    end
  end
end