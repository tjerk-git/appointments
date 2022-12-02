namespace :spots do
  desc "delete spots last 30 days"
  task delete_old_spots: :environment do
    Spot.delete_old_spots
  end
end