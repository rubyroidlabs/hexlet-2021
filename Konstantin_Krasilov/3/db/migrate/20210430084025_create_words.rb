class CreateWords < ActiveRecord::Migration[6.1]
  def up
    create_table :words do |t|
      t.string :value
      t.text :meaning

      t.timestamps
    end
  end

  def down
    drop_table :words
  end
end
