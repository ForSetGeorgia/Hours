class AddProgramIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :program_id, :integer
    add_index :projects, :program_id
  end
end
