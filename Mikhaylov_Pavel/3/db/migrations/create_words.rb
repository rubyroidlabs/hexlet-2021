# frozen_string_literal: true

require_relative '../../connection'

class CreateWords < ActiveRecord::Migration[6.0]
  def up
    create_table :words do |t|
      t.string :value
      t.string :definition

      t.timestamps
    end
  end

  def down
    drop_table :words
  end
end

CreateWords.new.down
CreateWords.new.up
