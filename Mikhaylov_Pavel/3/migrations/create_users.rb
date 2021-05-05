# frozen_string_literal: true

require_relative '../connection'

class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.string :name
      t.integer :telegram_id, null: false, index: { unique: true }
      t.integer :words_per_day

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end

CreateUsers.new.down
CreateUsers.new.up
