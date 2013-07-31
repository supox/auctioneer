require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
	def setup
		@auction = auctions(:one)
		@user = users(:one)
	end

	test "should response" do
		methods =[:date_closed, :date_opened, :opened, :item, :bids]
		methods.each do |meth|
			assert_respond_to @auction, meth
		end
	end

	test "should be valid" do
		assert @auction.valid?
	end

	test "times_diff" do
		@auction.date_opened= DateTime.now
		@auction.date_closed= DateTime.yesterday
		refute @auction.valid?
		@auction.date_closed= DateTime.tomorrow
		assert @auction.valid?
	end
	
	test "item mustn't be nil" do
		@auction.item = nil
		refute @auction.valid?
		@auction.item = Item.new({:description => "desc"})
		assert @auction.valid?
	end
	
	
	def create_bid(value)
		Bid.new({value:value})
	end
	
	def create_bids(values)
		values.collect{|val| create_bid(val)}
	end

	test "open?" do
		@auction.date_closed = nil
		assert @auction.open?
		@auction.date_closed = DateTime.tomorrow
		assert @auction.open?
		@auction.date_closed = DateTime.yesterday
		refute @auction.open?
		@auction.date_opened = DateTime.tomorrow
		@auction.date_closed = DateTime.tomorrow
		refute @auction.open?
	end
	
	def test_bid
		# test zero
		assert_equal(0, @auction.bids.size)

		# test one
		b = create_bid(12)
		@auction.bid(b)
		assert_equal(1, @auction.bids.size)
		assert_equal(b, @auction.bids.first)

		# test many
		@auction.bids.clear
		bids = create_bids((1..15).to_a)
		bids.each{|b| @auction.bid(b)}
		assert_equal(bids, @auction.bids)
	end

	def test_win_bid
		@auction.bids.clear
		assert_nil(@auction.winning_bid)

		# test one
		b = create_bid(12)
		@auction.bid(b)		
		assert_equal(12, @auction.winning_bid[:value])

		# test of lower value
		@auction.bid(create_bid(11))
		assert_equal(12, @auction.winning_bid[:value])

		# test of higher value
		@auction.bid(create_bid(13))
		assert_equal(13, @auction.winning_bid[:value])

		# test many
		create_bids([1, 100, 4, 50, 6, 103, 6]).each{|b| @auction.bid(b)}
		assert_equal(103, @auction.winning_bid[:value])
	end

	test "automatic date assignment" do
		# custom date
		b = create_bid(12)
		time = DateTime.new(2010)
		b.offer_date = time
		@auction.bid(b)
		assert_equal(time, @auction.bids.first.offer_date)
	
		# automatic date
		@auction.bids.clear
		start_time = DateTime.now
		b2 = create_bid(13)
		@auction.bid(b2)
		date_range = (start_time..DateTime.now)
		assert(date_range.cover?(@auction.bids.first.offer_date), "automatic date assign failed")
	end

	def test_open
		@auction.date_opened = DateTime.yesterday
		@auction.date_closed = nil
		assert @auction.open?
		@auction.date_opened = DateTime.tomorrow
		@auction.date_closed = nil
		refute @auction.open?
		@auction.date_opened = DateTime.yesterday
		@auction.date_closed = DateTime.tomorrow
		assert @auction.open?
		@auction.date_opened = 2.days.ago
		@auction.date_closed = DateTime.yesterday
		refute @auction.open?
		
		@auction.date_opened = DateTime.yesterday
		@auction.date_closed = nil
		@auction.close!
		refute @auction.open?
		assert_raise(RuntimeError){
			@auction.bid(create_bid(12))
		}

	end	
end

