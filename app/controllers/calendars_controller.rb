class CalendarsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def create
    return unless @owner

    @calendar = Calendar.create
    data = JSON.parse(params[:calendar])
    @calendar.name = data['name']
    url = @owner.user_id + "/" + data['name'].parameterize(separator: '-')
    @calendar.url = url
    @calendar.client_id = data['id']
    @calendar.description = data['description']
    @calendar.owner = @owner

    return unless @calendar.save

    render json: @calendar
  end


  def update 
    return unless @owner
    @calendar = Calendar.find_by_client_id(params[:id])
    if @calendar.owner == @owner 
      data = JSON.parse (request.raw_post)
      @calendar.description = data["description"]
      # @calendar.location = data["location"]
      @calendar.save
    else 
      puts "Calendar is van iemand anders of zo"
    end
  end

  def destroy 
    return unless @owner
    @calendar = Calendar.find_by_client_id(params[:id])
    if @calendar.owner == @owner 
      @calendar.spots.each {|s| s.delete}
      @calendar.delete
    end
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
