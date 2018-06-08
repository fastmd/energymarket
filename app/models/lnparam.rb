class Lnparam < ApplicationRecord
  belongs_to :mpoint, inverse_of: :lnparams
  validates_associated :mpoint
  belongs_to :line, -> { where("f=true").order('mesubstation_id','id') }, class_name: "Line", inverse_of: :lnparams, foreign_key: "line_id"
  belongs_to :vallline, class_name: "Vallline", inverse_of: :lnparams, foreign_key: "line_id", inverse_of: :lnparams
  validates_associated :line
  validates :line_id, presence: true, numericality: { only_integer: true } 
  validates :mpoint_id, presence: true, numericality: { only_integer: true }
  scope :created_before, ->(time) { where("created_at < ?", time) }
  validates  :condate, presence: true
  after_initialize :set_default

  def set_default
      if self.condate.nil? then self.condate = DateTime.current().beginning_of_day() end
      return true
  end  
end
