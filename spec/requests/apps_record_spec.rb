require "rails_helper"

RSpec.describe "アプリ登録", type: :request do

  before do
    @user = FactoryBot.create(:user)
    # @app = FactoryBot.create(:app)
  end
  # let!(:user) { create(:user) }
  # let!(:app) { create(:app, user: user) }

  context "ログインしているユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      login_for_request(@user)
      get new_app_path
      expect(response.status).to eq 200
      expect(response).to render_template('apps/new')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get new_app_path
      expect(response.status).not_to eq 200
      expect(response).to redirect_to login_path
    end
  end
end