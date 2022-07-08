class AddSlugToSpots < ActiveRecord::Migration[7.0]
  def change
    add_column :spots, :slug, :string, :default => ""
  end
end
