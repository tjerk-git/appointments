class ChangeBlocksToSpots < ActiveRecord::Migration[7.0]
  def change
    rename_table :blocks, :spots
  end
end
