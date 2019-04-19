class Trip < ApplicationRecord
  belongs_to :driver, required: false
  belongs_to :passenger, required: false

  validates :date, presence: true
  validates :driver_id, :numericality => { :only_integer => true, :greater_than => 0 }
end
