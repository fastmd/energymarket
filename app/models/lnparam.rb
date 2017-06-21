class Lnparam < ApplicationRecord
  belongs_to :mpoint
  validates_associated :mpoint
  belongs_to :line, -> { where("f=true").order('mesubstation_id','id') }, class_name: "Line", inverse_of: :lnparams, foreign_key: "line_id"
  belongs_to :vallline, class_name: "Vallline", inverse_of: :lnparams, foreign_key: "line_id"
  validates_associated :line
  validates :line_id, presence: true, numericality: { only_integer: true } 
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
  scope :created_before, ->(time) { where("created_at < ?", time) }
end
