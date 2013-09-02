require 'test_helper'
class AuctionBiddingAndClosingTest < ActionDispatch::IntegrationTest
	setup do
		@user = users(:one)
		sign_in @user
		@auction = auctions(:one)
	end
	
  test "bid_to_auction_and_present_values_until_close" do
  	create_new_auction
  	# make sure that there is not currently winning bid:
  	visit auction_path(@auction)
		refute page.has_selector?('li.winning_bid')  	
		# verify that the bid button is exists
		page.assert_selector('div', text:I18n.t(:new_bid))

  	
		# make first bid
  	value = 100
		make_a_bid(value, value)

		# make a lower bid
		make_a_bid(value-20, value)

		# make a higher bid
  	value = value+20
		make_a_bid(value, value)
		
		# close auction
		close_auction
		
		# visit auction after closing
		visit auction_path(@auction)
		page.assert_selector('li.winning_bid', text: Regexp.new(value.to_s))
		# make sure that there is no "new_bid" button
		page.assert_no_selector('div', text:I18n.t(:new_bid))

		# post higher bid - show that fails due to close auction.
		make_a_bid(value+30, value)
		page.assert_selector('div#alert_box', text: I18n.t(:auction_closed))
  end
  
  def make_a_bid(value, expected_winning_value)
  	bid_to_auction value
		assert_equal auction_path(@auction), current_path
		page.assert_selector('li.winning_bid', text: Regexp.new(expected_winning_value.to_s))
  end
 
end
