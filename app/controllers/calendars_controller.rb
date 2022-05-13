class CalendarsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  def create
    return unless @owner

    @calendar = Calendar.create
    data = get_decoded_params(params[:calendar])
    @calendar.name = data.name
    @calendar.url = data.name.parameterize(separator: '-')
    @calendar.client_id = data.id
    @calendar.owner = @owner

    return unless @calendar.save

    render json: @calendar
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token|
      @owner = Owner.find_by_uuid(token)
    end
  end

  def get_decoded_params(calendar)
    json.decode(calendar)
  end
end
