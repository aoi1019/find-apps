require 'rails_helper'

RSpec.describe Log, type: :model do
  before do
    @log = FactoryBot.create(:log)
  end

  context 'バリデーション' do
    it '有効な状態であることを確認' do
      expect(@log).to be_valid
    end

    it 'app_idがなければ無効な状態であることを確認' do
      @log.app_id = nil
      expect(@log).not_to be_valid
    end
  end
end
