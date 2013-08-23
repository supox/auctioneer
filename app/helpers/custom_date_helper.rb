module CustomDateHelper
  def distance_of_time_in_words_to_now_with_future(from_time, include_seconds = false)
    if from_time > Time.now()
	    t 'time_experation_future', date: distance_of_time_in_words_to_now(from_time, include_seconds)
    else
	    t 'time_experation_past', date: distance_of_time_in_words_to_now(from_time, include_seconds)
    end
  end
end
