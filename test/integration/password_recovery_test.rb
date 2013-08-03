require 'test_helper'

class PasswordRecoveryTest < ActionDispatch::IntegrationTest
	setup do
		@user= users(:one)
	end

  test "signin should have forgot path" do
  	get signin_path
  	assert_match forgot_path, body
 	end
 	
 	test "should get forgot" do
  	get forgot_path
    assert_response :success  	   
 	end

	test "should post forgot invalid user" do
		invalid_email = "not.exists@gmail.com"
		assert_no_difference 'ActionMailer::Base.deliveries.size' do
	  	post forgot_path, {user: {email: invalid_email}}
  	end
  	assert_equal forgot_path, path
	end

 	test "should post forgot" do
		assert_difference 'ActionMailer::Base.deliveries.size', +1 do
	  	post_via_redirect forgot_path, {user: {email: @user.email}}
  	end
    assert_response :success
    
    # validate email
    user = User.find_by_email(@user.email)
		forgot_email = ActionMailer::Base.deliveries.last
		assert_equal user.email, forgot_email.to.first
		assert_match(user.reset_password_token, forgot_email.body.encoded)
 	end
 	
 	test "should get reset password" do
 		# start with reset
		@user.create_reset_code
 		get reset_path(@user.reset_password_token)
		assert_response :success
 	end

 	test "should put reset password" do
 		original_digest = @user.password_digest
 	
		@user.create_reset_code
 		put reset_path(@user.reset_password_token), {user:{password:"password",password_confirmation:"password"}}
		assert_redirected_to @user
		
		#validate password changed
		user = User.find_by_email(@user.email)
		refute_equal original_digest, user.password_digest
 	end

	test "should reset password invalid token" do
		invalid_tokens = [" ", "asdfg", "a"*50]
		invalid_tokens.each do |token|
			get reset_path(token)
			assert_redirected_to root_path
			put reset_path(token), {user:{password:"password",password_confirmation:"password"}}
			assert_redirected_to root_path
			put reset_path(token), {reset_code: token}			
			assert_redirected_to root_path
		end
	end
	
end

