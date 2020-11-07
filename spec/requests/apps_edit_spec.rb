require "rails_helper"

RSpec.describe "アプリ編集", type: :request do
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/mac2.jpg') }
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
    @other_user = FactoryBot.create(:user)
  end

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること(+フレンドリーフォワーディング)" do
      get edit_app_path(@app)
      login_for_request(@user)
      expect(response).to redirect_to edit_app_url(@app)
      patch app_path(@app), params: { app: { name: "アプリ",
                                             description: "オリジナルアプリです",
                                             point: "Ruby on Railsで開発",
                                             reference: "https://find-apps.herokuapp.com/",
                                             period: 30,
                                             picture: picture2 } }
      redirect_to @app
      follow_redirect!
    end
  end

  context "別アカウントのユーザーの場合" do
    it "ホーム画面にリダイレクトすること" do
      login_for_request(@other_user)
      get edit_app_path(@app)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      patch app_path(@app), params: { app: { name: "アプリ",
                                             description: "オリジナルアプリです",
                                             tips: "Ruby on Railsで開発",
                                             reference: "https://find-apps.herokuapp.com/",
                                             period: 30,
                                             picture: picture2 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get edit_app_path(@app)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      patch app_path(@app), params: { app: { name: "イカの塩焼き",
                                             description: "オリジナルアプリです",
                                             point: "Ruby on Railsで開発",
                                             reference: "https://find-apps.herokuapp.com/",
                                             period: 30,
                                             picture: picture2 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
