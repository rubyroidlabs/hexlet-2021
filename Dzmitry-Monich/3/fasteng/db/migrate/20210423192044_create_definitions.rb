class CreateDefinitions < ActiveRecord::Migration[6.0]
  def change
    create_table :definitions do |t|
      t.string :word, null: false, index: { unique: true }
      t.text :description, null: false

      t.timestamps
    end
  end
end
