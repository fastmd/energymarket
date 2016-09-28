class Company < ApplicationRecord
  has_many :mpoints, dependent: :destroy
end
