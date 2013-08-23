# -*- coding: utf-8 -*-

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "distance_of_time_in_words_to_now_with_future" do
  	future_time = DateTime.current + 1.day
  	past_time = DateTime.current - 1.day
		now_time = DateTime.current
		
  	assert_match "בעוד", distance_of_time_in_words_to_now_with_future(future_time)
  	assert_match "לפני", distance_of_time_in_words_to_now_with_future(past_time)
  	assert_match "לפני", distance_of_time_in_words_to_now_with_future(now_time)
  end
  
end
