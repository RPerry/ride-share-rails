class Trip < ApplicationRecord
  belongs_to :driver, required: false
  belongs_to :passenger, required: false

  validates :date, presence: true
end
