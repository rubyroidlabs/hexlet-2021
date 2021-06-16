class AddScheduleAndUpcomingTimeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :schedule, :string
    add_column :users, :upcoming_time, :integer
  end
end
