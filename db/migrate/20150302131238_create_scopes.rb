class CreateScopes < ActiveRecord::Migration
  def change
    create_table :scopes do |t|
      t.string :name
      t.integer :sort_order, default: 0

      t.timestamps
    end

    add_index :scopes, [:sort_order, :name]

    add_column :timestamps, :scope_id, :integer
    add_index :timestamps, :scope_id
  end
end
