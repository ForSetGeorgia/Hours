class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :project
      t.references :project_type
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :activities, :project_id
    add_index :activities, :project_type_id
    add_index :activities, :name
    add_index :activities, :active
  end
end
