class Transformator < ApplicationRecord
  has_many  :trparams, inverse_of: :transformator
  has_many  :mpoints, through: :trparams, inverse_of: :transformator
  validates :name, presence: true
  validates :pxx, presence: true, numericality: true
  validates :pkz, presence: true, numericality: true
  validates :snom, presence: true, numericality: true
  validates :ukz, presence: true, numericality: true
  validates :i0, presence: true, numericality: true
  validates :qkz, presence: true, numericality: {greater_than_or_equal_to: 0}  
end
