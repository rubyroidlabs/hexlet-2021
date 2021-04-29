class CreateTableLearnedWords < ActiveRecord::Migration[6.0]
  def change
    create_table :learned_words do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :definition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
