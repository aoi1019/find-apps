class Log < ApplicationRecord
belongs_to :app
validates :app_id, presence: true
end
