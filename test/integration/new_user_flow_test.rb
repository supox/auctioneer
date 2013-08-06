require 'test_helper'

class NewUserTest < ActionDispatch::IntegrationTest

  test "should get new user" do
  	get new_user_path
    assert_response :success  	   
  	assert_match "user_name", response.body  	
 	end
 	
 	test "should create user" do
  	visit new_user_path
    fill_in('user_email', :with => "hugo@gmail.com")
    fill_in('user_name', :with => "Hugo")
    fill_in('user_phone', :with => "052-8741422")
    fill_in('user_password', :with => "ilan1234")
    fill_in('user_password_confirmation', :with => "ilan1234")
		click_on 'submit'
		
    assert page.has_content?("User was successfully created")
 	end
 	
end

