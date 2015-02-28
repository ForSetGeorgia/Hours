class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :organization_id
      t.string :name
      t.text :description
      t.boolean :valid

      t.timestamps
    end
    add_index :projects, :organization_id
  end
end
