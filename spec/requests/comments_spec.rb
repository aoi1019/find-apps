require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @app = FactoryBot.create(:app)
    @comment = FactoryBot.create(:comment, user_id: @user.id, app_id: @app.id)
  end

  context 'コメントの登録' do
    context 'ログインしている場合' do
    end

    context 'ログインしていない場合' do
      it 'コメントは登録できず、ログインページにリダイレクトすることを確認' do
        expect{
          post comments_path, params: { app_id: @app.id, 
                                        comment: { content: "いいアプリですね！"} }
          }.not_to change(@app.comments, :count)
          expect(response).to redirect_to login_path
      end
    end
  end

  context 'コメントの削除' do
    context 'ログインしている場合' do
    end

    context 'ログインしていない場合' do
      it 'コメントの削除はできず、ログインページにリダイレクトすることを確認' do
        expect{
          delete comment_path(@comment)

        }.not_to change(@app.comments, :count)
      end
    end
  end
end
