class SpotsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  skip_before_action :verify_authenticity_token
  before_action :authenticate
  skip_before_action :authenticate, only: [:show, :index]

  def create
    return unless @owner

    #blocks = get_decoded_params(params[:blocks])
    data = JSON.parse(request.raw_post)
    create_spots_from_blocks(data)

    @spots = Spot.where(:calendar_id => @calendar.id)

    render json: @spots
  end

  def index
      @spots = Spot.all
  end

  private

  def create_spots_from_blocks(data)

    data.each do |calendar|
      time_per_block = calendar['timePerSpotInMinutes']

      calendar['blocks'].each do |block|
      @calendar = Calendar.find_by_client_id(calendar['id'])
      start_time = Time.at(block['startTime']).to_datetime
      end_time = Time.at(block['endTime']).to_datetime
      minutes_between = ((end_time - start_time) * 24 * 60).to_i
      total_spots = minutes_between / time_per_block -1

      # Create first
      spot = Spot.new
      spot.calendar = @calendar
      spot.start_date = start_time
      spot.end_date = start_time + time_per_block.minutes
      spot.save

      #create rest
      total_spots.times do
        last_spot = spot
        spot = Spot.new
        spot.calendar = @calendar
        spot.start_date = last_spot.end_date.to_datetime
        spot.end_date = last_spot.end_date.to_datetime + time_per_block.minutes
        spot.save
      end

    end

    end
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
