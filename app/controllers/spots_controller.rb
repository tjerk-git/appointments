class SpotsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  skip_before_action :verify_authenticity_token
  before_action :authenticate
  skip_before_action :authenticate, only: [:show, :index, :reserve, :complete]

  def index
      @spots = Spot.all
  end

  def show
    url_params = params[:calendar_id] + "/" + params[:name]
    calendar = Calendar.find_by_url(url_params)
    @spots = Spot.find_week(Time.now(), calendar.id)
  end

  def delete_spots
    return unless @owner
    # loop through spot_ids from this owner
      data = JSON.parse(request.raw_post)

      data["spot_ids"].each do |id|
        spot = Spot.where(owner_id: @owner.id, id: id)
        if spot
          spot.status = "delete"
          spot.save
        end
      end
  end

  def reserve
    spot = Spot.find(params[:spot_id])
    spot.visitor_name = params[:visitor_name]
    ## Check domain verification in model
    spot.visitor_email = params[:visitor_email]
    spot.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("sign_up_results", partial: "messages/sign_up_complete", locals: { spot: spot })
      end
    end
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
