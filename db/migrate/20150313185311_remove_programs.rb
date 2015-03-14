class RemovePrograms < ActiveRecord::Migration
  def up
    drop_table :programs
    remove_column :projects, :program_id
  end

  def down
    create_table :programs do |t|
      t.string :name
      t.boolean :active
    end
    add_column :projects, :program_id, :integer
  end
end
