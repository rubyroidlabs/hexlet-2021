class CreateUserWords < ActiveRecord::Migration[6.1]
  def up
    create_table :user_words do |t|
      t.references :user, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :user_words
  end
end
