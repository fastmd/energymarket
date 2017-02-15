class Meter < ApplicationRecord
  belongs_to :mpoint
  has_many :mvalues
  validates :comment, length: { maximum: 30 }
  validates :mpoint_id, presence: true
end
