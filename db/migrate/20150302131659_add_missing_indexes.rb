class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :organizations, :long_name
    add_index :organizations, :short_name

    add_index :projects, :name
    add_index :projects, :active
  end
end
