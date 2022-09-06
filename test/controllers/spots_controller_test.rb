require "test_helper"

class SpotsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    owner = Owner.new()
    owner.uuid = "b222d98b-23af-4f1b-ab93-47202a3a9b41"
    owner.app_id = "211312312312"
    owner.name = "test"
    owner.email = "test@test.nl"
    owner.description = "something"
    owner.user_id = "2d15e94d-d949-498c-9e8e-b6c828365485"

    owner.save

    calendar = Calendar.new()
    calendar.client_id = "2d15e94d-d949-498c-9e8e-b6c828365485"
    calendar.owner = owner
    calendar.save
  end

  test "create" do
    block = Hash.new
    calendar = Hash.new
    recipe = Hash.new
    tommorow = Time.now + 1*60*60
    block["startTime"] = Time.now.to_i
    block["endTime"] = tommorow.to_i
    #block["startTime"] = 1662811200
    #block["endTime"] = 1662814800
    block["id"] = "012923BD-C2CC-4DFA-88F7-8ADDEFA818B7"
    recipe["timePerSpot"] = 20
    calendar["recipe"] = recipe
    calendar["blocks"] = [block]
    calendar["id"] = "2d15e94d-d949-498c-9e8e-b6c828365485"
    json = [calendar].to_json

    
	assert_difference -> { Spot.count } => 3 do 
		post '/spots',
    headers: { 'Authorization':  'Token 		b222d98b-23af-4f1b-ab93-47202a3a9b41'},
    params: json	
		assert true
	end
  end
end
