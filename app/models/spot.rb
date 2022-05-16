class Spot < ApplicationRecord
  belongs_to :calendar

  def create_spot(start_date, end_date, calendar)
    Create(start_date, end_date, calendar)
  end

  def calculate_total_spots(start_date, end_date, time_per_block)
    minutes_between = ((end_date - start_date) * 24 * 60).to_i
    (minutes_between / time_per_block) - 1
  end
end
