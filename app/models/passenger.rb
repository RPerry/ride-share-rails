class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true

  def total_fare
    fare = 0.0
    self.trips.each do |t|
        fare += t.cost
    end

    return to_dollars(fare)
  end
end
