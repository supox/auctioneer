class AuctionMailer < ActionMailer::Base
 default from: "noreply@auctioneer.com"
  
  def email_new_bid(user, bid)
    @user=user
    @bid=bid
    @auction = bid.auction
    @url=auction_path(bid.auction)
    to=user.email
    mail(:to => to, :subject => I18n.t(:new_bid_notification))
  end
end

