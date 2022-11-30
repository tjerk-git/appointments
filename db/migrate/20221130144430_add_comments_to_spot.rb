class AddCommentsToSpot < ActiveRecord::Migration[7.0]
  def change
    add_column :spots, :comment, :text, :default => ""
  end
end
