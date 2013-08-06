require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
  	get root_path
		assert_response :success		
	end

  test "should get home signed in" do
  	# create user
  	user_params = { email: "my_mail@gmail.com", name: "my_name", password: "1234567", password_confirmation: "1234567", phone: "012-234-567" }
  	post_via_redirect users_path, {user:user_params}
  	user = User.find_by_email(user_params[:email])

  	# login user
  	params = {session:{email:user_params[:email], password:user_params[:password]}}
		post_via_redirect sessions_path, params
		assert_equal user_path(user), path
		
		# check that root path redirct to user
  	get root_path
    assert_redirected_to user_path(user)
	end

  test "should get contact" do
  	get contact_path
		assert_response :success
	end

  test "should get about" do
  	get about_path
		assert_response :success  	
	end

end
