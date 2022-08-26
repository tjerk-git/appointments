class RemoveUniqueFromNameCalendar < ActiveRecord::Migration[7.0]
  def change
    remove_index :calendars, name: "unique_calendar_name"
  end
end
