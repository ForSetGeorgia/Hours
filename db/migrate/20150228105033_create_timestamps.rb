class CreateTimestamps < ActiveRecord::Migration
  def change
    create_table :timestamps do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :diff_level
      t.integer :duration
      t.text :notes

      t.timestamps
    end
    add_index :timestamps, :project_id
    add_index :timestamps, :user_id
  end
end
