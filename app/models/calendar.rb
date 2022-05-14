class Calendar < ApplicationRecord
  belongs_to :owner
  has_many :spots
end
