class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
