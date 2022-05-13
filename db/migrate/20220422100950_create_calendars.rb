class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :calendars do |t|
      t.references :owner, null: false, foreign_key: true
      t.string  :name, index: { unique: true, name: 'unique_calendar_name' }
      t.string  :domain_rule
      t.string  :url, index: { unique: true, name: 'unique_calendar_url' }
      t.text    :description
      t.integer :spot_time
      t.timestamps
    end
  end
end
