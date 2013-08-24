module IntegrationTestsHelper
	def sign_in user
		unless user.password
			user.password = user.password_confirmation = "pass1234" 
			user.save!
		end
  	visit signin_path
  	fill_in("session_email", with: user.email)
  	fill_in("session_password", with: user.password)
		click_on 'session_submit_action'
	end
end

