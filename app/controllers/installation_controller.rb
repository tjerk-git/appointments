class InstallationController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate
  SUPER_DUPER_SECRET_KEY = 'b222d98b-23af-4f1b-ab93-47202a3a9b41'.freeze
  require 'securerandom'

  def index
    @owner = Owner.new
    @owner.uuid = generate_uuid
    @owner.name = 'Raymond' ## @TODO, make this real.
    @owner.app_id = params[:app_id]

    return unless @owner.save

    render json: @owner
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      token == SUPER_DUPER_SECRET_KEY
    end
  end

  def generate_uuid
    SecureRandom.uuid
  end
end

