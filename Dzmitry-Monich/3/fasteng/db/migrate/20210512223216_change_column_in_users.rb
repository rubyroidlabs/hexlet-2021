class ChangeColumnInUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :schedule, :string
    add_column :users, :words_count, :integer
  end

  def down
    remove_column :users, :words_count, :integer
    add_column :users, :schedule, :string
  end
end
