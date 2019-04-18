
class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true

  def total_earnings
    earnings = 0.0
    self.trips.each do |t|
     driver_earnings = ((t.cost - 1.65) * 80) / 100
      earnings += driver_earnings
    end

    return earnings
  end

  def average_rating
    average = 0.0
    number_of_trips = self.trips.all.length
    self.trips.all.each do |t|
        average += t.rating
    end
   
    return average / number_of_trips
  end

  def self.first_available_driver
    return Driver.where(available: true).first
  end
end
