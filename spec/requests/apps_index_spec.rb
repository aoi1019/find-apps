require "rails_helper"

RSpec.describe "料理一覧ページ", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
  end

  context 'ログインしているユーザーの場合' do
    it 'レスポンスが正常に表示されることを確認' do
      login_for_request(@user)
      get apps_path
      expect(response.status).to eq 200
      expect(response).to render_template('apps/index')
    end
  end

  context 'ログインしていないユーザーの場合' do
    it 'ログイン画面にリダイレクトすること' do
      get apps_path
      expect(response.status).not_to eq 200
      expect(response).to redirect_to login_path
    end
  end
end