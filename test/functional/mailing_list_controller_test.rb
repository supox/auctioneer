require 'test_helper'
include SessionsHelper

class MailingListControllerTest < ActionController::TestCase

  setup do
    @auction = auctions(:one)
    @user = users(:one)
    sign_in @user
  end

	test "should add to mailing list" do
    put(:create, auction_id:@auction)
    assert @auction.listeners.include?(@user)
	end

	test "should remove from mailing list" do
    put(:create, auction_id:@auction)
    mail_list_id = @auction.listeners.find(@user)
    delete(:destroy, auction_id:@auction, id:mail_list_id)
    refute @auction.listeners.include?(@user)
	end

	test "should not add to mailing list if not signed in" do
		sign_out
    put(:create, auction_id:@auction)
  	assert_redirected_to signin_path		
	end
	
end
