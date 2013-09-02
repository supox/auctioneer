require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
	def setup
		@auction = auctions(:one)
		@user = users(:one)
	end

	test "should response" do
		methods =[:date_closed, :date_opened, :item, :bids, :winning_bid, :open?, :close!, :listeners]
		methods.each do |meth|
			assert_respond_to @auction, meth
		end
	end

	test "should be valid" do
		assert @auction.valid?
	end

	test "times_diff" do
		@auction.date_opened= DateTime.now.to_datetime
		@auction.date_closed= DateTime.yesterday.to_datetime
		refute @auction.valid?
		@auction.date_closed= DateTime.tomorrow.to_datetime
		assert @auction.valid?
	end
	
	test "item mustn't be nil" do
		@auction.item = nil
		refute @auction.valid?
		@auction.item = Item.new({:description => "desc"})
		assert @auction.valid?
	end
	
	def create_bid(val, params={})
		default_params= {value:val, user:@user}
		@auction.bid(default_params.merge(params))
	end
	def create_bids(values)
		values.each{|val| create_bid(val)}
	end

	test "open?" do
		@auction.date_closed = nil
		assert @auction.open?
		@auction.date_closed = DateTime.tomorrow.to_datetime
		assert @auction.open?
		@auction.date_closed = DateTime.yesterday.to_datetime
		refute @auction.open?
		@auction.date_opened = DateTime.tomorrow.to_datetime
		@auction.date_closed = DateTime.tomorrow.to_datetime
		refute @auction.open?
	end
	
	def test_bid
		@auction.bids.clear
		@auction.save!
		# test zero
		assert_equal(0, @auction.bids.size)

		# test one
		create_bid(12)
		@auction.save!
		assert_equal(1, @auction.bids.size)
		assert_equal(12, @auction.bids.first.value)

		# test many
		@auction.bids.clear
		create_bids(1..15).to_a
		sum1 = (1..15).inject { |sum, n| sum + n }
		sum2 = @auction.bids.inject(0) { |sum, b| sum + b.value }      
		assert_equal(@auction.bids.size, 15)
		assert_equal(sum1, sum2)
	end

	def test_win_bid
		@auction.bids.delete_all
		@auction.save!
		assert_nil(@auction.winning_bid)

		# test one
		create_bid(12)
		@auction.save!
		assert_equal(12, @auction.winning_bid.value)

		# test of lower value
		create_bid 11
		@auction.save!
		assert_equal(12, @auction.winning_bid.value)

		# test of higher value
		create_bid 13
		@auction.save!
		assert_equal(13, @auction.winning_bid.value)

		# test many
		create_bids([1, 100, 4, 50, 6, 103, 6])
		@auction.save!
		assert_equal(103, @auction.winning_bid.value)

		# add withraw bid

		create_bid(300, withraw:true)
		@auction.save!
		assert_equal(103, @auction.winning_bid.value)
	end

	test "automatic date assignment" do
		# custom date
		offer_date = DateTime.new(2010).to_datetime
		create_bid(12, offer_date:offer_date)
		@auction.save!
		assert_equal(offer_date, @auction.bids.first.offer_date)
	
		# automatic date
		@auction.bids.clear
		start_time = DateTime.now.to_datetime
		create_bid(13)
		date_range = (start_time..DateTime.now.to_datetime)
		assert(date_range.cover?(@auction.bids.first.offer_date), "automatic date assign failed")
	end

	def test_open
		@auction.date_opened = DateTime.yesterday.to_datetime
		@auction.date_closed = nil
		assert @auction.open?
		@auction.date_opened = DateTime.tomorrow.to_datetime
		@auction.date_closed = nil
		refute @auction.open?
		@auction.date_opened = DateTime.yesterday.to_datetime
		@auction.date_closed = DateTime.tomorrow.to_datetime
		assert @auction.open?
		@auction.date_opened = 2.days.ago
		@auction.date_closed = DateTime.yesterday.to_datetime
		refute @auction.open?
		
		@auction.date_opened = DateTime.yesterday.to_datetime
		@auction.date_closed = nil
		@auction.close!
		refute @auction.open?
		assert_raise(RuntimeError){
			create_bid(13)
		}
	end
	
	test "it should have item" do
		@auction.item = nil
		refute @auction.valid?
		@auction.item = Item.new(description:"my item.")
		assert @auction.valid?
	end
	
	test "it should have mail notification list" do
		@auction.listeners<< @user
		@auction.save!
		assert_equal @user, @auction.listeners.first
	end
	
	test "it should send mail on bid" do
		@auction.listeners<< @user
		@auction.save!

		create_bid(bid_value = 12)
		@auction.save!
		
		mail = ActionMailer::Base.deliveries.last
		assert_equal @user.email, mail.to.first
		assert_match(Regexp.new(bid_value.to_s), mail.body.encoded)
	end
	
end

