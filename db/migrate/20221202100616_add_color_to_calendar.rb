class AddColorToCalendar < ActiveRecord::Migration[7.0]
  def change
    add_column :calendars, :color, :string, :default => ""
  end
end