class CreateProjectTypes < ActiveRecord::Migration
  def change
    create_table :project_types do |t|
      t.string :name

      t.timestamps
    end

    add_index :project_types, :name

    add_column :projects, :project_type_id, :integer
    add_index :projects, :project_type_id
  end
end
