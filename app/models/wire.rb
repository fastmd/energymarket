class Wire < ApplicationRecord
  has_many :lines, inverse_of: :wire
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :ro, presence: true, numericality: true
  validates :k_scr, presence: true, numericality: true
  validates :k_peb, presence: true, numericality: true
  validates :q, presence: true, numericality: {greater_than: 0}
end
