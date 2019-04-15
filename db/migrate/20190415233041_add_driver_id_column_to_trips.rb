class AddDriverIdColumnToTrips < ActiveRecord::Migration[5.2]
  def change
    add_reference :trips, :driver, foreign_key: true
  end
end
