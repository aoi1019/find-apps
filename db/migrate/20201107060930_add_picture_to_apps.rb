class AddPictureToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :picture, :string
  end
end
