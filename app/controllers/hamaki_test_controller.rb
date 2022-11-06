class HamakiTestController < ApplicationController

 def remove_everything
    Spot.delete_all
    Calendar.delete_all
    Owner.delete_all
    render :nothing
  end

  def get_calendars
    @calendars = Calendar.all
    render json: @calendars.as_json(include: [:owner, :spots])
  end
  
end
