require 'rails_helper'

RSpec.describe Favorite, type: :model do
  before do
    @favorite = FactoryBot.create(:favorite)
  end

  it 'favoriteインスタンスが有効であることを確認' do
    expect(@favorite).to be_valid
  end

  it 'user_idがnilの場合、無効であることを確認' do
    @favorite.user_id = nil
    expect(@favorite).not_to be_valid
  end

  it 'app_idがnilの場合、無効であることを確認' do
    @favorite.app_id = nil
    expect(@favorite).not_to be_valid
  end
end
