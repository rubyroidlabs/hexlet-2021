# frozen_string_literal: true

require 'active_record'
require_relative '../connection'

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :uid, null: false
      t.integer :daily_words_count
      t.string :aasm_state
    end

    add_index :users, :uid, unique: true
  end
end
