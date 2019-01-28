class CreateDailyreports < ActiveRecord::Migration[5.2]
  def change
    create_table :dailyreports do |t|
      t.date :date_today  ,  null: false
      t.integer :count     ,         null: false

      t.timestamps
    end
  end
end
