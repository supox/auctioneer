require 'test_helper'
include SessionsHelper

class AuctionsControllerTest < ActionController::TestCase
  setup do
    @auction = auctions(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auctions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auction" do
		set_as_admin
  	
    assert_difference('Auction.count') do
      post :create, auction: auction_params
    end

    assert_redirected_to auction_path(assigns(:auction))
  end

  test "should not create auction if not admin" do
    assert_no_difference('Auction.count') do
      post :create, auction: auction_params
    end
  end


  test "should show auction" do
    get :show, id: @auction
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @auction
    assert_response :success
  end

  test "should update auction" do
    put :update, id: @auction, auction: auction_params
    assert_redirected_to auction_path(assigns(:auction))
  end

  test "should destroy auction" do
  	set_as_admin  	
    assert_difference('Auction.count', -1) do
      delete :destroy, id: @auction
    end

    assert_redirected_to auctions_path
  end

  test "should not destroy auction if not admin" do
    assert_no_difference('Auction.count') do
      delete :destroy, id: @auction
    end
  end
  
  test "should be valid user" do
		sign_out

  	[:index, :new].each do |method|
			get method
	  	assert_redirected_to signin_path
  	end
  	[:show, :edit].each do |method|
			get method, id: @auction
	  	assert_redirected_to signin_path
  	end

    delete :destroy, id:@auction
  	assert_redirected_to signin_path
  	
    post(:create, {auction:auction_params})
  	assert_redirected_to signin_path
    put(:update, {id:@auction.id, auction:auction_params})
  	assert_redirected_to signin_path
   end
  
  	def auction_params
			{ date_closed: @auction.date_closed, date_opened: @auction.date_opened, opened: @auction.opened }  	
  	end
  	
  	def set_as_admin
		 	current_user.admin!
			current_user.save!
			sign_in current_user  	
  	end
  
end
