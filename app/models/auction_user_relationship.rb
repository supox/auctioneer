class AuctionUserRelationship < ActiveRecord::Base
  belongs_to :listener, class_name: "User"
  belongs_to :auction
  validates :listener_id, presence: true
  validates :auction_id, presence: true
end
