require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = users(:one)
	end

	test "should response" do
		methods =[:email, :name, :phone, :password, :password_confirmation, :password_digest, 
		:bids, :remember_token, :admin]
		methods.each do |meth|
			assert_respond_to @user, meth
		end
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "remember_token" do
		@user.save!
		refute @user.remember_token.nil?, "Remember token doesnt exists."
		assert @user.remember_token.length > 4
	end
	
	test "check reset password send mail" do
		@user.create_reset_code
		mail = ActionMailer::Base.deliveries.last
		assert_equal @user.email, mail.to.first
		assert_match(@user.reset_password_token, mail.body.encoded)
	end

	test "check got reset password" do
		@user.create_reset_code
		
		refute @user.reset_password "wrong key", "password", "password"
		refute @user.reset_password_token.nil?
		assert @user.reset_password @user.reset_password_token, "password", "password"
		assert @user.reset_password_token.nil?
	end
	
	test "invalid email" do
		mails = ["a@gm.com", "ila@walla.co.il", "ilan.ben.hagai@gmail.com", "f33121.fdf@wa.wa.wa.co.il"]
		mails.each do |mail|
			@user.email = mail
			assert @user.valid?
		end

		invalid_mails = ["a", "@walla.co.il", "avvvv", nil, ""]
		invalid_mails.each do |mail|
			@user.email = mail
			assert (!@user.valid?)
		end
	end
	
	test "invaild phones" do
		phones = ["052-8741422", "0528741422", "052-8-741-422", "04-6731839", "+972-8741422"]
		phones.each do |phone|
			@user.phone = phone
			assert @user.valid?
		end

		invalid_phones = ["a", "052", "0528741422a", "254"*10, nil, "", "          "]
		invalid_phones.each do |phone|
			@user.phone = phone
			assert (!@user.valid?)
		end
	end

	test "invaild names" do
		names = ["Alian Delon", "Dani", "Arno dd"]
		names.each do |name|
			@user.name = name
			assert(@user.valid?, "Name \"#{name}\" should be valid")
		end

		invalid_names = ["a", "a"*51, nil, "", "          "]
		invalid_names.each do |name|
			@user.name = name
			assert (!@user.valid?), "Name \"#{name}\" should be invalid"
		end
	end

	test "invaild password" do
		passwords = ["123456", "dani1982", "dan dan dd d3333"]
		passwords.each do |password|
			@user.password = password
			@user.password_confirmation = password
			assert(@user.valid?, "Password \"#{password}\" should be valid")
		end

		invalid_passwords = ["1234", "13"*50]
		invalid_passwords.each do |password|
			@user.password = password
			@user.password_confirmation = password
			assert (!@user.valid?), "Password \"#{password}\" should be invalid"
		end

		@user.password = "123456"
		@user.password_confirmation = "1234567"
		assert (!@user.valid?), "Password mismatch should be invalid"
	end

	test "duplicated mail" do
		user1 = User.new
		user1.name = :name1
		user1.phone = "0528741422"
		user1.email = "mail@gmail.com"
		user1.password = "pass1234"
		user1.password_confirmation = "pass1234"
		user1.save!

		user2 = User.new
		user2.name = :name2
		user2.phone = "0528331422"
		user2.email = user1.email
		user2.password = "pass123"
		user2.password_confirmation = "pass123"
		
		assert(!user2.valid?, "same mail should be invalid.")
	end
	
	test "admin toggle" do
		refute @user.admin?
		
		@user.admin!
		@user.save!
		@user.reload
		assert @user.admin?
	end
end

