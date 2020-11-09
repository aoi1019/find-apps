require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.create(:comment)
  end

  context 'バリデーション' do
    it '有効な状態であることを確認' do
      expect(@comment).to be_valid
    end

    it 'user_idがなければ無効な状態であることを確認' do
      @comment.user_id = nil
      expect(@comment).not_to be_valid
    end

    it 'app_idがなければ無効な状態であることを確認' do
      @comment.app_id = nil
      expect(@comment).not_to be_valid
    end

    it 'contentがなければ無効な状態であることを確認' do
      @comment.content = ""
      expect(@comment).not_to be_valid
    end

    it 'contentが50文字以内である事を確認' do
      @comment.content = "a" * 51
      @comment.valid?
      expect(@comment.errors.full_messages).to include("コメントは50文字以内で入力してください")
    end
  end
end
