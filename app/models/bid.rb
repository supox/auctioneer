class Bid < ActiveRecord::Base
	attr_accessible :auction_id, :offer_date, :user, :value, :withraw
  	belongs_to :auction
  	has_one :user
	default_scope order: 'offer_date'
	validates :value, presence: true, :numericality => {:greater_than_or_equal_to => 0}
	after_initialize :set_defaults
	
	protected
	def set_defaults
		self.offer_date ||= DateTime.now
		self.withraw = false unless self.withraw
	end

end
