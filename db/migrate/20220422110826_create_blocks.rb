class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.references :calendar, null: false, foreign_key: true
      t.string  :visitor_name
      t.string  :visitor_email, index: { unique: true, name: 'unique_visitor_email' }
      t.datetime :start_date 
      t.datetime :end_date
      t.timestamps
    end
  end
end
