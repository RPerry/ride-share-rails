class AddDeletedColumnToDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :deleted, :boolean
  end
end
