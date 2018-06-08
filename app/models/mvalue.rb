class Mvalue < ApplicationRecord
  belongs_to :meter, inverse_of: :mvalues
  belongs_to :mpoint, inverse_of: :mvalues, optional: true
  validates :actp180, presence: true, numericality: {greater_than_or_equal_to: 0} 
  validates :actp280, presence: true, numericality: {greater_than_or_equal_to: 0}  
  validates :actp380, presence: true, numericality: {greater_than_or_equal_to: 0}  
  validates :actp480, presence: true, numericality: {greater_than_or_equal_to: 0}       
end
