class RemoveProjectFields < ActiveRecord::Migration
  def up
    remove_index :projects, :project_type_id
    remove_column  :projects, :project_type_id

    remove_index :timestamps, :project_id
    remove_column  :timestamps, :project_id

    add_column :timestamps, :activity_id, :integer
    add_index :timestamps, :activity_id
  end

  def down
    add_column  :projects, :project_type_id, :integer
    add_index :projects, :project_type_id

    add_column :timestamps, :project_id, :integer
    add_index :timestamps, :project_id

    remove_index :timestamps, :activity_id
    remove_column :timestamps, :activity_id
  end
end
