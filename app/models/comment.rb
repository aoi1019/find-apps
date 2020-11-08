class Comment < ApplicationRecord
belongs_to :user
belongs_to :app
validates :app_id, presence: true
validates :user_id, presence: true
validates :content, presence: true, length: { maximum: 50 }
end
