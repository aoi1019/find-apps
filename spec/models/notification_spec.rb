require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    @notification = FactoryBot.create(:notification)
  end

  it 'notificationインスタンスが有効であること' do
    expect(@notification).to be_valid
  end

  it 'user_idがnilの場合、無効なことを確認' do
    @notification.user_id = nil
    expect(@notification).not_to be_valid
  end

  it 'app_idがnilの場合、無効なことを確認' do
    @notification.app_id = nil
    expect(@notification).not_to be_valid
  end

  it 'varietyがnilの場合、無効なことを確認' do
    @notification.variety = nil
    expect(@notification).not_to be_valid
  end

  it 'from_user_idがnilの場合、無効なことを確認' do
    @notification.from_user_id = nil
    expect(@notification).not_to be_valid
  end
end
