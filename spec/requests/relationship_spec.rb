require 'rails_helper'

RSpec.describe 'ユーザーフォロー機能', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
  end

  context 'ログインしている場合' do
    before do
      login_for_request(@user)
    end

    it 'ユーザーのフォローができることを確認' do
      expect {
        post relationships_path, params: { followed_id: @other_user.id }
      }.to change(Relationship, :count).by(1)
    end
    it 'ユーザーのAjaxによるフォローができることを確認' do
      expect {
        post relationships_path, xhr: true, params: { followed_id: @other_user.id }
      }.to change { @user.following.count }.by(1)
    end
    it 'ユーザーのアンフォローができることを確認' do
      @user.follow(@other_user)
      relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by(-1)
    end
    it 'ユーザーのAjaxによるアンフォローができることを確認' do
      @user.follow(@other_user)
      relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
      expect {
        delete relationship_path(relationship), xhr: true
      }.to change { @user.following.count }.by(-1)
    end
  end

  context 'ログインしていない場合' do
    it 'followingページに移動するとログインページにリダイレクトすることを確認する' do
      get following_user_path(@user)
      expect(response).to redirect_to login_path
    end

    it 'followersページに移動するとログインページにリダイレクトすることを確認する' do
      get followers_user_path(@user)
      expect(response).to redirect_to login_path
    end

    it 'createアクションは実行できず、ログインページへリダイレクトすることを確認' do
      expect {
        post relationships_path
      }.not_to change(Relationship, :count)
      expect(response).to redirect_to login_path
    end
    it 'destroyアクションは実行できず、ログインページへリダイレクトすることを確認する' do
      expect {
        delete relationship_path(@user)
      }.not_to change(Relationship, :count)
      expect(response).to redirect_to login_path
    end
  end
end
