class AddAvailableColumnToDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :available, :boolean
  end
end
