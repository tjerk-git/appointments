require "test_helper"

class InstallationControllerTest < ActionDispatch::IntegrationTest
  test "register" do
	assert_difference("Owner.count") do 
		get '/register/300', headers: { 'Authorization':  'Token 		b222d98b-23af-4f1b-ab93-47202a3a9b41'}	
		assert true
	end
  end
end
