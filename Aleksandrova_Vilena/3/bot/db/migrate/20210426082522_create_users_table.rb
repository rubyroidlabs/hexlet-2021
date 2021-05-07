class CreateUsersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :telegram_id, null: false
      t.integer :status, null: true, default: 0
      t.integer :repeat_qty, null: true, default: 0

      t.timestamps
    end
    add_index :users, :telegram_id, unique: true
  end
end
