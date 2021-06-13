class AddAasmStateForUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :aasm_state, :string
  end
end
