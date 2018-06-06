class Mproperty < ApplicationRecord
  belongs_to :mpoint, inverse_of: :mproperties
  validates  :voltcl, presence: true, numericality: {:greater_than_or_equal_to => (0.4), :less_than_or_equal_to => 35}
  validates  :mpoint_id, presence: true, numericality: { only_integer: true }
  validates  :cosfi, presence: false, numericality: {:greater_than_or_equal_to => (-1), :less_than_or_equal_to => 1}, allow_blank: true
  validates  :propdate, presence: true
  after_initialize :set_default

  def set_default
      if self.propdate.nil? then self.propdate = DateTime.current().beginning_of_day() end
      if self.voltcl.nil? then self.voltcl = 10 end
      return true
  end
end
