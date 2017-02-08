class Lnparam < ApplicationRecord
  belongs_to :mpoint
  validates_associated :mpoint
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
  validates :l, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :r, presence: true, numericality: true    
  validates :ro, presence: true, numericality: true
  validates :k_scr, presence: true, numericality: true
  validates :k_tr, presence: true, numericality: true
  validates :k_peb, presence: true, numericality: true
  validates :q, presence: true, numericality: true
  validates :k_f, presence: true, numericality: true
end
