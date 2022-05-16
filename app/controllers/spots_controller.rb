class SpotsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  skip_before_action :verify_authenticity_token
  before_action :authenticate
  skip_before_action :authenticate, only: %i[show index]

  def create
    return unless @owner

    data = JSON.parse(request.raw_post)
    result = create_spots_from_blocks(data)
    render json: result
  end

  def index
    @spots = Spot.all
  end

  private

  # rubocop:disable MethodLength, AbcSize
  def create_spots_from_blocks(data)
    result = []

    data.each do |calendar|
      @calendar = Calendar.find_by_client_id(calendar['id'])
      result_calendar = create_result_calendar(calendar['id'])

      calendar['blocks'].each do |block|
        created_block = { block_id: block['id'], spots: [] }
        total_spots = Spot.calculate_total_spots(
          Time.at(block['startTime']).to_datetime,
          Time.at(block['endTime']).to_datetime,
          calendar['timePerSpotInMinutes']
        )

        end_date = Time.at(block['startTime']).to_datetime + calendar['timePerSpotInMinutes'].minutes
        spot = Spot.create_spot(Time.at(block['startTime']).to_datetime, end_date, @calendar)
        created_block[:spots] << spot

        # create rest
        total_spots.times do
          last_spot = spot
          start_date = last_spot.end_date.to_datetime
          end_date = last_spot.end_date.to_datetime + calendar['timePerSpotInMinutes'].minutes
          created_block[:spots] << Spot.create_spot(start_date, end_date, @calendar)
        end
        result_calendar[:created_blocks] << created_block
      end
      result << result_calendar
    end
    result
  end

  # rubocop:enable
  def create_result_calendar(id)
    { calendar_id: id, created_blocks: [] }
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
