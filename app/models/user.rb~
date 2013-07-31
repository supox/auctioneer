class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation, :phone
	has_secure_password
	
	has_many :bids, dependent: :destroy

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

	validates_format_of :phone, 
		:message => I18n.t("errors.messages.invalid_type"),
		:with => /^[\(\)0-9\- \+\.]{10,20}$/ 

	validates_length_of :name, in: 4..50, allow_blank: false

	validates_presence_of :password, :on => :create
	validates_presence_of :password_confirmation, :on => :create
	validates_length_of :password, in: 6..32, allow_blank: true
	
	before_validation :strip_whitespace
	private
	def sstrip str
		str.respond_to?('strip')? str.strip : str
	end
	def strip_whitespace
	  	self.name = sstrip self.name
	  	self.phone = sstrip self.phone
	  	self.email = sstrip self.email	  	
  	end


end
