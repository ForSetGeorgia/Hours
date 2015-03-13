class RenameProjectsGroupsToGroupsProjects < ActiveRecord::Migration
  def change
    rename_table :projects_groups, :groups_projects
  end
end
