class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :projects, :valid, :active
  end
end
