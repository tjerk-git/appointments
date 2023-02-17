class HamakiTestController < ApplicationController
 skip_before_action :verify_authenticity_token  

 def remove_everything
    Spot.delete_all
    Calendar.delete_all
    Owner.delete_all
    head :ok, content_type: "text/html"  end

  def get_calendars
    @calendars = Calendar.all
    render json: @calendars.as_json(include: [:owner, :spots])
  end
  
  def reserve_spot
    @spot = Spot.find(params[:id])
    @spot.visitor_email = "test@example.com"
    @spot.visitor_name = "Test user"
    @spot.comment = "This is a comment of the test user"
    @spot.save
  end
  
end
