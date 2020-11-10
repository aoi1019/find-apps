class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.text :description
      t.text :point
      t.text :reference
      t.integer :period
      t.text :memo
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_index :apps, [:user_id, :created_at]
  end
end
