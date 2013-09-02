require 'test_helper'
class AuctionMailNotificationTest < ActionDispatch::IntegrationTest
	setup do
		# Capybara.current_driver = :selenium
		@user = users(:one)
		sign_in @user
		@auction = create_new_auction
		@mailing_list_id = 'listen_form'
	end
	
	test "auction should have mail notification" do
 		 	
		# verify that the mail notification is exists
  	visit auction_path(@auction)
  	assert_equal :add, mailing_list_state
		click_button I18n.t(:add_to_mailing_list)
  	assert_equal :remove, mailing_list_state
		
		# register to mails, bid and expect to get emails
		bid_value=250
		assert_difference 'ActionMailer::Base.deliveries.size', +1 do	
			bid_to_auction(bid_value)
		end
		bid_email = ActionMailer::Base.deliveries.last
		assert_equal @user.email, bid_email.to.first
		assert_match(bid_value.to_s, bid_email.body.encoded)
		
		# unregister, make sure that bid won't send emails.
		visit auction_path(@auction)
  	assert_equal :remove, mailing_list_state
		click_button I18n.t(:remove_from_mailing_list)
  	assert_equal :add, mailing_list_state

		assert_no_difference 'ActionMailer::Base.deliveries.size' do	
			bid_to_auction(bid_value+30)
		end
		
		visit auction_path(@auction)
  	assert_equal :add, mailing_list_state
	end
	
	test "closed auction doesnt have mail notification" do
 		close_auction
  	visit auction_path(@auction)
  	assert_equal :none, mailing_list_state
	end
	
	def mailing_list_state
		return :add if page.has_button?(I18n.t(:add_to_mailing_list))
		return :remove if page.has_button?(I18n.t(:remove_from_mailing_list))
 		return :none
	end
end

