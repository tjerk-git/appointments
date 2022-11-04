class HamakiTestController < ApplicationController

 def remove_everything
    Spot.delete_all
    Calendar.delete_all
    Owner.delete_all
  end

  def get_calendars
    @calendars = Calendar.all
    render :json => @calendars.includes(:owner => :owner).includes(:spots => :spots)
  end
  
end
