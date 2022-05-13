class AddClientIdToCalendar < ActiveRecord::Migration[7.0]
  def change
    add_column :calendars, :client_id, :string, :default => ""
  end
end
