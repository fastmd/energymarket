class Trparam < ApplicationRecord
  belongs_to :mpoint
  validates_associated :mpoint
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
  validates :pxx, presence: true, numericality: true
  validates :pkz, presence: true, numericality: true
  validates :snom, presence: true, numericality: true
  validates :ukz, presence: true, numericality: true
  validates :io, presence: true, numericality: true
  validates :qkz, presence: true, numericality: {greater_than_or_equal_to: 0}
end
