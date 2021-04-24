class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :telegram_id, null: false, index: { unique: true }
      t.string :state, default: 'registered'

      t.timestamps
    end
  end
end
