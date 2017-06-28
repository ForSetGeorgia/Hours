class AddNotes < ActiveRecord::Migration
  def change
    add_column :projects, :notes, :text
    add_column :activities, :notes, :text
  end
end
