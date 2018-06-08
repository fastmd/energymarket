class Mesubstation < ApplicationRecord
  belongs_to :filial, -> { order('name') }, inverse_of: :mesubstations, foreign_key: "filial_id"
  belongs_to :region, -> { where(name: 'region', f: true).order('cvalue') }, class_name: "Region", inverse_of: :mesubstations, foreign_key: "region_id"
  has_many   :mpoints, inverse_of: :mesubstation
  has_many   :vallmpoints, inverse_of: :mesubstation
  has_many   :vmpoints, inverse_of: :mesubstation
  has_many   :lines, inverse_of: :mesubstation, class_name: "Mesubstation", foreign_key: "mesubstation_id"
  has_many   :lines, inverse_of: :mesubstation, class_name: "Mesubstation", foreign_key: "mesubstation2_id"
  validates :name, presence: true
  validates :filial_id, presence: true
end
