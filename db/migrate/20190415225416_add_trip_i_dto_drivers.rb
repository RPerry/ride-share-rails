class AddTripIDtoDrivers < ActiveRecord::Migration[5.2]
  def change
    add_reference :drivers, :trip, foreign_key: true
  end
end
