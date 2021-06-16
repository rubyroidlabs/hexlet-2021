class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :telegram_id, null: false, index: { unique: true }
      t.integer :words_per_day
      t.integer :state

      t.timestamps
    end
  end
end
