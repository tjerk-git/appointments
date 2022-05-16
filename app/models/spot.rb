class Spot < ApplicationRecord
  belongs_to :calendar

  def self.create_spot(start_date, end_date, calendar)
    spot = Spot.new
    spot.start_date = start_date
    spot.end_date = end_date
    spot.calendar = calendar
    spot.save
    spot
  end

  def self.calculate_total_spots(start_date, end_date, time_per_block)
    minutes_between = ((end_date - start_date) * 24 * 60).to_i
    (minutes_between / time_per_block) - 1
  end
end
