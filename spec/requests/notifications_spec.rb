require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  context '通知一覧ページの表示' do
    context 'ログインしている場合' do
      before do
        login_for_request(@user)
      end

      it '正常にレスポンスが表示されることを確認' do
        get notifications_path
        expect(response.status).to eq 200
      end
    end

    context 'ログインしていない場合' do
      it 'レスポンスが表示されないことを確認' do
        get notifications_path
        expect(response.status).not_to eq 200
        expect(response).to redirect_to login_path
      end
    end
  end

  context '通知処理' do
    before do
      login_for_request(@user)
      @app = FactoryBot.create(:app)
      @other_user = FactoryBot.create(:user)
      @other_app = FactoryBot.create(:app, user: @other_user)
    end

    context "自分以外のユーザーのアプリに対して" do
      it "お気に入り登録によって通知が作成されること" do
        post "/favorites/#{@other_app.id}/create"
        expect(@user.reload.notification).to be_falsey
        expect(@other_user.reload.notification).to be_truthy
      end

      it "コメントによって通知が作成されること" do
        post comments_path, params: { app_id: @other_app.id,
                                      comment: { content: "良いアプリですね" } }
        expect(@user.reload.notification).to be_falsey
        expect(@other_user.reload.notification).to be_truthy
      end
    end

    context "自分のアプリに対して" do
      it "お気に入り登録によって通知が作成されないこと" do
        post "/favorites/#{@app.id}/create"
        expect(@user.reload.notification).to be_falsey
      end

      it "コメントによって通知が作成されないこと" do
        post comments_path, params: { app_id: @app.id,
                                      comment: { content: "良いアプリですね" } }
        expect(@user.reload.notification).to be_falsey
      end
    end
  end
end
