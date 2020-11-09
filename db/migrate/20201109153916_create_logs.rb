class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.integer :app_id
      t.text :content
      t.timestamps
    end
    add_index :logs, :app_id
  end
end
