class CreateLearnedWords < ActiveRecord::Migration[6.0]
  def change
    create_table :learned_words do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :word, foreign_key: true, null: false

      t.timestamps
    end
  end
end
