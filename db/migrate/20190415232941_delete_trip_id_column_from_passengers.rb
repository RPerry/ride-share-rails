class DeleteTripIdColumnFromPassengers < ActiveRecord::Migration[5.2]
  def change
    remove_column :passengers, :trip_id
  end
end
