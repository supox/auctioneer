class Auction < ActiveRecord::Base
	attr_accessible :date_closed, :date_opened, :item_attributes
	
	has_one :item, dependent: :destroy
	has_many :bids, dependent: :destroy
	
	validates :date_opened, presence: true
	validates :item, presence: true
	validates_uniqueness_of :item_id
	validate :times_validation

	accepts_nested_attributes_for :item
	
	def bid(params)
		raise 'Auction Closed' unless open?
		self.bids.build(params)
	end
	
	def winning_bid
		self.bids.where(["withraw = ?", false]).order(:value).last
	end
	
	def open?
		self.date_opened <= DateTime.now && (self.date_closed.nil? || self.date_closed > DateTime.now)
	end
	
	def close!
		self.date_closed= DateTime.now
	end
	protected
	def times_validation
		errors.add(:end_time, I18n.t("errors.messages.greater_than", count: I18n.t(:date_closed))) unless date_closed.nil? || date_closed >= date_opened
	end

end
