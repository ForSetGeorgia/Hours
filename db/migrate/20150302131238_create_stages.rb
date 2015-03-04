class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :name
      t.integer :sort_order, default: 0

      t.timestamps
    end

    add_index :stages, [:sort_order, :name]

    add_column :timestamps, :stage_id, :integer
    add_index :timestamps, :stage_id
  end
end
