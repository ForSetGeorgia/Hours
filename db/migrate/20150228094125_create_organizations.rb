class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :long_name
      t.string :short_name

      t.timestamps
    end
  end
end
