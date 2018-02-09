class Minput < ApplicationRecord
  after_initialize :set_defaults
    
  belongs_to :mpoint, inverse_of: :minputs
  validates :mdate, presence: true 
  validates :mpoint_id, presence: true

  private
  def set_defaults
    self.f = true if self.new_record?
  end 
    
end
