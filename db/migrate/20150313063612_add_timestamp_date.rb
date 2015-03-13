class AddTimestampDate < ActiveRecord::Migration
  def up
    add_column :timestamps, :date, :date
    add_index :timestamps, :date

    # move all created_at dates to date
    Timestamp.transaction do
      Timestamp.all.each do |timestamp|
        timestamp.date = timestamp.created_at.to_date
        timestamp.save
      end
    end

  end

  def down
    remove_index :timestamps, :date
    remove_column :timestamps, :date
  end
end
