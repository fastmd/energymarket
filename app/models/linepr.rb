class Linepr < ApplicationRecord
  belongs_to :mpoint
  validates_associated :mpoint
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
  validates :l1, presence: true, numericality: {greater_than_or_equal_to: 0}  
  validates :p1, presence: true, numericality: true
end
