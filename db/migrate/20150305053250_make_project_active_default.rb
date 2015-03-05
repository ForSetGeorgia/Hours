class MakeProjectActiveDefault < ActiveRecord::Migration
  def up
    change_column :projects, :active, :boolean, default: true
  end

  def down
    # do nothing
  end
end
