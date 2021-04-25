class RenameColumnStateToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :state, :status
  end
end
