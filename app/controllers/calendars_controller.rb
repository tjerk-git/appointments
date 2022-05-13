class CalendarsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def create
    return unless @owner

    @calendar = Calendar.create
    data = get_decoded_params(params[:calendar])
    @calendar.name = data['name']
    url = @owner.user_id + "/" + data['name'].parameterize(separator: '-')
    @calendar.url = url
    @calendar.client_id = data['id']
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
    JSON.parse(calendar)
  end
end
