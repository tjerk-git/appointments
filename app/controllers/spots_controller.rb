class SpotsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  skip_before_action :verify_authenticity_token
  before_action :authenticate
  skip_before_action :authenticate, only: [:show, :index]

  def index
      @spots = Spot.all
  end

  def show
    url_params = params[:calendar_id] + "/" + params[:name]
    calendar = Calendar.find_by_url(url_params)
    @spots = Spot.find_week(Time.now(), calendar.id)
  end

  def create
    return unless @owner

    data = JSON.parse(request.raw_post)
    result = create_spots_from_blocks(data)

    render :json => result
  end

  private

  def create_spots_from_blocks(data)
    result = []

    data.each do |calendar|
      time_per_block = calendar['timePerSpotInMinutes']
      result_calendar = Hash.new
      result_calendar[:calendar_id] = calendar['id']
      result_calendar[:created_blocks] = []
      calendar['blocks'].each do |block|
        created_block = Hash.new
        created_block[:block_id] = block["blockId"]
        created_block[:spots] = []
        @calendar = Calendar.find_by_client_id(calendar['id'])
        start_time = Time.at(block['startTime']).to_datetime
        end_time = Time.at(block['endTime']).to_datetime
        minutes_between = ((end_time - start_time) * 24 * 60).to_i
        total_spots = minutes_between / time_per_block -1

        # Create first
        spot = Spot.new
        spot.calendar = @calendar
        spot.start_date = Time.at(block['startTime']).to_datetime
        spot.end_date = start_time + time_per_block.minutes
        spot.save
        created_block[:spots] << spot

        #create rest
        total_spots.times do
          last_spot = Spot.last
          spot = Spot.new
          spot.calendar = @calendar
          spot.start_date = last_spot.end_date.to_datetime
          spot.end_date = last_spot.end_date.to_datetime + time_per_block.minutes

          created_block[:spots] << spot
          spot.save
        end
        result_calendar[:created_blocks] << created_block
      end
      result << result_calendar
    end
    result
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      @owner = Owner.find_by_uuid(token)
    end
  end

  def get_decoded_params(blocks)
    JSON.parse(blocks)
  end

end
