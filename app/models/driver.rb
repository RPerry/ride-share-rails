
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

    return to_dollars(earnings)
  end

  def average_rating
    if self.trips.all.empty? || self.trips.all.first.rating.nil?
      return 0.0
    else
      average = 0.0
    number_of_trips = self.trips.all.length
    self.trips.all.each do |t|
        if t.rating.nil?
          number_of_trips - 1
        else
          average += t.rating
        end
    end
   
    return (average / number_of_trips)
    end
  end

  def self.first_available_driver
    return Driver.where(available: true).sample
  end
end

def to_dollars(cost)
  return (cost/100).round(2)
end
