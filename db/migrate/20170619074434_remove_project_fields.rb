class RemoveProjectFields < ActiveRecord::Migration
  def up
    remove_index :projects, :project_type_id
    remove_column  :projects, :project_type_id

    remove_index :timestamps, :project_id
    remove_column  :timestamps, :project_id

  end

  def down
    add_column  :projects, :project_type_id, :integer
    add_index :projects, :project_type_id

    add_index :timestamps, :project_id, :integer
    add_column  :timestamps, :project_id
  end
end
