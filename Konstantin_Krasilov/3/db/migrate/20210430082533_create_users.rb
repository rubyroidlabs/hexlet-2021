class CreateUsers < ActiveRecord::Migration[6.1]
  def up
    create_table :users do |t|
      t.integer :telegram_id, null: false, index: { unique: true }
      t.integer :max_words, null: false, default: 1
      t.integer :conversation_status, null: false, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
