require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest

  test "should get new user" do
  	get new_user_path
    assert_response :success  	   
  	assert_match "user_name", response.body  	
 	end
 	
 	test "should create user" do
  	visit new_user_path
 		fields.each do |key, value|
	    fill_in("user_#{key}", :with => value)
    end
		click_on 'user_submit_action'
		
    assert page.has_content?("User was successfully created")
 	end

 	test "should not create user" do
	 	# iterate all keys, fill with one missing each time
 		fields.each do |missing_key, missing_value|
			visit new_user_path
	 		fields.each do |key, value|
	 			next if missing_key==key
			  fill_in("user_#{key}", :with => value)
		  end
			click_on 'user_submit_action'
			assert_match find("#user_#{missing_key}")['class'], "error"
    end
	end
	
	test "should edit user" do
		user = get_user
		sign_in user
  	visit edit_user_path user.id
		new_mail = "new_email@gmail.com"
		fields.merge({email: new_mail}).each do |key, value|
	    fill_in("user_#{key}", :with => value)
    end
		click_on 'user_submit_action'
		
		assert_match user_path(user), current_url
		user.reload
		assert_equal new_mail, user.email
	end
	
	test "should sign in" do
		user = get_user
				
		sign_in user
		assert_match user_path(user), current_url
	end

	test "should not sign in" do
		user = get_user

		user.password = "wrong_password"
		sign_in user
		assert_not_match user_path(user), current_url
	end
	
	def sign_in user		
  	visit signin_path
  	fill_in("session_email", with: user.email)
  	fill_in("session_password", with: user.password)
		click_on 'session_submit_action'
	end
	
 	def fields
 		{email:"hugo@gmail.com", name:"Hugo", phone:"052-8741422", password:"ilan1234", password_confirmation:"ilan1234"}
 	end
 	
 	def get_user
		user = users(:one)
		user.password = user.password_confirmation = "ilan1234"
		user.save!
		user 	
 	end
end

