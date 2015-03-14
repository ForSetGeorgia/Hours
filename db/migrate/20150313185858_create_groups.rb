class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.boolean :active

      t.timestamps null: false
    end

    create_table :projects_groups, id: false do |t|
      t.belongs_to :projects, index: true
      t.belongs_to :groups, index: true
    end
  end
end
