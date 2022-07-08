class Spot < ApplicationRecord
  belongs_to :calendar
  before_validation :create_slug

  # add sort by start_time
  scope :between, lambda {|start_date, end_date, calendar_id|
    where("calendar_id = ? AND start_date >= ? AND end_date <= ? AND visitor_email = '' OR vistior_email = NULL AND status = '' ",
    calendar_id, start_date, end_date )}

  def self.find_week(start_time, number_of_weeks=1, calendar_id)
    first_day_of_period = start_time - start_time.wday.days
    first_day_of_period_midnight = Time.utc(first_day_of_period.year, first_day_of_period.month, first_day_of_period.day)
    last_day_of_period_midnight = first_day_of_period_midnight + number_of_weeks.weeks

    spots = Spot.between(first_day_of_period_midnight, last_day_of_period_midnight, calendar_id)
    #spots = Spot.all
    # this is how i want it please <3
    # spots = { days: [
    #   { day: "14 mei", spots: [
    #     Spot.find(33),
    #     Spot.find(34),
    #   ] },
    #   { day: "15 mei", spots: [
    #     Spot.find(36),
    #     Spot.find(37),
    #   ]}
    # ]}
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
    "#{start_date.to_s.downcase.parameterize.tr('_', '')}-#{rand(100_000).to_s(26)}"
  end


end
