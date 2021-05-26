class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :telegram_id, null: false, index: { unique: true }
      t.integer :words_per_day
      t.string :aasm_state

      t.timestamps
    end
  end
end
