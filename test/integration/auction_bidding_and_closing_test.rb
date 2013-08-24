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
 
  def create_new_auction
  	# make sure user is admin.
  	@user.admin!
  	@user.save!
		sign_in @user

		# create action
		visit new_auction_path
		fields = {
			'date_opened' => DateTime.now.to_s,
			'date_closed' => '', 
			'item_attributes_description' => 'description'
		}
		fields.each do |key, value|
			fill_in("auction_#{key}", with: value)
		end
		click_on 'auction_submit_action'
 	
		auction_id = current_path[/\/auctions\/(\d+)/,1]
		@auction = Auction.find_by_id(auction_id) || raise("can't find auction id")
  end
  
  def close_auction
		visit edit_auction_path(@auction)
		fill_in("auction_date_closed", with: DateTime.now.to_s)  	
		click_on 'auction_submit_action'
		assert_equal auction_path(@auction), current_path		
  end
  
  def bid_to_auction(value)
		visit new_auction_bid_path(@auction)
		# post bid
		fill_in("bid_value", with: value)
		click_on 'bid_submit_action'
  end
    
  def create_bid(value)
  	auction = get_auction
  	bid = auction.build_bid(value)
  	auction.save!
  	bid
  end
  
end
