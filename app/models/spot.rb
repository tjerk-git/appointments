
class Spot < ApplicationRecord
  belongs_to :calendar
  before_validation :create_slug
  
  validates :visitor_name, presence: true, on: :update

  # add sort by start_time
  scope :between, lambda {|start_date, end_date, calendar_id|
    where("calendar_id = ? AND start_date >= ? AND end_date <= ? AND status = ''",
    calendar_id, start_date, end_date )}

  def self.delete_old_spots
      Spot.where("start_date < ?", 30.days.ago).delete_all
  end

  def self.find_week(start_time, number_of_weeks=4, calendar_id)
    first_day_of_period = start_time - start_time.wday.days
    first_day_of_period_midnight = Time.utc(first_day_of_period.year, first_day_of_period.month, first_day_of_period.day)
    today = Date.today
    last_day_of_period_midnight = today + number_of_weeks.weeks

    spots = Spot.between(today, last_day_of_period_midnight, calendar_id).order(start_date: :asc)
    spots = spots.select { |s| s.status != "delete" }

    if !spots.empty?
      days = []
      start_date = spots[0].start_date
      spots_by_day = { days: [ { day: start_date, spots: [] } ] }
      days << start_date.day
      i = 0
      spots.each do |spot|
        unless days.include? spot.start_date.day
            days << spot.start_date.day
            spots_by_day[:days] << { day: spot.start_date, spots: [] }
            i += 1
        end
        spots_by_day[:days][i][:spots] << spot
      end
      spots_by_day
    end
  end
  
  def create_slug
    if slug.blank?
      self.slug = to_slug
    end
  end

  def to_slug
    fil_name = Faker::Music.album.parameterize(separator: '-')
    "#{SecureRandom.hex}-#{fil_name}"
  end

end
