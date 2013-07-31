class Item < ActiveRecord::Base
  attr_accessible :description
  belongs_to :auction
  validates_length_of :description, in: 3..500, allow_blank: false
  validates :auction, presence: true

  before_validation :strip_whitespace

  private
  def strip_whitespace
  	self.description = self.description.strip if self.description.respond_to?('strip')
  end

end

