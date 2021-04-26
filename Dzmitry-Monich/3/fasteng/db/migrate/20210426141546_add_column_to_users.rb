class AddColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :schedule, :string
    add_column :users, :current_time, :integer
  end
end
