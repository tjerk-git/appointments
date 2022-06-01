class RemoveUniqueFromVisitorEmail < ActiveRecord::Migration[7.0]
  def change
    remove_index :spots, name: "unique_visitor_email"
  end
end
