class Owner < ApplicationRecord
  has_many :calendars, dependent: :destroy
end
