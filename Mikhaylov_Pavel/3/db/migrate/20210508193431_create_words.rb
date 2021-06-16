class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :value, null: false
      t.string :definition, null: false

      t.timestamps
    end
  end
end
