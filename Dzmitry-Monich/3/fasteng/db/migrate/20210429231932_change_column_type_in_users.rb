class ChangeColumnTypeInUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :telegram_id, :string, null: false
    add_column :users, :telegram_id, :integer, null: false
    add_index :users, :telegram_id, unique: true
  end

  def down
    remove_column :users, :telegram_id, :integer, null: false
    add_column :users, :telegram_id, :string, null: false
    add_index :users, :telegram_id, unique: true
  end
end
