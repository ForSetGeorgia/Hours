class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :programs, :name
    add_index :programs, :active
  end
end
