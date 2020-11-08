class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :app
  validates :user_id, presence: true
  validates :app_id, presence: true
end
