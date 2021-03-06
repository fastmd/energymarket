class Line < ApplicationRecord
  belongs_to :wire, -> { where("f=true").order('q','ro','name') }, class_name: "Wire", inverse_of: :lines, foreign_key: "wire_id"
  belongs_to :mesubstation, -> { where("f=true").order('filial_id','region_id','name') }, class_name: "Mesubstation", inverse_of: :lines, foreign_key: "mesubstation_id"
  belongs_to :mesubstation2, -> { where("f=true").order('filial_id','region_id','name') }, class_name: "Mesubstation", inverse_of: :lines, foreign_key: "mesubstation2_id", optional: true
  has_many  :lnparams, inverse_of: :line
  has_many  :vlnparams, inverse_of: :line
  has_many  :valllnparams, inverse_of: :line
  has_many  :mpoints, through: :lnparams, inverse_of: :line
  validates_associated :wire
  validates :wire_id, presence: true, numericality: { only_integer: true }
  validates_associated :mesubstation, class_name: "Mesubstation", foreign_key: "mesubstation_id"
  validates :name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :mesubstation_id, presence: true, numericality: { only_integer: true }
  validates :mesubstation2_id, presence: false, numericality: { allow_nil: true, only_integer: true }
  validates :l, presence: true, numericality: true
  validates :k_tr, presence: true, numericality: true
  validates :k_f, presence: true, numericality: true
end
