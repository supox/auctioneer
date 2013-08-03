require 'test_helper'
include SessionsHelper
	
class BidsControllerTest < ActionController::TestCase
  setup do
    @bid = bids(:one)
    @auction = @bid.auction
    @user = @bid.user
    sign_in @user
  end

  test "should get index" do
	  get(:index, {auction_id:@auction.id})

    assert_response :success
    assert_not_nil assigns(:bids)
    assert_not_nil assigns(:auction)
  end

  test "should get new" do
    get(:new, {auction_id:@auction.id})
    assert_response :success
  end

  test "should create bid" do
    assert_difference('Bid.count') do    	
	  	bid_params = { offer_date: @bid.offer_date, value: @bid.value, withraw: @bid.withraw }
      post(:create, {auction_id:@auction.id, bid:bid_params})
    end

		assert_equal(assigns(:bid).user, @user)
    assert_redirected_to auction_bid_path(@auction, assigns(:bid))
  end

	test "should show bid" do
    get :show, {auction_id:@auction.id, id: @bid}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {auction_id:@auction.id, id: @bid}
    assert_response :success
  end

  test "should update bid" do
    put :update, {auction_id:@auction.id, id: @bid}, bid: { offer_date: @bid.offer_date, value: @bid.value, withraw: @bid.withraw }
    assert_redirected_to auction_bid_path(@auction, assigns(:bid))
  end

  test "should destroy bid" do
    assert_difference('Bid.count', -1) do
      delete :destroy, {auction_id:@auction.id, id: @bid}
    end

    assert_redirected_to auction_bids_path @auction
  end
  
  test "should be valid user" do
		sign_out

  	[:index, :new].each do |method|
			get(method, {auction_id:@auction.id})
	  	assert_redirected_to signin_path
  	end
  	[:show, :edit].each do |method|
			get(method, {auction_id:@auction.id, id:@bid.id})
	  	assert_redirected_to signin_path
  	end

    delete :destroy, {auction_id:@auction.id, id: @bid}
  	assert_redirected_to signin_path
  	
  	bid_params = { offer_date: @bid.offer_date, value: @bid.value, withraw: @bid.withraw }
    post(:create, {auction_id:@auction.id, bid:bid_params})
  	assert_redirected_to signin_path
    put :update, {auction_id:@auction.id, id: @bid}, bid:bid_params
  	assert_redirected_to signin_path
   end
  
end
