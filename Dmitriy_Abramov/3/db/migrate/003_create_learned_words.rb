# frozen_string_literal: true

require 'active_record'
require_relative '../connection'

class CreateLearnedWords < ActiveRecord::Migration[6.1]
  def change
    create_table :learned_words do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :word, null: false, foreign_key: true
      t.timestamps
    end
  end
end
