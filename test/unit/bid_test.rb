require 'test_helper'

class BidTest < ActiveSupport::TestCase
	def setup
		@auction = auctions(:one)
		@bid = bids(:one)
		@user = users(:one)
	end

	test "should response" do
		methods =[:auction, :user, :value, :withraw, :offer_date]
		methods.each do |meth|
			assert_respond_to @bid, meth
		end
	end

	test "should be valid" do
		assert @bid.valid?
	end

	test "value mustn't be nil" do
		@bid.value  = nil
		refute @bid.valid?
		@bid.value = 14
		assert @bid.valid?
	end
	
	test "default values" do
		b = Bid.new(value:13)
		refute b.withraw
		range = (DateTime.now.at_beginning_of_hour..DateTime.now) 
		assert range.cover?(b.offer_date)
		
		d = DateTime.yesterday.to_datetime
		v = 56
		b2 = Bid.new({offer_date:d, value:v, withraw:true})
		assert_equal v, b2.value
		assert_equal d, b2.offer_date
		assert_equal true, b2.withraw
	end
end
