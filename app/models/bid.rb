class Bid < ActiveRecord::Base
	attr_accessible :offer_date, :value, :withraw, :user, :auction
  	belongs_to :auction
  	belongs_to :user
	default_scope order: 'offer_date'
	validates :value, presence: true, :numericality => {:greater_than_or_equal_to => 0}
	validates :user, presence: true
	validates :auction, presence: true
	
	after_initialize :set_defaults
	
	protected
	def set_defaults
		self.offer_date ||= DateTime.now
		self.withraw = false unless self.withraw
	end

end
