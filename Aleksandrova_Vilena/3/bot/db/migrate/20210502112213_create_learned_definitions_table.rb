class CreateLearnedDefinitionsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :learned_definitions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :definition, null: false, foreign_key: true
      t.integer :sent_qty, null: true, default: 0
      t.integer :received_qty, null: true, default: 0
      t.boolean :missed_notification, null: true, default: false

      t.timestamps
    end
  end
end
