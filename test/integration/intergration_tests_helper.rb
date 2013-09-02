module IntegrationTestsHelper

	def sign_in user
		unless user.password
			user.password = user.password_confirmation = "pass1234" 
			user.save!
		end
  	visit signin_path
  	fill_in("session_email", with: user.email)
  	fill_in("session_password", with: user.password)
		click_on 'session_submit_action'
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
	
end

