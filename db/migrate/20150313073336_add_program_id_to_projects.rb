class AddProgramIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :program_id, :integer
  end
end
