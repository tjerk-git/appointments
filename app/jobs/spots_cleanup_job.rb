class SpotsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Spot.delete_old_spots
  end
end
