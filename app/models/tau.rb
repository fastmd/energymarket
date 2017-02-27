class Tau < ApplicationRecord
  validates :tm, presence: true, numericality: { only_integer: true }
  validates :taum, presence: true, numericality: { only_integer: true }
end
