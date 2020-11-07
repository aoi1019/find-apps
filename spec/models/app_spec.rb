require 'rails_helper'

RSpec.describe App, type: :model do
  let!(:app) { create(:app) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(app).to be_valid
    end

    it "名前がなければ無効な状態であること" do
      app = build(:app, name: nil)
      app.valid?
      expect(app.errors[:name]).to include("を入力してください")
    end

    it "名前が30文字以内であること" do
      app = build(:app, name: "あ" * 31)
      app.valid?
      expect(app.errors[:name]).to include("は30文字以内で入力してください")
    end

    it "説明が140文字以内であること" do
      app = build(:app, description: "あ" * 141)
      app.valid?
      expect(app.errors[:description]).to include("は140文字以内で入力してください")
    end

    it "コツ・ポイントが50文字以内であること" do
      app = build(:app, point: "あ" * 51)
      app.valid?
      expect(app.errors[:point]).to include("は50文字以内で入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      app = build(:app, user_id: nil)
      app.valid?
      expect(app.errors[:user_id]).to include("を入力してください")
    end
  end
end
