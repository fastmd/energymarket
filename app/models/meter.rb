class Meter < ApplicationRecord
  belongs_to :mpoint
  has_many :mvalues
end
