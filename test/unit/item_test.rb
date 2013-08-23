require 'test_helper'

class ItemTest < ActiveSupport::TestCase
def setup
		@item = items(:one)
	end

	test "should response" do
		methods =[:auction, :description]
		methods.each do |meth|
			assert_respond_to @item, meth
		end
	end

	test "should be valid" do
		assert @item.valid?
	end

	test "desciption mustn't be nil" do
		@item.description  = nil
		refute @item.valid?
		@item.description = "My description"
		assert @item.valid?
	end
	
	test "description validation" do
		["desc", "12345", "34343"*50, "desd sd asdefw !!!~"].each do |desc|
			@item.description = desc
			assert @item.valid?, "#{desc} should be valid description."
		end
		["", "    ", "34343"*5000 ].each do |desc|
			@item.description = desc
			refute @item.valid?, "#{desc} should be invalid description."
		end	
	end
	
	test "to_s should be equal to description" do
		["desc", "12345", "34343"*50, "desd sd asdefw !!!~"].each do |desc|
			@item.description = desc
			assert_equal desc, @item.to_s
		end
	end
end
