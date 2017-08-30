class AddParentIdToTimestamp < ActiveRecord::Migration
  def change
    add_column :timestamps, :parent_id, :integer
  end
end
