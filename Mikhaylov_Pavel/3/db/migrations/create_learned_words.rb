# frozen_string_literal: true

require_relative '../../connection'

class CreateLearnedWords < ActiveRecord::Migration[6.0]
  def up
    create_table :learned_words do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :word, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
    drop_table :learned_words
  end
end

# CreateLearnedWords.new.down
CreateLearnedWords.new.up
