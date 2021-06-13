class RemoveConversationStatusForUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :conversation_status
  end
end
