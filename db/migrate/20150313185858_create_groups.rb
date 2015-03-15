class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_index :groups, :name
    add_index :groups, :active

    create_table :projects_groups, id: false do |t|
      t.belongs_to :projects, index: true
      t.belongs_to :groups, index: true
    end
  end
end
