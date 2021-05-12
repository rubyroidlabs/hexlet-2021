# frozen_string_literal: true

require 'active_record'
require_relative '../connection'

class CreateWords < ActiveRecord::Migration[6.1]
  def change
    create_table :words do |t|
      t.string :value, null: false
      t.text :description, null: false
    end

    add_index :words, :value, unique: true
  end
end
