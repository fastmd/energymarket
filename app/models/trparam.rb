class Trparam < ApplicationRecord
  belongs_to :mpoint
  validates_associated :mpoint  
  belongs_to :transformator
  validates_associated :transformator
  validates :transformator_id, presence: true, numericality: { only_integer: true }
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
end
