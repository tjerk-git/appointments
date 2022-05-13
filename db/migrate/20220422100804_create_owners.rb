class CreateOwners < ActiveRecord::Migration[7.0]
  def change
    create_table :owners do |t|
      t.string :app_id, index: { unique: true, name: 'unique_apps' }
      t.string :uuid, index: { unique: true, name: 'uuid' }
      t.string  :url, index: { unique: true, name: 'unique_owner_url' }
      t.string  :name
      t.string  :email, index: { unique: true, name: 'unique_owner_email' }
      t.text    :description
      t.timestamps
    end
  end
end
