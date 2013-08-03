require 'test_helper'
include SessionsHelper

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

	def get_params
		{ email: "my_mail@gmail.com", name: "my_name", password: "1234567", password_confirmation: "1234567", phone: "012-234-567" }
	end

  test "should get index" do
  	sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: get_params
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
  	sign_in @user
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
  	sign_in @user
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
  	sign_in @user
    put :update, id: @user, user: get_params
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
  	sign_in @user
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
