class RenameColumnsInGroupsProjects < ActiveRecord::Migration
  def change
    rename_column :groups_projects, :projects_id, :project_id
    rename_column :groups_projects, :groups_id, :group_id
  end
end
