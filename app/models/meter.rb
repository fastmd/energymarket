class Meter < ApplicationRecord
  belongs_to :mpoint, inverse_of: :meters
  has_many :mvalues, inverse_of: :meter
  belongs_to :thesauru, inverse_of: :meters
  validates :comment, length: { maximum: 30 }
  validates :mpoint_id, presence: true
end
