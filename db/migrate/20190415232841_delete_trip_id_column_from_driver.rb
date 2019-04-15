class DeleteTripIdColumnFromDriver < ActiveRecord::Migration[5.2]
  def change
    remove_column :drivers, :trip_id
  end
end
