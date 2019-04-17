
class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true

  def total_earnings
    earnings = 0
    cost_array = []
    self.trips.each do |t|
      t.cost.each do |c|
        cost_array << c
      end
    end

    cost_array.each do |c|
      earnings += c
    end

    return earnings
  end

  def average_rating
    average = 0
    rating_array = []
    number_of_trips = self.trips.find_by(driver_id: self.id).length
    self.trips.each do |t|
      t.rating.each do |r|
        rating_array << r
      end
    end

    rating_array.each do |r|
      average += r
    end
    return average / number_of_trips
  end
end
