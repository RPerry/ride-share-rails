class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
end
