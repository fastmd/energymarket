class Line < ApplicationRecord
  belongs_to :wire, -> { where("f=true").order('q','ro','name') }, class_name: "Wire", inverse_of: :lines, foreign_key: "wire_id"
  belongs_to :mesubstation, -> { where("f=true").order('filial_id','region_id','name') }, class_name: "Mesubstation", inverse_of: :lines, foreign_key: "mesubstation_id"
  has_many  :lnparams, inverse_of: :line
  has_many  :mpoints, through: :lnparams, inverse_of: :line
  validates_associated :wire
  validates :wire_id, presence: true, numericality: { only_integer: true }
  validates_associated :mesubstation
  validates :name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :mesubstation_id, presence: true, numericality: { only_integer: true }
  validates :l, presence: true, numericality: true
  validates :k_tr, presence: true, numericality: true
  validates :k_f, presence: true, numericality: true
end
