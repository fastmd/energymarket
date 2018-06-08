class Meter < ApplicationRecord
  belongs_to :mpoint, inverse_of: :meters
  has_many :mvalues, inverse_of: :meter
  belongs_to :thesauru, inverse_of: :meters
  validates :comment, length: { maximum: 30 }
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
  validates :meternum, presence: true, numericality: { only_integer: true }
  #validates :beforedigs, presence: true, numericality: { only_integer: true }
  #validates :afterdigs, presence: true, numericality: { only_integer: true }
  validates :koeftt, presence: true
  validates :koeftn, presence: true
  validates :koefcalc, presence: true
  validates :thesauru_id, presence: true, numericality: { only_integer: true }
  validates :relevance_date, presence: true
end
