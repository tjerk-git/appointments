class InstallationController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  skip_before_action :verify_authenticity_token
  before_action :authenticate, except: [:get_spots]
  before_action :check_owner, only: [:get_spots]

  SUPER_DUPER_SECRET_KEY = 'b222d98b-23af-4f1b-ab93-47202a3a9b41'.freeze
  require 'securerandom'

  def index
    @owner = Owner.new
    @owner.uuid = generate_uuid
    @owner.app_id = params[:app_id]
    ## @todo, add cleanup later, what happens if not unique?
    @owner.user_id = generate_uuid

    return unless @owner.save

    render json: @owner
  end

  # param with the date and http_token with the owner
  def get_spots
    data = JSON.parse(request.raw_post)
    calendars = @owner.calendars
    spots  = { spots: []}
    changed_spots = []

    if data['last_updated_at'] == "nil"
      last_updated_at = 0
    else
      last_updated_at = Time.at(data['last_updated_at']).to_datetime
    end

    return unless calendars

    ## changed spots wordt overschreven
    calendars.each do |calendar|
      if last_updated_at
        changed_spots = calendar.spots.where('updated_at > ?', last_updated_at)
      else
        changed_spots = calendar.spots
      end

      changed_spots.each do |spot|
        spots[:spots] << spot
      end
    end

    render :json => spots
  end

  private
  def check_owner
    authenticate_or_request_with_http_token do |token|
      @owner = Owner.find_by_uuid(token)
    end
  end

  def generate_uuid
    SecureRandom.uuid
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      token == SUPER_DUPER_SECRET_KEY
    end
  end
end
