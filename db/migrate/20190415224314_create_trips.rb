class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.date :date
      t.float :rating
      t.float :cost

      t.timestamps
    end
  end
end
