class Trparam < ApplicationRecord
  belongs_to :mpoint
  validates_associated :mpoint  
  belongs_to :transformator, -> { where(f: true).order('unom','snom','ukz') }, class_name: "Transformator", inverse_of: :trparams, foreign_key: "transformator_id"
  validates_associated :transformator
  validates :transformator_id, presence: true, numericality: { only_integer: true }
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
end
