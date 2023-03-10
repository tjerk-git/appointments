class AddLocationToSpots < ActiveRecord::Migration[7.0]
  def change
     add_column :spots, :location, :string, :default => ""
  end
end
