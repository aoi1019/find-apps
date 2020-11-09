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

end
