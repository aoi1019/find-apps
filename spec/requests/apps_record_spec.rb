require "rails_helper"

RSpec.describe "アプリ登録", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
  end

  context "ログインしているユーザーの場合" do
    before do
      get new_app_path
      login_for_request(@user)
    end

    context 'フレンドリーフォワーディング' do
      it "レスポンスが正常に表示されること" do
        expect(response).to redirect_to new_app_url
      end
    end
    it "有効なアプリデータで登録できること" do
      expect {
        post apps_path, params: { app: {  name: "アプリ",
                                          description: "オリジナルアプリです",
                                          point: "Ruby on Railsで開発",
                                          reference: "https://find-apps.herokuapp.com/",
                                          period: 30} }
      }.to change(App, :count).by(1)
      follow_redirect!
      expect(response).to render_template('apps/show')
    end
    it "無効なアプリデータでは登録できないこと" do
      expect {
        post apps_path, params: { app: {  name: "",
                                          description: "オリジナルアプリです",
                                          point: "Ruby on Railsで開発",
                                          reference: "https://find-apps.herokuapp.com/",
                                          period: 30} }
      }.not_to change(App, :count)
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