class HamakiTestController < ApplicationController

 def remove_everything
    Spot.delete_all
    Calendar.delete_all
    Owner.delete_all
  end
  
end
