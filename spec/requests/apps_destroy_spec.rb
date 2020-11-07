require "rails_helper"

RSpec.describe "アプリの削除", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app, user: @user)
    @other_user = FactoryBot.create(:user)
  end
  # let!(:user) { create(:user) }
  # let!(:other_user) { create(:user) }
  # let!(:app) { create(:app, user: user) }

  context "ログインしていて、自分のアプリを削除する場合" do
    it "処理が成功し、トップページにリダイレクトすること" do
      login_for_request(@user)
      expect {
        delete app_path(@app)
      }.to change(App, :count).by(-1)
      redirect_to user_path(@user)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
  end

  context "ログインしていて、他人のアプリを削除する場合" do
    it "処理が失敗し、トップページへリダイレクトすること" do
      login_for_request(@other_user)
      expect {
        delete app_path(@app)
      }.not_to change(App, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしていない場合" do
    it "ログインページへリダイレクトすること" do
      expect {
        delete app_path(@app)
      }.not_to change(App, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end