class CreateDefinitionsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :definitions do |t|
      t.string :letter, null: false
      t.string :word, null: false
      t.text :description, null: false

      t.timestamps
    end
    add_index :definitions, :word
  end
end
