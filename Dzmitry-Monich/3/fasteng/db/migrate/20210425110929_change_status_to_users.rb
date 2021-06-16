class ChangeStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :status, from: 'registered', to: 'new'
  end
end
